import 'package:flutter/material.dart';
class GlobalScreenThree extends StatelessWidget {
  const GlobalScreenThree({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Global Screen Three",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
