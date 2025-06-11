import 'package:flutter/material.dart';
import 'package:task_manager_app/app/widgets/skeleton_circle.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;
  final double radius;
  final bool isLoading;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    required this.onTap,
    this.radius = 50,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl!.isNotEmpty && !isLoading) {
      imageWidget = Image.network(
        imageUrl!,
        fit: BoxFit.fill,
        width: radius * 2,
        height: radius * 2,
      );
    } else if (isLoading) {
      imageWidget = SkeletonCircle(size: radius * 2);
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 50,
        color: Colors.white70,
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: ClipOval(child: imageWidget),
      ),
    );
  }
}
