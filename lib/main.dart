import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager_app/app/core/env.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager_app/app/core/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  // Inicialize o Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // Defina como false em produção
  );

  // Permissão para notificações 
  _requestNotificationPermission();

  // Inicializa timezone e notificações
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logo_app');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

Future<void> _requestNotificationPermission() async {
  if (Platform.isAndroid && await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
