import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> inAppDialogue(NavigatorState navigatorState, RemoteMessage message, VoidCallback onTap,) async {
  final context = navigatorState.context;
  if (!context.mounted) return;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: Text(message.notification?.title ?? 'Notification', style: TextStyle(color: Theme.of(context).colorScheme.onSurface,),),
        content: Text(message.notification?.body ?? '', style: TextStyle(color: Theme.of(context).colorScheme.onSurface,),),
        actions: [ElevatedButton(onPressed: () {Navigator.pop(context);onTap();}, child: const Text('OK'),)],
      );
    },
  );
}


