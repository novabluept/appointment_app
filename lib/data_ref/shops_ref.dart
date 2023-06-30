


import 'package:appointment_app_v2/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/shop_model.dart';
import '../state_management/state.dart';
import '../utils/enums.dart';

Future<List<ShopModel>> getShopsFromFirebaseRef() async{

  List<ShopModel> list = [];
  var db = await FirebaseFirestore.instance;


  await db.collection(FirebaseCollections.SHOP.name).get().then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
      list.add(ShopModel.fromJson(docSnapshot.data()));
    }
  },
    onError: (e) => print("Error completing: $e"),
  );

  return list;
}
