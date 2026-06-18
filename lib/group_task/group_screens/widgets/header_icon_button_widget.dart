import 'package:flutter/material.dart';

import '../group_task_ui.dart';

// notifaction icon and setting icon
class HeaderIconButton extends StatelessWidget{
  final IconData icon;
  final VoidCallback onPressed;
  const HeaderIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(

      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}