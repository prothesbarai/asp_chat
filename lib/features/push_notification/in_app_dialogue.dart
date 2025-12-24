import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> inAppDialogue(NavigatorState navigatorState, RemoteMessage message, VoidCallback onTap,) async {
  final context = navigatorState.context;
  if (!context.mounted) return;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // >>> Title
            Text(message.notification?.title ?? 'Notification', style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 15),
            Text(message.notification?.body ?? '', style: TextStyle(color: Theme.of(context).colorScheme.onSurface,fontSize: 16,),),
            // >>> Body
            const SizedBox(height: 25),
            // >>> Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // >>> Cancel Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                // >>>  View Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),), backgroundColor: Theme.of(context).colorScheme.primary,),
                  onPressed: () {Navigator.pop(context);onTap();},
                  child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}


