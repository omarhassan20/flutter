import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  final String text;
  final bool done;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItemWidget({
    super.key,
    required this.text,
    required this.done,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(
              value: done,
              onChanged: (_) => onToggle(),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
