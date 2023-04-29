

import '../../data_ref/users_ref.dart';
import 'login_view_model.dart';

class LoginViewModelImp implements LoginViewModel{

  @override
  Future signIn(String email, String password) {
    return signInRef(email,password);
  }

}