import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    profileProvider.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              provider.avatar.isNotEmpty ? NetworkImage(provider.avatar) : null,
          child: provider.avatar.isNotEmpty
              ? null
              : const Icon(Icons.person,
                  size: 40, color: Colors.white70), // Imagem padrão
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ola, ${provider.name}",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00695c),
              ),
            ),
            Text(
              provider.email,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        )
      ],
    );
  }
}
