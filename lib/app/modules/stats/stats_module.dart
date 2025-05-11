import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/stats/pages/stats_page.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';
import 'package:task_manager_app/app/modules/stats/provider/stats_provider.dart';
import 'package:task_manager_app/app/modules/stats/store/profile_store.dart';
import 'package:task_manager_app/app/modules/stats/store/stats_store.dart';

class StatsModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<StatsStore>(() => StatsStore());
    i.addSingleton<StatsProvider>(() => StatsProvider(i<StatsStore>()));
    i.addSingleton<ProfileStore>(() => ProfileStore());
    i.addSingleton<ProfileProvider>(() => ProfileProvider(i<ProfileStore>()));
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const StatsPage());
  }
}
