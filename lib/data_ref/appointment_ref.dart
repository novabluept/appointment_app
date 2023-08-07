


import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/appointment_model.dart';
import '../state_management/make_appointments_state.dart';
import '../utils/enums.dart';
import '../utils/method_helper.dart';
import '../view_model/choose_schedule/choose_schedule_view_model_imp.dart';

Stream<List<AppointmentModel>> getAppointmentByProfessionalShopStatusDateFromFirebaseRef(String professionalId,String shopId,AppointmentStatus status,String date) async*{

  var db = await FirebaseFirestore.instance;

  print("col_professionalId: "+professionalId);
  print("col_shopId: "+shopId);
  print("col_status: "+status.name);
  print("col_date: "+date);

  yield* db.collection(FirebaseCollections.APPOINTMENT.name)
      .where(AppointmentModel.col_professionalId, isEqualTo: professionalId)
      .where(AppointmentModel.col_shopId,isEqualTo: shopId)
      .where(AppointmentModel.col_status, isEqualTo: status.name)
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

Stream<List<AppointmentModel>> getUserAppointmentsRef(AppointmentStatus status) async* {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser!;
  List<AppointmentModel> list = [];

  var db = await FirebaseFirestore.instance;

  await for (var querySnapshot in db
      .collection(FirebaseCollections.APPOINTMENT.name)
      .where(AppointmentModel.col_clientId, isEqualTo: user.uid)
      .where(AppointmentModel.col_status, isEqualTo: status.name)
      .snapshots()) {
    list = querySnapshot.docs
        .map((docSnapshot) => AppointmentModel.fromJson(docSnapshot.data()))
        .toList();

    await Future.forEach(list, (element) async {
      Uint8List? image = await MethodHelper.getImageAndCovertToUint8list(element.professionalImagePath);
      element.professionalImageUint8list = image;
    });

    yield list;
  }
}

