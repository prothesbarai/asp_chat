import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'alarm_service.dart';

class AlarmSetUi extends StatefulWidget {
  const AlarmSetUi({super.key});

  @override
  State<AlarmSetUi> createState() => _AlarmSetUiState();
}

class _AlarmSetUiState extends State<AlarmSetUi> {
  Future<void> _testAlarm(BuildContext context) async {
    try {
      // 1. Check and request notification permission
      final notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        final requestedStatus = await Permission.notification.request();
        if (!requestedStatus.isGranted && !mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enable notification permission'), duration: Duration(seconds: 3),),);
          return;
        }
      }
      // 2. Fire alarm immediately
      await AlarmService.instance.fireImmediateAlarm();

      // 3. Show success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alarm fired! Check your notification 🔔'), duration: Duration(seconds: 2), backgroundColor: Colors.green,),);

    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Immediate Alarm Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => openAppSettings(),
            tooltip: 'Open App Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _testAlarm(context),
              icon: const Icon(Icons.alarm),
              label: const Text('Fire Alarm Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}