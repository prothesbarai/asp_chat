import 'package:flutter/material.dart';

import 'alarm_service.dart';

class AlarmSetUi extends StatefulWidget {
  const AlarmSetUi({super.key});

  @override
  State<AlarmSetUi> createState() => _AlarmSetUiState();
}

class _AlarmSetUiState extends State<AlarmSetUi> {


  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:Column(
          children: [

            ElevatedButton(
              onPressed: () async {

                final allowed =
                await AlarmService.instance.canScheduleExactAlarms();

                if (!allowed) {
                  await AlarmService.instance.requestExactAlarmPermission();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please allow Exact Alarm permission, then press again'),
                    ),
                  );
                  return; // ⛔ STOP HERE
                }

                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime == null) return;

                final now = DateTime.now();
                final alarmTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                await AlarmService.instance.setAlarm(
                  id: 101,
                  title: 'Pill Reminder 💊',
                  body: 'Medicine নেওয়ার সময় হয়েছে',
                  dateTime: alarmTime,
                );
              },
              child: const Text('Pick Time & Set Alarm'),
            )



          ],
        ),
      ),
    );
  }
}
