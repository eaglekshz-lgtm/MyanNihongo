import 'package:flutter/material.dart';
import '../../../../core/enums/app_enums.dart';

class LevelChipWidget extends StatelessWidget {
  const LevelChipWidget({
    required this.label,
    required this.level,
    required this.selectedLevel,
    required this.onSelected,
    super.key,
  });

  final String label;
  final JLPTLevel? level;
  final JLPTLevel? selectedLevel;
  final ValueChanged<JLPTLevel?> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedLevel == level;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onSelected(selected ? level : null);
      },
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      selectedColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class JLPTLevelSelector extends StatelessWidget {
  final JLPTLevel? selectedLevel;
  final ValueChanged<JLPTLevel?> onSelected;

  const JLPTLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        LevelChipWidget(
          label: 'All Levels',
          level: null,
          selectedLevel: selectedLevel,
          onSelected: onSelected,
        ),
        ...JLPTLevel.values.map(
          (level) => LevelChipWidget(
            key: ValueKey(level),
            label: level.code,
            level: level,
            selectedLevel: selectedLevel,
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}
