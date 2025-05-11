import 'package:supabase_flutter/supabase_flutter.dart';

class SignOutStore {
  final supabase = Supabase.instance.client;

   Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}