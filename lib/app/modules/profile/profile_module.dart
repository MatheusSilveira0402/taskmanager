import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/profile/pages/profile_page.dart';


class ProfileModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const ProfilePage());
  }
}