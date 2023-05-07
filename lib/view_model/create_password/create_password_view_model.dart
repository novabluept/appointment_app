

import 'dart:io';
import '../../model/user_model.dart';

abstract class CreatePasswordViewModel{

  Future signUp(String email,String password);
  Future addUserDetails(String userId,UserModel user);
  Future addProfilePicture(File image,String path);

}