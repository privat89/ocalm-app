import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double height;
  final String label;
  final bool isMax;

  const ChartBar({
    super.key,
    required this.height,
    required this.label,
    this.isMax = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            width: 40,
            height: height * 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: isMax
                    ? [const Color(0xFF0066FF), const Color(0xFF4D94FF)]
                    : [const Color(0xFF0066FF).withOpacity(0.3), const Color(0xFF4D94FF).withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isMax ? const Color(0xFF0066FF) : const Color(0xFF6B7280),
              fontWeight: isMax ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
