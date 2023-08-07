
import 'package:appointment_app_v2/utils/enums.dart';

import '../../data_ref/users_ref.dart';
import 'persistent_bottom_navbar_view_model.dart';

class PersistentBottomNavbarViewModelImp implements PersistentBottomNavbarViewModel{

  @override
  Future<UserRole> getUserRole() {
    return getUserRoleRef();
  }

}