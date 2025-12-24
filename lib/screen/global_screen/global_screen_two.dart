import 'package:flutter/material.dart';
class GlobalScreenTwo extends StatelessWidget {
  const GlobalScreenTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Global Screen Two",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
