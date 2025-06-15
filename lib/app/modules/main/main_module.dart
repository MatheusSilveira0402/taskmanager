import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/auth/providers/sign_out_provider.dart';
import 'package:task_manager_app/app/modules/auth/services/biometric_service.dart';
import 'package:task_manager_app/app/modules/auth/stores/auth_store.dart';
import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';
import 'package:task_manager_app/app/modules/auth/stores/sign_out_store.dart';
import 'package:task_manager_app/app/modules/home/providers/task_provider.dart';
import 'package:task_manager_app/app/modules/home/stores/task_store.dart';
import 'package:task_manager_app/app/modules/main/pages/main_page.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';
import 'package:task_manager_app/app/modules/stats/provider/stats_provider.dart';
import 'package:task_manager_app/app/modules/stats/store/profile_store.dart';
import 'package:task_manager_app/app/modules/stats/store/stats_store.dart';
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
    i.addSingleton<SignOutStore>(
        () => SignOutStore()); // Adiciona o SignOutStore como dependência singleton
    // Adiciona o TaskProvider com o TaskStore
    /// Registra as dependências do módulo.
    ///
    /// O método `binds` é utilizado para registrar os serviços e provedores que serão
    /// utilizados nas páginas ou providers do módulo.

    // Registra o StatsStore como um Singleton, garantindo que a instância do StatsStore
    // seja a mesma durante todo o ciclo de vida do módulo.
    i.addSingleton<StatsStore>(() => StatsStore());

    // Registra o StatsProvider como um Singleton. Ele depende do StatsStore para gerenciar o
    // estado e manipular as informações de estatísticas.
    i.addSingleton<StatsProvider>(() => StatsProvider(i<StatsStore>()));

    // Registra o ProfileStore como um Singleton. O ProfileStore é responsável pela lógica de
    // manipulação do perfil do usuário, incluindo as informações do perfil no banco de dados.
    i.addSingleton<ProfileStore>(() => ProfileStore());

    // Registra o ProfileProvider como um Singleton. O ProfileProvider fornece dados relacionados
    // ao perfil do usuário, como nome, email e avatar.
    i.addSingleton<ProfileProvider>(() => ProfileProvider(i<ProfileStore>()));

    i.addSingleton<SignOutProvider>(() => SignOutProvider(
        i.get<SignOutStore>())); // Adiciona o SignOutProvider com o SignOutStore
    i.addSingleton<TaskStore>(
        () => TaskStore()); // Adiciona o TaskStore como dependência singleton
    i.addSingleton<TaskProvider>(() =>
        TaskProvider(i.get<TaskStore>(), i.get<StatsProvider>()));
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
