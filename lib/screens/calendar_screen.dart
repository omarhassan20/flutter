import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  Map<String, List<String>> tasksByDate = {};

  @override
  void initState() {
    super.initState();

    // ✅ دايمًا نبدأ بتاريخ النهارده
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    loadCalendarTasks();
    saveSelectedDay(_selectedDay);
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Future<void> saveSelectedDay(DateTime day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_day', _dateKey(day));
  }

  Future<void> loadCalendarTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('calendar_tasks');

    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      setState(() {
        tasksByDate = decoded.map(
          (key, value) => MapEntry(
            key,
            List<String>.from(value),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2015),
        lastDay: DateTime.utc(2035),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        onDaySelected: (selectedDay, focusedDay) async {
          // ✅ لما تختار يوم
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          // خزّن اليوم المختار
          await saveSelectedDay(selectedDay);

          // 🔥 رجّعك على الهوم فورًا
          Navigator.pop(context);
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
