import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmSetUi extends StatefulWidget {
  const AlarmSetUi({super.key});

  @override
  State<AlarmSetUi> createState() => _AlarmSetUiState();
}

class _AlarmSetUiState extends State<AlarmSetUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm"),actions: [IconButton(onPressed: ()=>openAppSettings(), icon: Icon(Icons.settings))],),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            ElevatedButton(onPressed: (){}, child: Text("Set Alarm"))
            
          ],
        ),
      ),
    );
  }
}
