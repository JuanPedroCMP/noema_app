import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/services/ai_background_work_scheduler.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_sync_service.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_linux/workmanager_linux.dart';

const automaticBackupPeriodicTask = 'noema.automaticBackup.periodic';
const automaticBackupOnExitTask = 'noema.automaticBackup.onExit';
const _automaticBackupPeriodicName = 'noema.automaticBackup.periodic';
const _automaticBackupOnExitName = 'noema.automaticBackup.onExit';

Duration? backupFrequencyDuration(String? frequency, int interval) {
  if (frequency == null || frequency == 'manual' || frequency == 'never') {
    return null;
  }
  if (interval < 1 || interval > 365) {
    throw RangeError.range(interval, 1, 365, 'interval');
  }

  return switch (frequency) {
    'daily' => const Duration(days: 1),
    'weekly' => const Duration(days: 7),
    'monthly' => const Duration(days: 30),
    'every_days' => Duration(days: interval),
    'every_hours' when interval <= 24 => Duration(hours: interval),
    'every_hours' => throw RangeError.range(interval, 1, 24, 'interval'),
    _ => throw ArgumentError.value(frequency, 'frequency'),
  };
}

Duration? backupScheduleDuration(Object? schedule, String? legacyFrequency) {
  if (schedule == null) return backupFrequencyDuration(legacyFrequency, 1);
  if (schedule is! Map) {
    throw const FormatException('A frequência de backup local é inválida.');
  }

  final unit = schedule['unit'];
  if (unit == 'never') return null;
  final interval = schedule['interval'];
  if (interval is! int) {
    throw const FormatException('O intervalo de backup local é inválido.');
  }
  if (unit == 'days' && interval >= 1 && interval <= 365) {
    return Duration(days: interval);
  }
  if (unit == 'hours' && interval >= 1 && interval <= 24) {
    return Duration(hours: interval);
  }
  throw const FormatException('A frequência de backup local é inválida.');
}

class AutomaticBackupScheduler {
  const AutomaticBackupScheduler(this._ref);

  final Ref _ref;

  Future<void> configureFromPreferences() async {
    if (!Platform.isAndroid && !Platform.isLinux) return;

    final preferences = await _currentPreferences();
    final frequency = readConfigPreference(preferences, 'backupFrequency');
    final schedule = readConfigPreference(preferences, 'backupSchedule');
    final duration = backupScheduleDuration(
      schedule,
      frequency is String ? frequency : null,
    );
    final workmanager = Workmanager();

    if (duration == null) {
      await workmanager.cancelByUniqueName(_automaticBackupPeriodicName);
    } else {
      await workmanager.registerPeriodicTask(
        _automaticBackupPeriodicName,
        automaticBackupPeriodicTask,
        frequency: duration,
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      );
    }

    final backupOnExit = readConfigPreference(preferences, 'backupOnExit');
    if (backupOnExit != true) {
      await workmanager.cancelByUniqueName(_automaticBackupOnExitName);
    }
  }

  Future<void> scheduleOnExit() async {
    if (!Platform.isAndroid && !Platform.isLinux) return;
    final preferences = await _currentPreferences();
    if (readConfigPreference(preferences, 'backupOnExit') != true) {
      return;
    }

    await Workmanager().registerOneOffTask(
      _automaticBackupOnExitName,
      automaticBackupOnExitTask,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
    );
  }

  Future<String> _currentPreferences() async {
    final user = await _ref.read(userProvider.future);
    final config = await ConfigDao(
      _ref.read(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }
    return config.preferences;
  }
}

final automaticBackupSchedulerProvider = Provider<AutomaticBackupScheduler>(
  AutomaticBackupScheduler.new,
);

final automaticBackupSchedulingLifecycleProvider = Provider<void>((ref) {
  final scheduler = ref.watch(automaticBackupSchedulerProvider);

  void configure() {
    unawaited(
      scheduler.configureFromPreferences().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        debugPrint('Falha ao agendar backup automático: $error');
        debugPrintStack(stackTrace: stackTrace);
      }),
    );
  }

  final observer = _AutomaticBackupLifecycleObserver(() {
    unawaited(
      scheduler.scheduleOnExit().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        debugPrint('Falha ao agendar backup ao sair: $error');
        debugPrintStack(stackTrace: stackTrace);
      }),
    );
  });
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
  ref.listen(userProvider, (_, next) {
    if (next.hasValue) configure();
  });
  configure();
});

class _AutomaticBackupLifecycleObserver extends WidgetsBindingObserver {
  _AutomaticBackupLifecycleObserver(this._onExit);

