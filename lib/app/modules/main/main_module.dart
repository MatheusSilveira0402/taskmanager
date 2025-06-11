import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/services/biometric_service.dart';
import 'package:task_manager_app/app/modules/auth/stores/auth_store.dart';
import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';
import 'package:task_manager_app/app/modules/main/pages/main_page.dart';
import '../home/home_module.dart';
import '../stats/stats_module.dart';

/// `MainModule` é o módulo principal da aplicação, responsável por gerenciar
/// a navegação entre as páginas principais, como a página inicial ("Home") e
/// a página de estatísticas ("Stats").
///
/// Ele configura as rotas principais e os módulos filhos, permitindo uma
/// navegação modular dentro da aplicação.
class MainModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(() => AuthStore());
    i.addSingleton(() => BiometricService());
    i.addSingleton(() => BiometricAuthStore(i<BiometricService>(), i<AuthStore>()));
  }

  @override
  void routes(RouteManager r) {
    // Configura a rota principal '/' para a página MainPage
    r.child(
      '/',
      child: (_) => const MainPage(),
      // Define os módulos filhos associados à navegação
      children: [
        // Rota para o módulo Home, mapeada para 'home'
        ModuleRoute('home', module: HomeModule()),
        // Rota para o módulo Stats, mapeada para 'stats'
        ModuleRoute('stats', module: StatsModule()),
      ],
    );
  }
}
