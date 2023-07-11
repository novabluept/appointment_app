


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/appointment_model.dart';
import '../utils/enums.dart';

Stream<List<AppointmentModel>> getAppointmentByProfessionalShopStatusDateFromFirebaseRef(String professionalId,String shopId,String status,String date) async*{

  var db = await FirebaseFirestore.instance;

  print("col_professionalId: "+professionalId);
  print("col_shopId: "+shopId);
  print("col_status: "+status);
  print("col_date: "+date);

  yield* db.collection(FirebaseCollections.APPOINTMENT.name)
      .where(AppointmentModel.col_professionalId, isEqualTo: professionalId)
      .where(AppointmentModel.col_shopId,isEqualTo: shopId)
      .where(AppointmentModel.col_status, isEqualTo: status)
      .where(AppointmentModel.col_date,isEqualTo: date)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.map((docSnapshot) => AppointmentModel.fromJson(docSnapshot.data())).toList());

}
