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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: done,
          onChanged: (_) => onToggle(),
          activeColor: Colors.blue,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.blueAccent : Colors.black,
            fontSize: 16,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Wrap(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
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