  final VoidCallback _onExit;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _onExit();
    }
  }
}

@pragma('vm:entry-point')
void automaticBackupTaskDispatcher() {
  Workmanager().executeTask(_runAutomaticBackupTask);
}

@pragma('vm:entry-point')
void automaticBackupLinuxTaskDispatcher() {
  WorkmanagerLinux.executeTask(_runAutomaticBackupTask);
}

Future<bool> _runAutomaticBackupTask(
  String task, [
  Map<String, dynamic>? _,
]) async {
  if (isAiBackgroundQueueWork(task)) {
    return _runAiBackgroundQueueTask();
  }
  if (task != automaticBackupPeriodicTask &&
      task != automaticBackupOnExitTask) {
    return true;
  }

  final container = ProviderContainer();
  try {
    final authenticated = await container.read(authStateProvider.future);
    if (!authenticated) return true;

    final user = await container.read(userProvider.future);
    final config = await ConfigDao(
      container.read(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }

    final frequency = readConfigPreference(
      config.preferences,
      'backupFrequency',
    );
    final schedule = readConfigPreference(config.preferences, 'backupSchedule');
    final backupOnExit = readConfigPreference(
      config.preferences,
      'backupOnExit',
    );
    if (task == automaticBackupPeriodicTask &&
        backupScheduleDuration(
              schedule,
              frequency is String ? frequency : null,
            ) ==
            null) {
      return true;
    }
    if (task == automaticBackupOnExitTask && backupOnExit != true) {
      return true;
    }

    final syncService = container.read(googleDriveSyncServiceProvider);
    final status = await syncService.getAccountStatus();
    if (!status.syncAvailable || status.accountId == null) return true;

    final preview = await syncService.prepareSync();
    try {
      if (preview.requiresDecision) {
        debugPrint(
          'Backup automático pausado: é necessária uma decisão de conflito.',
        );
        return true;
      }

      if (preview.metadataNeedsRepair && preview.diff?.isEmpty == true) {
        await syncService.resolve(
          preview,
          DriveSyncResolution.reconcileMetadata,
        );
        return true;
      }

      final resolution =
          preview.automaticResolution ??
          (preview.remoteSnapshot == null
              ? DriveSyncResolution.keepLocal
              : null);
      if (resolution == null) return true;

      await syncService.resolve(preview, resolution);
      return true;
    } finally {
      await syncService.disposePreview(preview);
    }
  } on DioException catch (error, stackTrace) {
    debugPrint(
      'Backup automático falhou por erro de rede '
      '(HTTP ${error.response?.statusCode ?? 'indisponível'}).',
    );
    debugPrintStack(stackTrace: stackTrace);
    return false;
  } on Object catch (error, stackTrace) {
    debugPrint('Backup automático falhou (${error.runtimeType}): $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  } finally {
    container.dispose();
  }
}

Future<bool> _runAiBackgroundQueueTask() async {
  final container = ProviderContainer(
    overrides: [aiBackgroundWorkerModeProvider.overrideWithValue(true)],
  );
  try {
    if (!await container.read(authStateProvider.future)) return true;
    final user = await container.read(userProvider.future);
    final runner = container.read(aiBackgroundTaskRunnerProvider);
    await runner.runNextReadyTask();
    final dao = AiBackgroundTaskDao(container.read(appDatabaseProvider));
    final ready = await dao.getReadyTasks(
      userId: user.id,
      now: DateTime.now().millisecondsSinceEpoch,
      limit: 1,
    );
    if (ready.isNotEmpty) {
      await scheduleAiBackgroundQueue(
        taskId: ready.first.id,
        initialDelay: const Duration(seconds: 2),
      );
    } else {
      final retryAt = await dao.getNextRetryAt(userId: user.id);
      if (retryAt != null) {
        final delay = Duration(
          milliseconds: (retryAt - DateTime.now().millisecondsSinceEpoch).clamp(
            1000,
            24 * 60 * 60 * 1000,
          ),
        );
        await scheduleAiBackgroundQueue(
          taskId: 'retry-$retryAt',
          initialDelay: delay,
        );
      }
    }
    return true;
  } on DioException catch (error, stackTrace) {
    debugPrint(
      'Worker de IA falhou por erro de rede '
      '(HTTP ${error.response?.statusCode ?? 'indisponível'}).',
    );
    debugPrintStack(stackTrace: stackTrace);
    return false;
  } on Object catch (error, stackTrace) {
    debugPrint('Worker de IA falhou (${error.runtimeType}): $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  } finally {
    container.dispose();
  }
}
