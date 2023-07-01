

import 'dart:io';

import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import '../state_management/state.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';


Future signInRef(String email,String password) async{
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
  );
}

Future signInWithGoogleRef() async{
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  User? userCredentialUser = userCredential.user;

  // Add user data to firebase
  if(userCredentialUser != null && userCredential.additionalUserInfo!.isNewUser){

    List<String> nameList = userCredentialUser.displayName!.split(" ");
    String firstName = nameList[0];
    String lastName = nameList[1];

    String? phone = userCredentialUser.phoneNumber;

    /// User Model
    UserModel user = UserModel(
        userId: userCredentialUser.uid,
        firstname: firstName,
        lastname: lastName,
        dateOfBirth: '',
        phone: phone != null ? userCredentialUser.phoneNumber! : '',
        email: userCredentialUser.email!,
        imagePath: '/${FirebaseCollections.USER.name}/${userCredentialUser.uid}',
        role: UserRole.USER.name
    );

    /// Add user details
    await addUserDetailsRef(user);

    /// Add image
    File file = await _urlToFile(userCredentialUser.photoURL!);
    await addProfilePictureRef(file,'/${FirebaseCollections.USER.name}/${userCredentialUser.uid}');
  }

}

Future<File> _urlToFile(String imageUrl) async {
  var rng = new Random();

  Directory tempDir = await getTemporaryDirectory();

  String tempPath = tempDir.path;

  File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');

  http.Response response = await http.get(Uri.parse(imageUrl));

  await file.writeAsBytes(response.bodyBytes);

  return file;
}

/// Register User
Future signUpRef(String email,String password) async{
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
  );
}

Future addUserDetailsRef(UserModel user) async{
  final docUser = FirebaseFirestore.instance.collection(FirebaseCollections.USER.name).doc();

  final json = user.toJson();
  await docUser.set(json);
}

Future addProfilePictureRef(File file,String pathToSave) async{
  if(file.path == PROFILE_IMAGE_DIRECTORY){ /// Se for a imagem default converter para file
    file = await MethodHelper.returnFillProfileImage(PROFILE_IMAGE_DIRECTORY);
  }
  File? imagedCompressed = await MethodHelper.testCompressAndGetFile(file);
  final ref = FirebaseStorage.instance.ref().child(pathToSave);
  ref.putFile(imagedCompressed ?? file);
}
/// Register User

Future sendPasswordResetEmailRef(String email) async{
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

Future sendEmailVerificationRef() async{
  final user = FirebaseAuth.instance.currentUser!;
  await user.sendEmailVerification();
}

Future<UserRole> getUserRoleRef() async{
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String role = "";

  await FirebaseFirestore.instance
      .collection(FirebaseCollections.USER.name)
      .where(UserModel.col_userId, isEqualTo: userId)
      .get()
      .then((querySnapshot) {
          print("Successfully completed");
          var doc = querySnapshot.docs.first;
          role = doc.data()[UserModel.col_role];
        },
        onError: (e) => print("Error completing: $e"),
      );

  switch(role){
    case 'WORKER':
      return UserRole.WORKER;
    default:
      return UserRole.USER;
  }
}

Future<List<UserModel>> getUsersFromFirebaseRef() async{

  List<UserModel> list = [];
  var db = await FirebaseFirestore.instance;

  await db.collection(FirebaseCollections.USER.name).where(UserModel.col_role,whereIn: [UserRole.WORKER.name, UserRole.ADMIN.name]).get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
      Map<String, dynamic> data = docSnapshot.data();
      data[UserModel.col_role] = UserRole.WORKER.name; /// Disfarçar o admin de worker
      list.add(UserModel.fromJson(data));
    }
  },
    onError: (e) => print("Error completing: $e"),
  );

  return list;
}

Future<List<UserModel>> getUsersFromShopsFromFirebaseRef(WidgetRef ref) async{

  List usersFromShop = ref.read(currentShopProvider).users;
  List<UserModel> list = [];

  var db = await FirebaseFirestore.instance;

  await db.collection(FirebaseCollections.USER.name)
      .where(UserModel.col_userId, whereIn: usersFromShop)
      .get()
      .then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
      list.add(UserModel.fromJson(docSnapshot.data()));
    }
  },
    onError: (e) => print("Error completing: $e"),
  );

  return list;
}