import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  const CustomAppbar({super.key,required this.title});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(widget.title, style: TextStyle(color: Colors.black45, fontSize: 26, fontWeight: FontWeight.bold,),),
      actions: [
        Icon(Icons.edit, color: Colors.black45),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.grey.shade700,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 14),
      ],
    );
  }
}
