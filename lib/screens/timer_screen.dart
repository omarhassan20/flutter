import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final List<String> tasks;

  const TimerScreen({super.key, required this.tasks});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String? selectedTask;

  int hours = 0;
  int minutes = 0;

  int remainingSeconds = 0;
  Timer? timer;
  bool isRunning = false;

  // ⏱ Start
  void startTimer() {
    if (remainingSeconds <= 0) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer?.cancel();
        setState(() => isRunning = false);
      }
    });

    setState(() => isRunning = true);
  }

  // ⏸ Pause
  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  // ⏹ Reset
  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = (hours * 3600) + (minutes * 60);
    });
  }

  String formatTime() {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;

    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Timer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 اختيار التاسك
            const Text('Select Task'),
            DropdownButtonFormField<String>(
              initialValue: selectedTask,
              items: widget.tasks
                  .map(
                    (task) => DropdownMenuItem<String>(
                      value: task,
                      child: Text(task),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedTask = v),
            ),

            const SizedBox(height: 20),

            // ⏱ اختيار الوقت
            const Text('Set Time'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hours'),
                    onChanged: (v) => hours = int.tryParse(v) ?? 0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minutes'),
                    onChanged: (v) => minutes = int.tryParse(v) ?? 0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ▶️ تجهيز الوقت
            ElevatedButton(
              onPressed: () {
                setState(() {
                  remainingSeconds = (hours * 3600) + (minutes * 60);
                });
              },
              child: const Text('Set Timer'),
            ),

            const SizedBox(height: 30),

            // ⏰ العرض
            Center(
              child: Text(
                formatTime(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ▶ ⏸ ⏹ أزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : null,
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
