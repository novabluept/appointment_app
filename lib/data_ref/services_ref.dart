

import 'package:appointment_app_v2/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/service_model.dart';
import '../model/user_model.dart';

Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebaseRef(String professionalId,String shopId) async{

  List<ServiceModel> list = [];
  var db = await FirebaseFirestore.instance;

  print("col_userId: "+professionalId.toString());
  print("col_shopId: "+shopId.toString());

  await db.collection(FirebaseCollections.SERVICE.name)
      .where(ServiceModel.col_professionalId, isEqualTo: professionalId)
      .where(ServiceModel.col_shopId, isEqualTo: shopId)
      .get()
      .then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      //print('${docSnapshot.id} => ${docSnapshot.data()}');
      list.add(ServiceModel.fromJson(docSnapshot.data()));
    }
  },
    onError: (e) => print("Error completing: $e"),
  );

  return list;
}