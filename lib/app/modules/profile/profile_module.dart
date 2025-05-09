import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/modules/profile/pages/profile_page.dart';
import 'package:task_manager_app/app/modules/profile/providers/profile_provider.dart';
import 'package:task_manager_app/app/modules/profile/store/profile_store.dart';


class ProfileModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<ProfileStore>(() => ProfileStore());
    i.addSingleton<ProfileProvider>(() => ProfileProvider(i<ProfileStore>()));
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const ProfilePage());
  }
}