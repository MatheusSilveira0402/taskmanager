import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(80, 82, 178, 173),
      highlightColor: Colors.grey[350]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
