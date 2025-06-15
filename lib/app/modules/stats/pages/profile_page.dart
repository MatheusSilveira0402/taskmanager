import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';
import 'package:task_manager_app/app/modules/stats/widgets/profile_avatar_.dart';

/// A `ProfilePage` é a página que exibe o perfil do usuário, incluindo
/// informações como nome, email e avatar. A página também permite que o
/// avatar seja movido na interface.
///
/// Ela utiliza o `ProfileProvider` para carregar os dados do perfil
/// do usuário e exibe um indicador de carregamento enquanto os dados
/// estão sendo obtidos.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // O provider que é assistido para observar mudanças no estado
    final provider = context.watch<ProfileProvider>();
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          // Exibe o avatar que pode ser movido
          ProfileAvatar(
            imageUrl: provider.avatar,
            onTap: provider.pickAndUploadAvatar,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exibe o nome do usuário
              Text(
                "Ola, ${provider.name}",
                style: TextStyle(
                  fontSize: context.widthPct(0.050),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00695c),
                ),
              ),
              // Exibe o email do usuário
              Text(
                provider.email,
                style: TextStyle(
                  fontSize: context.widthPct(0.030),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
