import 'package:flutter/material.dart';

class AddTaskWidget extends StatelessWidget {
  final Function(String) onAdd;

  const AddTaskWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'اكتب المهمة',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAdd(controller.text);
                controller.clear();
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
