import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/stats/pages/stats_page.dart';

/// Módulo de Estatísticas (Stats)
/// 
/// O StatsModule é responsável por gerenciar as dependências e rotas relacionadas às estatísticas
/// do usuário no aplicativo. Ele fornece os dados necessários para visualizar as estatísticas
/// de tarefas e perfil do usuário, sendo um dos principais módulos de exibição de dados.
class StatsModule extends Module {
  
  @override
  void binds(Injector i) {
   
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
