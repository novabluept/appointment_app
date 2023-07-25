


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/appointment_model.dart';
import '../state_management/appointments_state.dart';
import '../utils/enums.dart';
import '../view_model/choose_schedule/choose_schedule_view_model_imp.dart';

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

Future addAppointmentRef(AppointmentModel appointment) async{
  final docAppointment = FirebaseFirestore.instance.collection(FirebaseCollections.APPOINTMENT.name).doc();

  appointment.appointmentId = docAppointment.id;
  final json = appointment.toJson();

  await docAppointment.set(json);
}
