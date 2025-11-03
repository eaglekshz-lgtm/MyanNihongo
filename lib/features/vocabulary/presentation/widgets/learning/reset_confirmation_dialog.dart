import 'package:flutter/material.dart';

class ResetConfirmationDialog extends StatelessWidget {
  final VoidCallback onReset;

  const ResetConfirmationDialog({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Progress'),
      content: const Text(
        'Are you sure you want to restart this block from the beginning? Your current progress will be reset.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onReset();
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}