import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleAccountSection extends ConsumerStatefulWidget {
  const GoogleAccountSection({super.key});

  @override
  ConsumerState<GoogleAccountSection> createState() =>
      _GoogleAccountSectionState();
}

class _GoogleAccountSectionState extends ConsumerState<GoogleAccountSection> {
  GoogleAccountOut? _account;
  bool _loading = true;
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await ref.read(userProvider.future);
      final account = await ref
          .read(apiClientProvider)
          .getAuthenticationApi()
          .getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(
            identificator: user.remoteId,
          );
      final data = account.data;
      if (data != null && data.idUser != user.remoteId) {
        throw StateError('A conta Google retornada não pertence ao usuário.');
      }
      if (!mounted) return;
      setState(() {
        _account = data;
        _loading = false;
      });
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        if (!mounted) return;
        setState(() {
          _account = null;
          _loading = false;
        });
        return;
      }
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível consultar a conta Google. Tente novamente.';
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível consultar a conta Google. Tente novamente.';
        _loading = false;
      });
    }
  }

  Future<void> _link() async {
    setState(() => _working = true);
    try {
      final client = ref.read(apiClientProvider);
      final response = await client.dio.request<Object>(
        '/api/v1/auth/google/link',
        options: Options(
          method: 'GET',
          followRedirects: false,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final location = response.headers.value('location');
      final body = response.data;
      final bodyUrl = body is Map
          ? body['authorization_url'] ?? body['url'] ?? body['redirect_url']
          : null;
      final value = location ?? (bodyUrl is String ? bodyUrl : null);
      if (value == null || value.trim().isEmpty) {
        throw StateError(
          'O serviço não forneceu o endereço para iniciar o vínculo.',
        );
      }

      final baseUri = Uri.parse(client.dio.options.baseUrl);
      final oauthUri = baseUri.resolve(value);
      if (oauthUri.scheme != 'https') {
        throw StateError('O endereço de autorização retornado é inválido.');
      }
      final launched = await launchUrl(
        oauthUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw StateError('Não foi possível abrir o navegador do sistema.');
      }
      _message(
        'Conclua a autorização no navegador. Depois, toque em “Atualizar status”.',
      );
    } catch (error) {
      _message('Não foi possível iniciar o vínculo com Google. Tente novamente.');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _unlink() async {
    final account = _account;
    if (account == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular Google?'),
        content: Text(
          'A conta ${account.emailGoogle} deixará de estar conectada ao Noema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _working = true);
    try {
      await ref
          .read(apiClientProvider)
          .getAuthenticationApi()
          .deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete(
            identificator: account.id,
          );
      await _refresh();
      _message('Conta Google desvinculada.');
    } catch (error) {
      _message('Não foi possível desvincular a conta Google. Tente novamente.');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_error!),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    final account = _account;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Conecte sua conta para permitir os recursos que usam integração '
          'com o Google. As credenciais de OAuth são gerenciadas pela API.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (_working) const Padding(
          padding: EdgeInsets.only(top: 12),
          child: LinearProgressIndicator(),
        ),
        const SizedBox(height: 12),
        if (account == null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_off_outlined),
              title: const Text('Nenhuma conta Google vinculada'),
              subtitle: const Text('O vínculo será concluído no navegador.'),
              trailing: FilledButton(
                onPressed: _working ? null : _link,
                child: const Text('Vincular'),
              ),
            ),
          )
        else
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  account.isActive
                      ? Icons.account_circle_outlined
                      : Icons.cloud_off_outlined,
                ),
              ),
              title: Text(account.emailGoogle),
              subtitle: Text(
                account.isActive
                    ? 'Vinculada${account.lastRefreshAt == null ? '' : ' · Atualizada ${MaterialLocalizations.of(context).formatShortDate(account.lastRefreshAt!.toLocal())}'}'
                    : 'Vinculada, mas inativa',
              ),
              trailing: PopupMenuButton<String>(
                enabled: !_working,
                onSelected: (action) {
                  if (action == 'refresh') _refresh();
                  if (action == 'unlink') _unlink();
                  if (action == 'toggle') {
                    _setActive(account, !account.isActive);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(
                      account.isActive ? 'Desativar integração' : 'Ativar integração',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Text('Atualizar status'),
                  ),
                  const PopupMenuItem(
                    value: 'unlink',
                    child: Text('Desvincular'),
                  ),
                ],
              ),
            ),
          ),
        if (account != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _working ? null : _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar status'),
            ),
          ),
      ],
    );
  }

  Future<void> _setActive(GoogleAccountOut account, bool isActive) async {
    setState(() => _working = true);
    try {
      final response = await ref
          .read(apiClientProvider)
          .getAuthenticationApi()
          .updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut(
            identificator: account.id,
            googleAccountUpdate: GoogleAccountUpdate(
              (builder) => builder.isActive = isActive,
            ),
          );
      if (response.data == null || response.data!.idUser != account.idUser) {
        throw StateError('A API não confirmou a alteração da integração.');
      }
      await _refresh();
      _message(
        isActive ? 'Integração Google ativada.' : 'Integração Google desativada.',
      );
    } catch (error) {
      _message('Não foi possível alterar a integração Google. Tente novamente.');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }
}
