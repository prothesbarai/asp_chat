import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  final String title;
  const Demo({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title,style: TextStyle(color: Theme.of(context).colorScheme.onSurface,),),
      ),
    );
  }
}
