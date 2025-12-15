import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  String dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  @override
  void initState() {
    super.initState();
    saveSelectedDay(selectedDay);
  }

  Future<void> saveSelectedDay(DateTime d) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_day', dayKey(d));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: TableCalendar(
        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2035),
        focusedDay: focusedDay,
        selectedDayPredicate: (d) => isSameDay(d, selectedDay),
        onDaySelected: (d, f) {
          setState(() {
            selectedDay = d;
            focusedDay = f;
          });
          saveSelectedDay(d);
        },
      ),
    );
  }
}
