
import 'dart:io';
import '../../model/user_model.dart';

abstract class CreatePasswordViewModel{

  Future signUp(String email,String password);
  Future addUser(String userId,UserModel user);
  Future addUserPicture(File image,String path);
  Future sendEmailVerification();

}