import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidDetails = AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notificações para lembrar das tarefas',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    final taskId = inputData?['taskId'];
    final taskTitle = inputData?['taskTitle'];
    
    await flutterLocalNotificationsPlugin.show(
      taskId.hashCode,
      'Lembrete de tarefa',
      taskTitle,
      platformDetails,
    );
    return Future.value(true);
  });
}
