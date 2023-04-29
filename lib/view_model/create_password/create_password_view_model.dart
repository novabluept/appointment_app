

import '../../model/user_model.dart';

abstract class CreatePasswordViewModel{

  Future signUp(String email,String password);
  Future addUserDetails(UserModel user);

}