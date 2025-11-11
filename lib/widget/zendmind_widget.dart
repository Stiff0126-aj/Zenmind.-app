import 'package:flutter/material.dart';
import 'home_widget_service.dart';

class ZenMindWidget extends StatelessWidget {
  final String message;
  const ZenMindWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ZenMind',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(message, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
