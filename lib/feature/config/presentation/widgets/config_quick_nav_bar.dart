import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/config_section_catalog.dart';

class ConfigQuickNavBar extends StatelessWidget {
  const ConfigQuickNavBar({
    super.key,
    required this.sections,
    required this.activeSection,
    required this.onSelectSection,
  });

  final List<ConfigSectionMetadata> sections;
  final ConfigSections activeSection;
  final ValueChanged<ConfigSections> onSelectSection;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) SizedBox(width: spacing.xs),
            ChoiceChip(
              avatar: Icon(sections[i].icon, size: 16),
              label: Text(sections[i].title),
              selected: sections[i].section == activeSection,
              onSelected: (_) => onSelectSection(sections[i].section),
            ),
          ],
        ],
      ),
    );
  }
}
