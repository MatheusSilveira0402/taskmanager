import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/core/env.dart';


import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  await Firebase.initializeApp();

  // 2) Inicializa as notificações
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _notifs.initialize(
    const InitializationSettings(android: androidInit),
  );

   // Solicita permissão no iOS e inicia notificações
  await _initFCM();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

final FlutterLocalNotificationsPlugin _notifs =
    FlutterLocalNotificationsPlugin();

// Esta key será usada pelo WorkManager
// ignore: constant_identifier_names
const String TASK_UPDATE_CALLBACK = "taskUpdateCallback";


Future<void> _initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicita permissão para iOS
  await messaging.requestPermission();

  // Obtém e imprime o token FCM do dispositivo
  String? token = await messaging.getToken();
}
