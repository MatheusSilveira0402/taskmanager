import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/stats/pages/stats_page.dart';


class StatsModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const StatsPage());
  }
}