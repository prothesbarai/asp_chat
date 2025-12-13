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
      title: Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),),
      actions: actions,
    );
  }
}
