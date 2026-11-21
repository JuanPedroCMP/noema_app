import 'package:flutter/material.dart';
import 'package:noema/feature/config/data/enums.dart';

enum ConfigCategory {
  account('Conta'),
  appearance('Aparência'),
  ai('Inteligência Artificial'),
  data('Dados e Backup'),
  preferences('Preferências');

  const ConfigCategory(this.label);
  final String label;
}

class ConfigSectionMetadata {
  const ConfigSectionMetadata({
    required this.section,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.keywords,
  });

  final ConfigSections section;
  final ConfigCategory category;
  final String title;
  final String description;
  final IconData icon;
  final List<String> keywords;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return title.toLowerCase().contains(normalized) ||
        description.toLowerCase().contains(normalized) ||
        category.label.toLowerCase().contains(normalized) ||
        keywords.any((k) => k.toLowerCase().contains(normalized));
  }
}

const List<ConfigSectionMetadata> configSectionCatalog = [
  ConfigSectionMetadata(
    section: ConfigSections.profile,
    category: ConfigCategory.account,
    title: 'Perfil',
    description: 'Edite seu nome, e-mail e avatar.',
    icon: Icons.person_outline,
    keywords: ['perfil', 'usuário', 'conta', 'nome', 'email', 'avatar'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.colorTheme,
    category: ConfigCategory.appearance,
    title: 'Tema de cores',
    description: 'Escolha a paleta e o modo claro ou escuro deste dispositivo.',
    icon: Icons.palette_outlined,
    keywords: ['tema', 'cores', 'paleta', 'claro', 'escuro', 'dark', 'light'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.typographyTheme,
    category: ConfigCategory.appearance,
    title: 'Tipografia',
    description: 'Ajuste a fonte e o tamanho do texto.',
    icon: Icons.text_fields_outlined,
    keywords: ['fonte', 'tipografia', 'texto', 'tamanho', 'escala', 'leitura'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.aiConfiguration,
    category: ConfigCategory.ai,
    title: 'Provedores e agentes de IA',
    description: 'Conecte provedores, selecione modelos e configure agentes.',
    icon: Icons.smart_toy_outlined,
    keywords: ['ia', 'ai', 'provedor', 'modelo', 'agente', 'openai', 'ollama'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.apiKeys,
    category: ConfigCategory.ai,
    title: 'Chaves de API',
    description: 'Armazene as credenciais usadas pelos provedores de IA.',
    icon: Icons.key_outlined,
    keywords: ['api', 'chave', 'key', 'token', 'segredo', 'provedor'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.googleAccount,
    category: ConfigCategory.data,
    title: 'Conta Google',
    description: 'Sincronize, compare e restaure backups no seu Google Drive.',
    icon: Icons.cloud_sync_outlined,
    keywords: ['google', 'drive', 'nuvem', 'sincronização', 'backup'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.manualBackup,
    category: ConfigCategory.data,
    title: 'Backup manual',
    description: 'Exporte ou importe seus dados em arquivo compactado.',
    icon: Icons.archive_outlined,
    keywords: ['backup', 'exportar', 'importar', 'arquivo', 'criptografia'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.preferences,
    category: ConfigCategory.preferences,
    title: 'Preferências',
    description: 'Defina idioma, sincronização e comportamento do aplicativo.',
    icon: Icons.tune_outlined,
    keywords: ['preferências', 'sincronizar', 'dispositivo', 'idioma', 'local'],
  ),
];
