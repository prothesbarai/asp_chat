import 'package:flutter/material.dart';
class GlobalScreen extends StatelessWidget {
  const GlobalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Global Screen",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
