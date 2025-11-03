import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QuestionCountSelector extends StatefulWidget {
  const QuestionCountSelector({
    super.key,
    required this.initialValue,
    required this.maxQuestions,
    required this.onValueChanged,
  });

  final int initialValue;
  final int maxQuestions;
  final ValueChanged<int> onValueChanged;

  @override
  State<QuestionCountSelector> createState() => _QuestionCountSelectorState();
}

class _QuestionCountSelectorState extends State<QuestionCountSelector> {
  late double _currentValue;
  late int _displayValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.toDouble();
    _displayValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(QuestionCountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.maxQuestions != oldWidget.maxQuestions) {
      if (_currentValue > widget.maxQuestions) {
        setState(() {
          _currentValue = widget.maxQuestions.toDouble();
          _displayValue = widget.maxQuestions;
        });
        widget.onValueChanged(_displayValue);
      }
    }
  }

  int _calculateDisplayValue(double value) {
    if (value >= widget.maxQuestions - 5) {
      return widget.maxQuestions;
    } else {
      final rounded = (value / 10).round() * 10;
      return rounded < 10 ? 10 : rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Questions',
          style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Available: ${widget.maxQuestions} words',
          style: AppTheme.bodySmall.copyWith(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _currentValue.clamp(
                  10.0,
                  widget.maxQuestions.toDouble().clamp(10.0, double.infinity),
                ),
                min: 10.0,
                max: widget.maxQuestions.toDouble().clamp(
                  10.0,
                  double.infinity,
                ),
                divisions: widget.maxQuestions > 10
                    ? ((widget.maxQuestions - 10) / 10).ceil().clamp(1, 100)
                    : 1,
                label: _displayValue.toString(),
                onChanged: widget.maxQuestions >= 10
                    ? (value) {
                        setState(() {
                          _currentValue = value;
                          _displayValue = _calculateDisplayValue(value);
                        });
                      }
                    : null,
                onChangeEnd: (value) {
                  final finalValue = _calculateDisplayValue(value);
                  widget.onValueChanged(finalValue);
                },
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _displayValue.toString(),
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
