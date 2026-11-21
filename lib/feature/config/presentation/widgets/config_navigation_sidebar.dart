import 'package:flutter/material.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/config_section_catalog.dart';
import 'package:noema/shared/widgets/app_card.dart';

class ConfigNavigationSidebar extends StatelessWidget {
  const ConfigNavigationSidebar({
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    final grouped = <ConfigCategory, List<ConfigSectionMetadata>>{};
    for (final item in sections) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return AppCard(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Seções',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.sm),
          for (final entry in grouped.entries) ...[
            Padding(
              padding: EdgeInsets.only(
                top: spacing.sm,
                bottom: spacing.xs,
                left: spacing.sm,
              ),
              child: Text(
                entry.key.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            for (final item in entry.value)
              _SidebarNavItem(
                metadata: item,
                isSelected: item.section == activeSection,
                onTap: () => onSelectSection(item.section),
              ),
          ],
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.metadata,
    required this.isSelected,
    required this.onTap,
  });

  final ConfigSectionMetadata metadata;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xs / 2),
      child: Material(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.65)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  metadata.icon,
                  size: 18,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    metadata.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
