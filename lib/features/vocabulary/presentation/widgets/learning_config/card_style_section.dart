import 'package:flutter/material.dart';
import 'package:myan_nihongo/core/enums/app_enums.dart';
import 'package:myan_nihongo/core/theme/app_theme.dart';
import 'config_section.dart';
import 'mode_card.dart';

/// Configuration class for card styles
/// Makes it easy to add new card styles in the future
/// Title comes from CardStyle.displayName
class CardStyleConfig {
  final CardStyle style;
  final String description;
  final IconData icon;

  const CardStyleConfig({
    required this.style,
    required this.description,
    required this.icon,
  });
}

class CardStyleSection extends StatelessWidget {
  final CardStyle selectedCardStyle;
  final void Function(CardStyle) onCardStyleChanged;

  const CardStyleSection({
    super.key,
    required this.selectedCardStyle,
    required this.onCardStyleChanged,
  });

  // Define card style configurations for easy expansion
  static const List<CardStyleConfig> _cardStyleConfigs = [
    CardStyleConfig(
      style: CardStyle.recallMode,
      description: 'Active recall\nTap to reveal',
      icon: Icons.psychology_rounded,
    ),
    CardStyleConfig(
      style: CardStyle.absorbMode,
      description: 'Absorb all content\nwith examples',
      icon: Icons.auto_stories_rounded,
    ),
    // Add more card styles here in the future
  ];

  @override
  Widget build(BuildContext context) {
    return ConfigSection(
      title: 'Card Style',
      icon: Icons.flip_rounded,
      child: Column(
        children: [
          Text(
            'Choose how you want to view vocabulary cards',
            style: AppTheme.bodySmall.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          // Dynamically build card style options
          Row(
            children: _cardStyleConfigs.map((config) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: config != _cardStyleConfigs.last ? 12 : 0,
                  ),
                  child: ModeCard(
                    title: config.style.displayName,
                    description: config.description,
                    icon: config.icon,
                    isSelected: selectedCardStyle == config.style,
                    onTap: () => onCardStyleChanged(config.style),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
