import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/presentation/preference_device_scope_control.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:openapi/openapi.dart';

const _cachedRemoteResponseLanguageOrderKey =
    '__cachedRemoteResponseLanguageOrder';

class _ResponseLanguageOption {
  const _ResponseLanguageOption({required this.id, required this.name});

  final String id;
  final String name;
}

class ResponseLanguagePreferencesSection extends ConsumerStatefulWidget {
  const ResponseLanguagePreferencesSection({super.key});

  @override
  ConsumerState<ResponseLanguagePreferencesSection> createState() =>
      _ResponseLanguagePreferencesSectionState();
}

class _ResponseLanguagePreferencesSectionState
    extends ConsumerState<ResponseLanguagePreferencesSection> {
  List<_ResponseLanguageOption> _languages = [];
  List<_ResponseLanguageOption> _selected = [];
  bool _deviceOnly = false;
  bool _loading = true;
  bool _saving = false;
  bool _usingCachedLanguages = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await ref.read(userProvider.future);
      final dao = ConfigDao(ref.read(appDatabaseProvider));
      final config = await dao.getConfigByUser(userId: user.id);
      final deviceOnly = await ref
          .read(preferenceStorageServiceProvider)
          .isDeviceOnly(responseLanguagePreferenceOrderKey);
      final localOrder = config == null
          ? null
          : readConfigPreference(
              config.preferences,
              responseLanguagePreferenceOrderKey,
            );
      final cachedRemoteOrder = config == null
          ? null
          : readConfigPreference(
              config.preferences,
              _cachedRemoteResponseLanguageOrderKey,
            );
      final cachedLanguages = _decodeCachedLanguages(
        config == null
            ? null
            : readConfigPreference(
                config.preferences,
                cachedResponseLanguagesKey,
              ),
      );

      var languages = cachedLanguages.isNotEmpty
          ? cachedLanguages
          : const [
              _ResponseLanguageOption(
                id: fallbackPortugueseLanguageId,
                name: 'Português',
              ),
              _ResponseLanguageOption(
                id: fallbackEnglishLanguageId,
                name: 'English',
              ),
            ];
      final selectedIds = localOrder is List
          ? localOrder.whereType<String>().toList(growable: false)
          : cachedRemoteOrder is List
          ? cachedRemoteOrder.whereType<String>().toList(growable: false)
          : const <String>[];

      final languagesById = {for (final item in languages) item.id: item};
      if (!mounted) return;
      setState(() {
        _deviceOnly = deviceOnly;
        _languages = languages;
        _selected = [
          for (final id in selectedIds)
            _selectedLanguage(id, languagesById[id]),
        ];
        _usingCachedLanguages = true;
        _loading = false;
      });
      unawaited(
        _refreshRemoteLanguageData(
          user.remoteId,
          hasLocalOrder: localOrder is List || cachedRemoteOrder is List,
          deviceOnly: deviceOnly,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _refreshRemoteLanguageData(
    String remoteUserId, {
    required bool hasLocalOrder,
    required bool deviceOnly,
  }) async {
    final connection = ref.read(serverConnectionChecker);
    final isConnected =
        connection.value == true ||
        (connection.value == null &&
            (await ref.read(serverConnectionChecker.future)) == true);
    if (!isConnected) return;
    final api = ref.read(apiClientProvider);
    final storage = ref.read(preferenceStorageServiceProvider);
    try {
      final response = await api
          .getLanguageApi()
          .listLanguagesApiV1UserConfigLanguageListGet();
      final available =
          response.data
              ?.map(
                (language) => _ResponseLanguageOption(
                  id: language.id,
                  name: language.name,
                ),
              )
              .toList(growable: false) ??
          const <_ResponseLanguageOption>[];
      if (available.isNotEmpty) {
        await storage.saveLocally(
          key: cachedResponseLanguagesKey,
          value: [
            for (final language in available)
              {'id': language.id, 'name': language.name},
          ],
        );
        if (mounted) {
          final selectedIds = _selected.map((item) => item.id).toList();
          final languagesById = {
            for (final language in available) language.id: language,
          };
          setState(() {
            _languages = available;
            _selected = [
              for (final id in selectedIds)
                _selectedLanguage(id, languagesById[id]),
            ];
            _usingCachedLanguages = false;
          });
        }
      }
    } catch (error) {
      debugPrint('Não foi possível atualizar a lista de idiomas: $error');
      return;
    }

    if (hasLocalOrder || deviceOnly) return;
    try {
      final ids = await _loadAccountOrder(
        remoteUserId,
        api.getResponseResponseLanguagePreferenceOrderApi(),
      );
      if (ids.isEmpty) return;
      await storage.saveLocally(
        key: _cachedRemoteResponseLanguageOrderKey,
        value: ids,
      );
      if (!mounted) return;
      final languagesById = {for (final item in _languages) item.id: item};
      setState(() {
        _selected = [
          for (final id in ids) _selectedLanguage(id, languagesById[id]),
        ];
      });
    } catch (error) {
      debugPrint('Não foi possível carregar a ordem dos idiomas: $error');
    }
  }

  List<_ResponseLanguageOption> _decodeCachedLanguages(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is Map && item['id'] is String && item['name'] is String)
          _ResponseLanguageOption(
            id: item['id'] as String,
            name: item['name'] as String,
          ),
    ];
  }

  _ResponseLanguageOption _selectedLanguage(
    String id,
    _ResponseLanguageOption? knownLanguage,
  ) {
    if (knownLanguage != null) return knownLanguage;
    if (id == fallbackPortugueseLanguageId) {
      return const _ResponseLanguageOption(
        id: fallbackPortugueseLanguageId,
        name: 'Português',
      );
    }
    if (id == fallbackEnglishLanguageId) {
      return const _ResponseLanguageOption(
        id: fallbackEnglishLanguageId,
        name: 'English',
      );
    }
    final visibleId = id.substring(0, id.length < 8 ? id.length : 8);
    return _ResponseLanguageOption(id: id, name: 'Idioma salvo ($visibleId)');
  }

  Future<List<String>> _loadAccountOrder(
    String remoteUserId,
    ResponseResponseLanguagePreferenceOrderApi api,
  ) async {
    final response = await api
        .listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet();
    final userRows =
        response.data?.where((item) => item.idUser == remoteUserId).toList() ??
        <ResponseLanguagePreferenceOrderOut>[];
    userRows.sort((a, b) => a.preferenceOrder.compareTo(b.preferenceOrder));
    return userRows.map((item) => item.idLanguage).toList(growable: false);
  }

  Future<void> _saveOrder(List<_ResponseLanguageOption> next) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ids = next.map((language) => language.id).toList();
      await ref
          .read(preferenceStorageServiceProvider)
          .save(key: responseLanguagePreferenceOrderKey, value: ids);
      if (!mounted) return;
      setState(() {
        _selected = next;
        _saving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _saving = false;
      });
    }
  }

  Future<void> _addLanguage(String? id) async {
    if (id == null || _selected.any((language) => language.id == id)) return;
    final language = _languages.where((item) => item.id == id).firstOrNull;
    if (language == null) return;
    await _saveOrder([..._selected, language]);
  }

  Future<void> _removeLanguage(_ResponseLanguageOption language) async {
    await _saveOrder(
      _selected.where((item) => item.id != language.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.translate),
        title: RuntimeLocalizedText('Idiomas de resposta'),
        subtitle: RuntimeLocalizedText('Carregando preferências locais…'),
      );
    }
    if (_error != null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: RuntimeLocalizedText(
          'Não foi possível carregar as preferências',
        ),
        subtitle: RuntimeLocalizedText('$_error'),
        trailing: IconButton(
          tooltip: AppLocalizations.of(context)!.tryAgain,
          onPressed: _load,
          icon: const Icon(Icons.refresh),
        ),
      );
    }

    final available = _languages
        .where(
          (language) => !_selected.any(
            (item) =>
                item.id == language.id ||
                (item.id == fallbackPortugueseLanguageId &&
                    _matchesLanguageName(language.name, 'pt')) ||
                (item.id == fallbackEnglishLanguageId &&
                    _matchesLanguageName(language.name, 'en')),
          ),
        )
        .toList();
    final selectedIds = _selected.map((item) => item.id).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RuntimeLocalizedText(
                    l10n.preferredResponseLanguages,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  RuntimeLocalizedText(
                    _deviceOnly
                        ? 'Salvo somente neste dispositivo. O primeiro idioma tem prioridade.'
                        : 'Salvo localmente primeiro; será sincronizado com a conta. O primeiro idioma tem prioridade.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PreferenceDeviceScopeControl(
              preferenceKey: responseLanguagePreferenceOrderKey,
              effectiveValue: selectedIds,
              onScopeChanged: _load,
            ),
          ],
        ),
        if (_usingCachedLanguages)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: RuntimeLocalizedText(
              'Usando a lista local. Alterações serão sincronizadas quando a conexão voltar.',
            ),
          ),
        if (_selected.isNotEmpty)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: _selected.length,
            onReorderItem: (oldIndex, newIndex) {
              final next = [..._selected];
              final item = next.removeAt(oldIndex);
              next.insert(newIndex, item);
              _saveOrder(next);
            },
            itemBuilder: (context, index) {
              final language = _selected[index];
              return ListTile(
                key: ValueKey(language.id),
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  child: RuntimeLocalizedText('${index + 1}'),
                ),
                title: Text(language.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    IconButton(
                      tooltip: 'Remover ${language.name}',
                      onPressed: _saving
                          ? null
                          : () => _removeLanguage(language),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              );
            },
          ),
        if (_languages.isEmpty)
          RuntimeLocalizedText(
            'Conecte-se uma vez para carregar idiomas; as preferências salvas continuam disponíveis offline.',
          )
        else
          DropdownButtonFormField<String>(
            key: ValueKey(available.map((item) => item.id).join(',')),
            initialValue: null,
            decoration: InputDecoration(
              labelText: l10n.addLanguage,
              prefixIcon: Icon(Icons.add),
            ),
            items: available
                .map(
                  (language) => DropdownMenuItem(
                    value: language.id,
                    child: Text(language.name),
                  ),
                )
                .toList(),
            onChanged: _saving ? null : _addLanguage,
          ),
        if (_saving) const LinearProgressIndicator(),
      ],
    );
  }
}

bool _matchesLanguageName(String name, String code) {
  final normalized = name.toLowerCase();
  return code == 'pt'
      ? normalized.contains('portugu') || normalized.startsWith('pt')
      : normalized.contains('english') ||
            normalized.contains('inglês') ||
            normalized.startsWith('en');
}
