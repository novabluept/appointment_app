
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/src/consumer.dart';

import 'package:riverpod/src/framework.dart';

import 'package:riverpod/src/state_controller.dart';

import '../../data_ref/shops_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/shop_model.dart';
import '../../model/user_model.dart';
import '../../state_management/state.dart';
import 'choose_professional_view_model.dart';

class ChooseProfessionalViewModelImp implements ChooseProfessionalViewModel{

  @override
  Future<Uint8List?> getImageAndCovertToUint8list(String path) async{ /// todo: Transformar isto num utils
    final storageRef = FirebaseStorage.instance.ref();

    final islandRef = storageRef.child(path);

    try {
      const oneMegabyte = 1024 * 1024 * 5;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      return data;
    } on Error catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Future<List<UserModel>> getUsersByShopFromFirebase(WidgetRef ref) async {

    List<UserModel> listUsers = await getUsersFromShopsFromFirebaseRef(ref);

    await Future.forEach(listUsers,(element) async {
      Uint8List? image = await getImageAndCovertToUint8list(element.imagePath);
      image != null ? element.imageUnit8list = image : element.imageUnit8list = null;
    });

    return listUsers;
  }


  @override
  void setCurrentUser(AlwaysAliveRefreshable<StateController<UserModel>> notifier, WidgetRef ref, UserModel value) {
    ref.read(notifier).state = value;
  }


}