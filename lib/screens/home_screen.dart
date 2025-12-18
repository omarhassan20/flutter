import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/task_item_widget.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];
  String selectedDayKey = '';

  bool isSearching = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadSelectedDay();
  }

  // ---------- DATE FORMAT ----------
  String formatDate(String key) {
    final parts = key.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return '${days[date.weekday - 1]}, '
        '${date.day}/${date.month}/${date.year}';
  }

  // ---------- LOAD ----------
  Future<void> loadSelectedDay() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('selected_day');

    setState(() {
      selectedDayKey = key ??
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    });

    loadTasksForDay();
  }

  Future<void> loadTasksForDay() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('calendar_tasks');

    if (data == null) {
      setState(() => tasks = []);
      return;
    }

    final decoded = jsonDecode(data) as Map<String, dynamic>;
    final list = decoded[selectedDayKey] ?? [];

    setState(() {
      tasks = List<Map<String, dynamic>>.from(
        list.map((e) => {
              'text': e['text'],
              'done': e['done'],
            }),
      );
    });
  }

  // ---------- SAVE ----------
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('calendar_tasks');

    Map<String, dynamic> decoded = data != null ? jsonDecode(data) : {};
    decoded[selectedDayKey] = tasks;

    await prefs.setString('calendar_tasks', jsonEncode(decoded));
  }

  // ---------- ACTIONS ----------
  void addTask(String text) {
    setState(() {
      tasks.add({'text': text, 'done': false});
    });
    saveTasks();
  }

  void toggleDone(int i) {
    setState(() {
      tasks[i]['done'] = !tasks[i]['done'];
    });
    saveTasks();
  }

  void deleteTask(int i) {
    setState(() {
      tasks.removeAt(i);
    });
    saveTasks();
  }

  void editTask(int i, String newText) {
    setState(() {
      tasks[i]['text'] = newText;
    });
    saveTasks();
  }

  // ---------- DIALOGS ----------
  void showAddDialog() {
    final c = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: 'Task text'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                addTask(c.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void showEditDialog(int i) {
    final c = TextEditingController(text: tasks[i]['text']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit'),
        content: TextField(controller: c),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                editTask(i, c.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ---------- FILTER ----------
  List<Map<String, dynamic>> get filteredTasks {
    if (searchText.isEmpty) return tasks;

    return tasks
        .where((task) => task['text']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              )
            : const Text('My Tasks'),
        centerTitle: true,
        actions: [
          // 🔍 أيقونة البحث
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchText = '';
              });
            },
          ),

          // ⚙️ أيقونة الإعدادات
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      // 📌 Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalendarScreen(),
                  ),
                ).then((_) => loadSelectedDay());
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ---------- BODY ----------
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 📅 التاريخ المختار
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            formatDate(selectedDayKey),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 📝 Tasks
        Expanded(
          child: tasks.isEmpty
              ? const Center(child: Text('No tasks for this day'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    return Dismissible(
                      key: ValueKey('${tasks[i]['text']}_$i'),

                      direction: DismissDirection.endToStart, // 👈 سحب شمال بس

                      onDismissed: (_) {
                        deleteTask(i);
                      },

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),

                      child: TaskItemWidget(
                        text: tasks[i]['text'],
                        done: tasks[i]['done'],
                        onToggle: () => toggleDone(i),
                        onEdit: () => showEditDialog(i),
                        onDelete: () {}, // ❌ مش مستخدم
                      ),
                    );
                  },
                ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
    return scaffold;
  }
}
