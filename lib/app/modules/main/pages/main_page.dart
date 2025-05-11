import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final routes = [
    '/main/home/',
    '/main/stats/',
  ];

  @override
  void initState() {
    super.initState();
    Modular.to.navigate(routes[currentIndex]); // Inicial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
            Modular.to.navigate(routes[index]);
          },
          selectedItemColor: const Color(0xFF52B2AD),
          unselectedItemColor: const Color(0xFF4f787f),
          elevation: 4,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estatísticas'),
          ],
        ),
      ),
    );
  }
}
