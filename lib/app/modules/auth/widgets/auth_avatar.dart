import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/providers/auth_avatar_provider.dart';
import 'package:task_manager_app/app/widgets/skeleton_circle.dart';

class AuthAvatar extends StatelessWidget {
  final double radius;
  const AuthAvatar({Key? key, this.radius = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Modular.get<AuthAvatarProvider>();

    return AnimatedBuilder(
      animation: provider,
      builder: (context, _) {
        final isLoading = provider.loading;
        final imageUrl = provider.avatar;

        Widget imageWidget;
        if (imageUrl.isNotEmpty && !isLoading) {
          imageWidget = Image.network(
            imageUrl,
            fit: BoxFit.fill,
            width: radius * 2,
            height: radius * 2,
          );
        } else if (isLoading) {
          imageWidget = SkeletonCircle(size: radius * 2);
        } else {
          imageWidget = const Icon(Icons.person, size: 50, color: Colors.white70);
        }

        return GestureDetector(
          onTap: isLoading ? null : provider.pickAndUploadAvatar,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[300],
            child: ClipOval(child: imageWidget),
          ),
        );
      },
    );
  }
}