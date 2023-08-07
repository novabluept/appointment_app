
import 'dart:typed_data';
import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data_ref/shops_ref.dart';
import '../../utils/method_helper.dart';
import 'home_user_view_model.dart';

class HomeUserModelImp implements HomeUserViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value) {
    ref.read(notifier).state = value;
  }

  @override
  Future<List<ShopModel>> getShopsFromFirebase() async{
    List<ShopModel> list = await getShopsFromFirebaseRef();

    await Future.forEach(list,(element) async {
      Uint8List? image = await MethodHelper.getImageAndCovertToUint8list(element.imagePath);
      image != null ? element.imageUnit8list = image : element.imageUnit8list = null;
    });

    return list;
  }


}