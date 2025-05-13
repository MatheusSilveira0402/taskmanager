import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Instância global do plugin de notificações locais do Flutter.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Função de entrada exigida pelo `Workmanager`, chamada quando uma tarefa em segundo plano é executada.
///
/// Deve ser anotada com `@pragma('vm:entry-point')` para garantir que
/// seja acessível no isolate em segundo plano.
@pragma('vm:entry-point')
void callbackDispatcher() {
  /// Registra uma função que será executada quando uma tarefa agendada for disparada.
  Workmanager().executeTask((task, inputData) async {
    // Cria uma nova instância do plugin de notificações para este contexto isolado.
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Detalhes da notificação para Android.
    const androidDetails = AndroidNotificationDetails(
      'task_channel_id', // ID do canal de notificação
      'Task Notifications', // Nome do canal (visível ao usuário)
      channelDescription: 'Notificações para lembrar das tarefas',
      importance: Importance.max, // Nível de importância alto
      priority: Priority.high, // Alta prioridade para exibir a notificação imediatamente
    );

    /// Detalhes da notificação para múltiplas plataformas.
    const platformDetails = NotificationDetails(android: androidDetails);

    // Recupera dados passados para a tarefa.
    final taskId = inputData?['taskId'];
    final taskTitle = inputData?['taskTitle'];

    // Exibe uma notificação local usando os dados da tarefa.
    await flutterLocalNotificationsPlugin.show(
      taskId.hashCode, // ID único da notificação
      'Lembrete de tarefa', // Título da notificação
      taskTitle, // Corpo da notificação
      platformDetails, // Configurações da notificação
    );

    // Retorna true indicando que a tarefa foi concluída com sucesso.
    return Future.value(true);
  });
}
