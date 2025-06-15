import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/home/pages/home_page.dart';
import 'package:task_manager_app/app/modules/home/pages/task_from_page.dart';

/// `HomeModule` é um módulo responsável pela configuração e gerenciamento das dependências e rotas
/// para a página inicial e a página de formulário de tarefas.
///
/// Ele define as dependências do sistema (providers, stores) e as rotas associadas às páginas.
class HomeModule extends Module {
  
  /// Registra as dependências do módulo, incluindo os providers e stores.
  ///
  /// As dependências registradas são acessadas pelo `Injector` e são disponibilizadas
  /// para o restante da aplicação.
  @override
  void binds(Injector i) {
    
  }

  /// Define as rotas do módulo, associando URLs às páginas.
  ///
  /// As rotas definem o comportamento de navegação entre as telas da aplicação.
  @override
  void routes(RouteManager r) {
    // Rota principal do módulo, leva à página HomePage
    r.child('/', child: (_) => const HomePage());
    
    // Rota para o formulário de tarefa, leva à página TaskFormPage
    r.child('/taskform', child: (_) => const TaskFormPage());
  }
}
