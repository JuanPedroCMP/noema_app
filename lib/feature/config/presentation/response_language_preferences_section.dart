import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/presentation/preference_device_scope_control.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';

class ResponseLanguagePreferencesSection extends ConsumerStatefulWidget {
  const ResponseLanguagePreferencesSection({super.key});

  @override
  ConsumerState<ResponseLanguagePreferencesSection> createState() =>
      _ResponseLanguagePreferencesSectionState();
}

class _ResponseLanguagePreferencesSectionState
    extends ConsumerState<ResponseLanguagePreferencesSection> {
  List<LanguageOut> _languages = [];
  List<LanguageOut> _selected = [];
  bool _deviceOnly = false;
  bool _loading = true;
  bool _saving = false;
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
      final api = ref.read(apiClientProvider);
      final languagesResponse = await api
          .getLanguageApi()
          .listLanguagesApiV1UserConfigLanguageListGet();
      final languages = languagesResponse.data?.toList() ?? <LanguageOut>[];
      final config = await ConfigDao(
        ref.read(appDatabaseProvider),
      ).getConfigByUser(userId: user.id);
      final deviceOnly = await ref
          .read(preferenceStorageServiceProvider)
          .isDeviceOnly('responseLanguagePreferenceOrder');
      final localOrder = config == null
          ? null
          : readConfigPreference(
              config.preferences,
              'responseLanguagePreferenceOrder',
            );
      final selectedIds = deviceOnly && localOrder is List
          ? localOrder.whereType<String>().toList(growable: false)
          : await _loadAccountOrder(
              user.remoteId,
              api.getResponseResponseLanguagePreferenceOrderApi(),
              api.getUserGlobalConfigApi(),
              languages,
            );
      final languagesById = {for (final item in languages) item.id: item};
      if (!mounted) return;
      setState(() {
        _deviceOnly = deviceOnly;
        _languages = languages;
        _selected = selectedIds
            .map((id) => languagesById[id])
            .whereType<LanguageOut>()
            .toList();
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<List<String>> _loadAccountOrder(
    String remoteUserId,
    ResponseResponseLanguagePreferenceOrderApi orderApi,
    UserGlobalConfigApi globalConfigApi,
    List<LanguageOut> languages,
  ) async {
    final response = await orderApi
        .listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet();
    final userRows =
        response.data?.where((item) => item.idUser == remoteUserId).toList() ??
        <ResponseLanguagePreferenceOrderOut>[];
    userRows.sort((a, b) => a.preferenceOrder.compareTo(b.preferenceOrder));
    if (userRows.isNotEmpty) {
      return userRows.map((item) => item.idLanguage).toList();
    }

    final global = await globalConfigApi
        .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
          identificator: remoteUserId,
        );
    final legacyOrder =
        global.data?.preferences['responseLanguagePreferenceOrder']?.value;
    if (legacyOrder is! List) return const [];
    final validIds = legacyOrder
        .whereType<String>()
        .where((id) => languages.any((language) => language.id == id))
        .toList(growable: false);
    for (var index = 0; index < validIds.length; index++) {
      await orderApi
          .createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost(
            responseLanguagePreferenceOrderCreate:
                ResponseLanguagePreferenceOrderCreate((b) {
                  b
                    ..preferenceOrder = index + 1
                    ..idUser = remoteUserId
                    ..idLanguage = validIds[index];
                }),
          );
    }
    return validIds;
  }

  Future<void> _saveOrder(List<LanguageOut> next) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final ids = next.map((language) => language.id).toList();
      if (_deviceOnly) {
        await ref
            .read(preferenceStorageServiceProvider)
            .save(key: 'responseLanguagePreferenceOrder', value: ids);
      } else {
        await _saveAccountOrder(ids);
      }
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

  Future<void> _saveAccountOrder(List<String> ids) async {
    final user = await ref.read(userProvider.future);
    final api = ref
        .read(apiClientProvider)
        .getResponseResponseLanguagePreferenceOrderApi();
    final response = await api
        .listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet();
    final existing =
        response.data?.where((item) => item.idUser == user.remoteId).toList() ??
        <ResponseLanguagePreferenceOrderOut>[];
    final existingByLanguage = {
      for (final item in existing) item.idLanguage: item,
    };

    for (final item in existing) {
      if (!ids.contains(item.idLanguage)) {
        await api
            .updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete(
              identificator: item.id,
            );
      }
    }
    for (var index = 0; index < ids.length; index++) {
      final existingItem = existingByLanguage[ids[index]];
      if (existingItem == null) {
        await api
            .createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost(
              responseLanguagePreferenceOrderCreate:
                  ResponseLanguagePreferenceOrderCreate((b) {
                    b
                      ..preferenceOrder = index + 1
                      ..idUser = user.remoteId
                      ..idLanguage = ids[index];
                  }),
            );
      } else {
        await api
            .updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut(
              identificator: existingItem.id,
              responseLanguagePreferenceOrderUpdate:
                  ResponseLanguagePreferenceOrderUpdate((b) {
                    b.preferenceOrder = index + 1;
                  }),
            );
      }
    }
  }

  Future<void> _addLanguage(String? id) async {
    if (id == null || _selected.any((language) => language.id == id)) return;
    final language = _languages.where((item) => item.id == id).firstOrNull;
    if (language == null) return;
    await _saveOrder([..._selected, language]);
  }

  Future<void> _removeLanguage(LanguageOut language) async {
    await _saveOrder(
      _selected.where((item) => item.id != language.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.translate),
        title: Text('Idiomas de resposta'),
        subtitle: Text('Carregando idiomas disponíveis…'),
      );
    }
    if (_error != null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const Text('Não foi possível carregar os idiomas'),
        subtitle: Text('$_error'),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: _load,
          icon: const Icon(Icons.refresh),
        ),
      );
    }

    final available = _languages
        .where((language) => !_selected.any((item) => item.id == language.id))
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
                  Text(
                    'Idiomas preferidos para respostas',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    _deviceOnly
                        ? 'Somente neste dispositivo. O primeiro idioma tem prioridade.'
                        : 'Sincronizado com sua conta. O primeiro idioma tem prioridade.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PreferenceDeviceScopeControl(
              preferenceKey: 'responseLanguagePreferenceOrder',
              effectiveValue: selectedIds,
              onScopeChanged: _load,
            ),
          ],
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
                leading: CircleAvatar(radius: 14, child: Text('${index + 1}')),
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
          const Text('Nenhum idioma está disponível no servidor.')
        else
          DropdownButtonFormField<String>(
            key: ValueKey(available.map((item) => item.id).join(',')),
            initialValue: null,
            decoration: const InputDecoration(
              labelText: 'Adicionar idioma',
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
