import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../arguments/category_selection_args.dart';
import '../../../../arguments/learning_mode_config_args.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/page_header_widget.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  /// Get available categories based on level
  /// N5: All categories including numbers, days, counters
  /// N4-N1: Only all, verb, adjective, noun
  List<CategoryItem> _getAvailableCategories(String level) {
    final isN5 = level.toUpperCase() == 'N5';
    
    final baseCategories = [
      CategoryItem(
        type: 'all',
        icon: Icons.library_books,
        color: AppTheme.primaryColor,
      ),
      CategoryItem(
        type: 'verb',
        icon: Icons.flash_on,
        color: AppTheme.successColor,
      ),
      CategoryItem(
        type: 'adjective',
        icon: Icons.palette,
        color: AppTheme.warningColor,
      ),
      CategoryItem(
        type: 'noun',
        icon: Icons.inventory_2,
        color: AppTheme.infoColor,
      ),
    ];

    // Add extra categories only for N5
    if (isN5) {
      baseCategories.addAll([
        CategoryItem(
          type: 'number',
          icon: Icons.calculate,
          color: Colors.purple,
        ),
        CategoryItem(
          type: 'day',
          icon: Icons.calendar_today,
          color: Colors.teal,
        ),
        CategoryItem(
          type: 'counter',
          icon: Icons.format_list_numbered,
          color: Colors.deepPurple,
        ),
      ]);
    }

    return baseCategories;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategorySelectionArgs?;
    final level = args?.level ?? 'N5';
    
    final categories = _getAvailableCategories(level);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category - $level'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeaderWidget(
                icon: Icons.category,
                title: 'What would you like to learn?',
                subtitle: 'Choose the type of words to practice',
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCardWidget(
                      type: category.type,
                      icon: category.icon,
                      color: category.color,
                      onTap: () => _navigateToLearningMode(context, level, category.type),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLearningMode(BuildContext context, String level, String type) {
    Navigator.pushNamed(
      context,
      RouteNames.learningModeConfig,
      arguments: LearningModeConfigArgs(
        level: level,
        wordType: type == 'all' ? null : type,
      ),
    );
  }
}

/// Data class for category items
class CategoryItem {
  final String type;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.type,
    required this.icon,
    required this.color,
  });
}
