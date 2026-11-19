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
    description: 'Gerencie seus dados e preferências de conta.',
    icon: Icons.person_outline,
    keywords: ['perfil', 'usuário', 'conta', 'nome', 'email', 'avatar'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.colorTheme,
    category: ConfigCategory.appearance,
    title: 'Tema de cores',
    description:
        'Personalização local deste dispositivo: escolha paleta e modo claro ou escuro.',
    icon: Icons.palette_outlined,
    keywords: ['tema', 'cores', 'paleta', 'claro', 'escuro', 'dark', 'light'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.typographyTheme,
    category: ConfigCategory.appearance,
    title: 'Tipografia',
    description:
        'Personalização local deste dispositivo: escolha fontes e escala de leitura.',
    icon: Icons.text_fields_outlined,
    keywords: ['fonte', 'tipografia', 'texto', 'tamanho', 'escala', 'leitura'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.aiConfiguration,
    category: ConfigCategory.ai,
    title: 'Provedores e agentes de IA',
    description: 'Configure seus provedores, modelos e agentes pessoais.',
    icon: Icons.smart_toy_outlined,
    keywords: ['ia', 'ai', 'provedor', 'modelo', 'agente', 'openai', 'ollama'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.apiKeys,
    category: ConfigCategory.ai,
    title: 'Chaves de API',
    description:
        'Gerencie chaves dos provedores de inteligência artificial.',
    icon: Icons.key_outlined,
    keywords: ['api', 'chave', 'key', 'token', 'segredo', 'provedor'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.googleAccount,
    category: ConfigCategory.data,
    title: 'Conta Google',
    description:
        'Crie, compare, restaure e mescle backups locais na área privada do Google Drive.',
    icon: Icons.cloud_sync_outlined,
    keywords: ['google', 'drive', 'nuvem', 'sincronização', 'backup'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.manualBackup,
    category: ConfigCategory.data,
    title: 'Backup manual',
    description:
        'Exporte e importe um arquivo compactado, com criptografia opcional.',
    icon: Icons.archive_outlined,
    keywords: ['backup', 'exportar', 'importar', 'arquivo', 'criptografia'],
  ),
  ConfigSectionMetadata(
    section: ConfigSections.preferences,
    category: ConfigCategory.preferences,
    title: 'Preferências',
    description:
        'Escolha o que sincronizar com sua conta e o que manter apenas neste dispositivo.',
    icon: Icons.tune_outlined,
    keywords: ['preferências', 'sincronizar', 'dispositivo', 'idioma', 'local'],
  ),
];
