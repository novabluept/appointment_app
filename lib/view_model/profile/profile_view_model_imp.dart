
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data_ref/users_ref.dart';
import 'profile_view_model.dart';

class ProfileViewModelImp implements ProfileViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

  @override
  Future signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future addUserPicture(File file, String pathToSave) {
    return addUserPictureRef(file, pathToSave);
  }

  @override
  Future updateUser(Map<String, dynamic> fields) async{
    return await updateUserRef(fields);
  }

  @override
  Future deleteUserPicture(String pathToDelete) async{
    final storageRef = FirebaseStorage.instance.ref().child(pathToDelete);

    // Delete the file.
    try {
      await storageRef.delete();
      print('File deleted successfully');
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}