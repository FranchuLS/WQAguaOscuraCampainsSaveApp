import 'package:flutter/material.dart';

class PendingLevelTile extends StatelessWidget {
  final String text;

  const PendingLevelTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF2D2234),
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}