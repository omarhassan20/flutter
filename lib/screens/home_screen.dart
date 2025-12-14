import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/task_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('tasks', data);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('tasks');
    if (data != null) {
      setState(() {
        tasks = data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      });
    }
  }

  void addTask(String title) {
    setState(() {
      tasks.add({'title': title, 'done': false});
    });
    saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]['done'] = !tasks[index]['done'];
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void editTask(int index, String newTitle) {
    setState(() {
      tasks[index]['title'] = newTitle;
    });
    saveTasks();
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مهمة جديدة'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'اكتب المهمة هنا',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  addTask(controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, int index) {
    final TextEditingController controller =
        TextEditingController(text: tasks[index]['title']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل المهمة'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'عدّل المهمة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  editTask(index, controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          tasks.isEmpty
              ? const Center(child: Text('مفيش مهام'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskItemWidget(
                      title: tasks[index]['title'],
                      isDone: tasks[index]['done'],
                      onToggle: () => toggleTask(index),
                      onDelete: () => deleteTask(index),
                      onEdit: () => _showEditTaskDialog(context, index),
                    );
                  },
                ),

          // زرار الإضافة الأصفر في النص
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => _showAddTaskDialog(context),
              child: const Text(
                'إضافة مهمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
