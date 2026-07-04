import 'package:flutter/material.dart';

class SelectBar extends StatelessWidget {
  final int count;
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final bool isDark;

  const SelectBar({super.key, 
    required this.count,
    required this.onDelete,
    required this.onCancel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C33) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: onDelete,
            ),
            const SizedBox(width: 4),
            Text(
              count == 1 ? '1 message' : '$count messages',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14),
            ),
            const Spacer(),
            SizedBox(
              height: 34,
              child: TextButton(onPressed: onCancel, child: const Text('Cancel')),
            ),
          ],
        ),
      ),
    );
  }
}
