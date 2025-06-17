import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';
import 'package:task_manager_app/app/modules/auth/widgets/auth_modal.dart';
import 'package:task_manager_app/app/modules/main/widgets/nav_item.dart';

/// `MainPage` é uma página que exibe a interface principal da aplicação,
/// com um `BottomNavigationBar` para navegar entre as páginas de "Início" e "Estatísticas".
///
/// Ela utiliza o Flutter Modular para gerenciar a navegação interna da aplicação.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Índice atual do BottomNavigationBar
  int currentIndex = 0;
  final _biometricStore = Modular.get<BiometricAuthStore>();

  // Lista de rotas associadas aos itens do BottomNavigationBar
  final routes = [
    '/main/home/',
    '/main/stats/',
  ];

  @override
  void initState() {
    super.initState();

    if (!context.mounted) return;
    // Mostra modal para habilitar a biometria apenas uma vez
    showBiometricModal(context, _biometricStore);
    Future.delayed(const Duration(microseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Modular.to.navigate(routes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Conteúdo principal da página
          const RouterOutlet(),

          // Barra personalizada por cima do conteúdo
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: context.heightPct(0.1) - 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavItem(
                    icon: Icons.list,
                    label: 'Afazeres',
                    selected: currentIndex == 0,
                    onTap: () {
                      Modular.to.navigate(routes[0]);
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                  ),
                  NavItem(
                    icon: Icons.insights,
                    label: 'Visão Geral',
                    selected: currentIndex == 1,
                    onTap: () {
                      Modular.to.navigate(routes[1]);
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
