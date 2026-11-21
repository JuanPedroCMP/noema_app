import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/data/google_drive/automatic_backup_scheduler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_linux/workmanager_linux.dart';
import 'app.dart' show App;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux &&
      await WorkmanagerLinux.maybeRunBackgroundTask(
        args,
        automaticBackupLinuxTaskDispatcher,
      )) {
    return;
  }
  if (Platform.isAndroid) {
    await Workmanager().initialize(automaticBackupTaskDispatcher);
  } else if (Platform.isLinux) {
    await Workmanager().initialize(automaticBackupLinuxTaskDispatcher);
  }

  runApp(const ProviderScope(child: App()));
}
