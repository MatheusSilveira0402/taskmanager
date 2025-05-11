import 'package:flutter/material.dart';
import 'package:task_manager_app/app/modules/auth/stores/sign_out_store.dart';

class SignOutProvider extends ChangeNotifier{
  final SignOutStore _store;
  SignOutProvider(this._store);


  Future<void> signOut() async {
    await _store.signOut();
  }
}