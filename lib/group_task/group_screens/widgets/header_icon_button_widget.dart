import 'package:flutter/material.dart';

import '../group_task_ui.dart';


class HeaderIconButton extends StatelessWidget{
  final IconData icon;
  final VoidCallback onPressed;
  const HeaderIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GroupTaskUi.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: GroupTaskUi.textPrimary, size: 22),
        ),
      ),
    );
  }
}