import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Aktif';
        break;
      case 'completed':
        color = Colors.blue;
        text = 'Tamamlandı';
        break;
      case 'postponed':
        color = Colors.orange;
        text = 'Ertelendi';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}
