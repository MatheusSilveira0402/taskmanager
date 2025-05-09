import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/auth_module.dart';
import 'package:task_manager_app/app/modules/main/main_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: AuthModule());
    r.module('/main', module: MainModule());
  }
}
