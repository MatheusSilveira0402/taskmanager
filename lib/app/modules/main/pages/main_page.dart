import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  // Lista de rotas associadas aos itens do BottomNavigationBar
  final routes = [
    '/main/home/',
    '/main/stats/',
  ];

  @override
  void initState() {
    super.initState();
    // Navega automaticamente para a página de "Início" assim que a página for carregada
    Future.delayed(const Duration(milliseconds: 10), () {
      Modular.to.navigate('/main/home/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Corpo da página, onde a navegação ocorre através do RouterOutlet
      body: const RouterOutlet(),
      // BottomNavigationBar para navegação entre as páginas principais
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex, // Índice da navegação selecionada
          onTap: (index) {
            // Atualiza o índice da navegação e navega para a página correspondente
            setState(() => currentIndex = index);
            Future.delayed(const Duration(milliseconds: 30), () {
              Modular.to.navigate(routes[index]);
            });
          },
          selectedItemColor: const Color(0xFF52B2AD), // Cor do item selecionado
          unselectedItemColor: const Color(0xFF4f787f), // Cor do item não selecionado
          elevation: 4, // Sombra do BottomNavigationBar
          items: const [
            // Item de navegação para "Início"
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            // Item de navegação para "Estatísticas"
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estatísticas'),
          ],
        ),
      ),
    );
  }
}
