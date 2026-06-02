import 'package:flutter/material.dart';

class StateChipWidget extends StatelessWidget{
  final String label;
  final String value;
  final Color color;

  const StateChipWidget({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );

  }
}