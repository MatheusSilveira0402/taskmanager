import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/auth_module.dart';
import 'package:task_manager_app/app/modules/main/main_module.dart';

/// Define os módulos principais da aplicação e suas rotas.
///
/// Este módulo é responsável por declarar os submódulos que compõem
/// a estrutura principal do app, como autenticação e o módulo principal.
class AppModule extends Module {
  /// Registra dependências globais da aplicação.
  /// 
  /// Neste exemplo, nenhum binding é definido.
  @override
  void binds(Injector i) {
    // Nenhum binding global no momento.
  }

  /// Define as rotas do módulo principal da aplicação.
  ///
  /// - `'/'` redireciona para o [AuthModule] (login, registro etc).
  /// - `'/main'` redireciona para o [MainModule] (interface principal do app).
  @override
  void routes(RouteManager r) {
    r.module('/', module: AuthModule());
    r.module('/main', module: MainModule());
  }
}
