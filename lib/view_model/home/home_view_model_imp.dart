
import 'package:appointment_app_v2/utils/enums.dart';

import '../../data_ref/users_ref.dart';
import 'home_view_model.dart';

class HomeViewModelImp implements HomeViewModel{

  @override
  Future<UserRole> getUserRole() {
    return getUserRoleRef();
  }

}