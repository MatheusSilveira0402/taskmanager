import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/home/pages/home_page.dart';
import 'package:task_manager_app/app/modules/home/pages/task_from_page.dart';
import 'package:task_manager_app/app/modules/home/providers/task_provider.dart';
import 'package:task_manager_app/app/modules/home/stores/task_store.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<TaskStore>(() => TaskStore());
    i.addSingleton<TaskProvider>(() => TaskProvider(i.get<TaskStore>()));
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
    r.child('/taskform', child: (_) => const TaskFormPage());
  }
}
