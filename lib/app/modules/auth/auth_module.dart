import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/pages/login_page.dart';
import 'package:task_manager_app/app/modules/auth/pages/register_page.dart';
import 'stores/auth_store.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(() => AuthStore());
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => LoginPage());
    r.child('/register', child: (_) => RegisterPage());
  }
}
