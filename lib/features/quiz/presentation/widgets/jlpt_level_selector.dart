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
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
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
        ...JLPTLevel.values.map((level) => LevelChipWidget(
          key: ValueKey(level),
          label: level.code,
          level: level,
          selectedLevel: selectedLevel,
          onSelected: onSelected,
        )),
      ],
    );
  }
}