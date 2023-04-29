

import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';


Future signInRef(String email,String password) async{
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
  );
}

Future signUpRef(String email,String password) async{
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
  );
}

Future addUserDetailsRef(UserModel user) async{
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final docUser = FirebaseFirestore.instance.collection(USER).doc();
  user.userId = userId!;

  final json = user.toJson();
  await docUser.set(json);
}