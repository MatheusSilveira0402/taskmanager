import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/stats/pages/stats_page.dart';
import 'package:task_manager_app/app/modules/stats/provider/profile_provider.dart';
import 'package:task_manager_app/app/modules/stats/provider/stats_provider.dart';
import 'package:task_manager_app/app/modules/stats/store/profile_store.dart';
import 'package:task_manager_app/app/modules/stats/store/stats_store.dart';

/// Módulo de Estatísticas (Stats)
/// 
/// O StatsModule é responsável por gerenciar as dependências e rotas relacionadas às estatísticas
/// do usuário no aplicativo. Ele fornece os dados necessários para visualizar as estatísticas
/// de tarefas e perfil do usuário, sendo um dos principais módulos de exibição de dados.
class StatsModule extends Module {
  
  @override
  void binds(Injector i) {
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
  }

  @override
  void routes(RouteManager r) {
    /// Registra as rotas do módulo.
    ///
    /// O método `routes` é utilizado para registrar as rotas que o módulo irá fornecer.
    /// No caso do módulo Stats, há apenas uma rota para a página de estatísticas do usuário.

    // Define a rota principal do módulo, que será a página de estatísticas.
    r.child('/', child: (_) => const StatsPage());
  }
}
