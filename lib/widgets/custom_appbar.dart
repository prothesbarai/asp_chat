import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppbar({super.key, required this.title, this.actions,});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title, style: TextStyle(color: Colors.black45, fontSize: 26, fontWeight: FontWeight.bold,),),
      actions: actions,
    );
  }
}
