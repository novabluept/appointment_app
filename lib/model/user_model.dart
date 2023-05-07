
import '../utils/constants.dart';
import '../utils/enums.dart';

class UserModel {

  /*static final String col_userId = "userId";
  static final String col_firstname = "firstname";
  static final String col_lastname = "lastname";
  static final String col_phone = "phone";
  static final String col_email = "email";  /// Address
  static final String col_role = "role";
  static final String col_imagePath = "imagePath";
  static final String col_imageUnit8list = "imageUnit8list";

  static final String table_name = "tb_workers";
  static final String create = "CREATE TABLE $table_name("
      " $col_userId TEXT,"
      " $col_firstname TEXT,"
      " $col_lastname TEXT,"
      " $col_phone TEXT,"
      " $col_email TEXT,"
      " $col_role TEXT,"
      " $col_imagePath TEXT,"
      " $col_imageUnit8list BLOB"
      ")";*/

  String userId;
  String firstname;
  String lastname;
  String dateOfBirth;
  String email;
  String phone;
  String role;
  String imagePath;

  UserModel({
    this.userId = '',
    required this.firstname,
    required this.lastname,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    required this.role,
    this.imagePath = '',
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
              imagePath == other.imagePath;

  @override
  int get hashCode =>
      userId.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      dateOfBirth.hashCode ^
      phone.hashCode ^
      role.hashCode ^
      imagePath.hashCode;

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] != null ? json['userId'] : '',
        firstname = json['firstname'] != null ? json['firstname'] : '',
        lastname = json['lastname'] != null ? json['lastname'] : '',
        dateOfBirth = json['dateOfBirth'] != null ? json['dateOfBirth'] : '',
        phone = json['phone'] != null ? json['phone'] : '',
        email = json['email'] != null ? json['email'] : '',
        role = json['role'] != null ? json['role'] : '',
        imagePath = json['imagePath']  != null ? json['imagePath'] : ''
  ;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'firstname': firstname,
    'lastname': lastname,
    'dateOfBirth': dateOfBirth,
    'phone': phone,
    'email': email,
    'role': role,
    'imagePath': imagePath,
  };

}