
import 'dart:io';

import 'package:appointment_app_v2/model/user_model.dart';
import '../../data_ref/users_ref.dart';
import 'create_password_view_model.dart';

class CreatePasswordModelImp implements CreatePasswordViewModel{

  @override
  Future signUp(String email, String password) {
    return signUpRef(email, password);
  }

  @override
  Future addUserDetails(String userId,UserModel user) {
    return addUserDetailsRef(user);
  }

  @override
  Future addProfilePicture(File file, String pathToSave) {
    return addProfilePictureRef(file, pathToSave);
  }

}