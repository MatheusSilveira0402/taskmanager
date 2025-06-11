import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

Future<void> saveSecureData(String key, String value) async {
  await storage.write(key: key, value: value);
}

Future<String?> getSecureData(String key) async {
  return await storage.read(key: key);
}

Future<void> clearSecureData() async {
  await storage.delete(key: 'email');
  await storage.delete(key: 'password');
}

