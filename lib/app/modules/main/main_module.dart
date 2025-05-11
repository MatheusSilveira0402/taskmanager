import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/main/pages/main_page.dart';
import '../home/home_module.dart';
import '../stats/stats_module.dart';

class MainModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (_) => const MainPage(),
      children: [
        ModuleRoute('home', module: HomeModule()),
        ModuleRoute('stats', module: StatsModule()),
      ],
    );
  }
}
