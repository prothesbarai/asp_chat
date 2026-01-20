/*
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'alarm_service.dart';

class AlarmSetUi extends StatefulWidget {
  const AlarmSetUi({super.key});

  @override
  State<AlarmSetUi> createState() => _AlarmSetUiState();
}

class _AlarmSetUiState extends State<AlarmSetUi> {

  // >>> Alarm Function Here ===================================================
  Future<void> _testAlarm(BuildContext context) async {
    try {
      // >>>  Check and request notification permission ========================
      final notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        final requestedStatus = await Permission.notification.request();
        if (!requestedStatus.isGranted && !mounted) {return;}
      }
      // <<<  Check and request notification permission ========================


      // >>> Fire alarm immediately ============================================
      await AlarmService.instance.fireImmediateAlarm();
      // <<< Fire alarm immediately ============================================

    } catch (e) {
      debugPrint("Error $e");
    }
  }
  // <<< Alarm Function Here ===================================================

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
}*/
