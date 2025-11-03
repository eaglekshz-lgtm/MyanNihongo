import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/enums/app_enums.dart';
import 'summary_row.dart';

class SummaryCard extends StatelessWidget {
  final CardStyle selectedCardStyle;
  final int totalWords;
  final String blocksCount;

  const SummaryCard({
    super.key,
    required this.selectedCardStyle,
    required this.totalWords,
    required this.blocksCount,
  });

  String _getCardStyleDisplayName(CardStyle style) {
    switch (style) {
      case CardStyle.recallMode:
        return 'Recall Mode';
      case CardStyle.absorbMode:
        return 'Absorb Mode';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summarize_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Learning Summary',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SummaryRow(
            icon: Icons.style_rounded,
            label: 'Card Style',
            value: _getCardStyleDisplayName(selectedCardStyle),
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.collections_bookmark_rounded,
            label: 'Total Words',
            value: totalWords > 0 ? '$totalWords words' : 'Loading...',
          ),
          const SizedBox(height: 12),
          const SummaryRow(
            icon: Icons.grid_view_rounded,
            label: 'Words Per Block',
            value: '20 words',
          ),
          const SizedBox(height: 12),
          SummaryRow(
            icon: Icons.apps_rounded,
            label: 'Total Blocks',
            value: blocksCount,
          ),
          const SizedBox(height: 12),
          const SummaryRow(
            icon: Icons.info_outline,
            label: 'Next Step',
            value: 'Choose blocks to study',
          ),
        ],
      ),
    );
  }
}