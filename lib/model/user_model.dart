
import 'dart:typed_data';

import '../utils/constants.dart';
import '../utils/enums.dart';

class UserModel {

  static final String col_userId = "userId";
  static final String col_firstname = "firstname";
  static final String col_lastname = "lastname";
  static final String col_dateOfBirth = "dateOfBirth";
  static final String col_phone = "phone";
  static final String col_email = "email";
  static final String col_role = "role";
  static final String col_imagePath = "imagePath";
  static final String col_imageUnit8list = "imageUnit8list";

  static final String table_name = "tb_users";
  static final String create = "CREATE TABLE $table_name("
      " $col_userId TEXT,"
      " $col_firstname TEXT,"
      " $col_lastname TEXT,"
      " $col_dateOfBirth TEXT,"
      " $col_phone TEXT,"
      " $col_email TEXT,"
      " $col_role TEXT,"
      " $col_imagePath TEXT,"
      " $col_imageUnit8list BLOB"
      ")";

  String userId;
  String firstname;
  String lastname;
  String dateOfBirth;
  String email;
  String phone;
  String role;
  String imagePath;
  Uint8List? imageUnit8list;

  UserModel({
    this.userId = '',
    required this.firstname,
    required this.lastname,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    required this.role,
    this.imagePath = '',
    this.imageUnit8list,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModel &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              firstname == other.firstname &&
              lastname == other.lastname &&
              dateOfBirth == other.dateOfBirth &&
              phone == other.phone &&
              role == other.role &&
              imagePath == other.imagePath &&
              imageUnit8list == other.imageUnit8list;

  @override
  int get hashCode =>
      userId.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      dateOfBirth.hashCode ^
      phone.hashCode ^
      role.hashCode ^
      imagePath.hashCode ^
      imageUnit8list.hashCode;

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json[col_userId] != null ? json[col_userId] : '',
        firstname = json[col_firstname] != null ? json[col_firstname] : '',
        lastname = json[col_lastname] != null ? json[col_lastname] : '',
        dateOfBirth = json[col_dateOfBirth] != null ? json[col_dateOfBirth] : '',
        phone = json[col_phone] != null ? json[col_phone] : '',
        email = json[col_email] != null ? json[col_email] : '',
        role = json[col_role] != null ? json[col_role] : '',
        imagePath = json[col_imagePath]  != null ? json[col_imagePath] : '',
        imageUnit8list = json['imageUnit8list']  != null ? json['imageUnit8list'] : null
  ;

  Map<String, dynamic> toJson() => {
    col_userId: userId,
    col_firstname: firstname,
    col_lastname: lastname,
    col_dateOfBirth: dateOfBirth,
    col_phone: phone,
    col_email: email,
    col_role: role,
    col_imagePath: imagePath,
    col_imageUnit8list: imageUnit8list,
  };

}