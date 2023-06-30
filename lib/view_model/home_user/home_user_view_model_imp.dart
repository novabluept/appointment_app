
import 'dart:typed_data';
import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data_ref/shops_ref.dart';
import 'home_user_view_model.dart';

class HomeUserModelImp implements HomeUserViewModel{

  @override
  void setCurrentShop(AlwaysAliveRefreshable<StateController<ShopModel>> notifier,WidgetRef ref,ShopModel value) async {
    ref.read(notifier).state = value;
  }

  @override
  Future<Uint8List?> getImageAndCovertToUint8list(String path) async{
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
  Future<List<ShopModel>> getShopsFromFirebase() async{
    List<ShopModel> listShops = await getShopsFromFirebaseRef();

    await Future.forEach(listShops,(element) async {
      Uint8List? image = await getImageAndCovertToUint8list(element.imagePath);
      image != null ? element.imageUnit8list = image : element.imageUnit8list = null;
    });

    return listShops;
  }


}