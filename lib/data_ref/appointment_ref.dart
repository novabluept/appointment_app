
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/appointment_model.dart';
import '../utils/enums.dart';
import '../utils/method_helper.dart';

/// Retrieves a stream of appointments from Firebase based on various criteria.
///
/// This function fetches a stream of [AppointmentModel] instances from Firebase
/// Firestore based on the provided criteria: professional ID, shop ID, appointment
/// status, and appointment date. The resulting stream emits lists of [AppointmentModel]
/// instances that match the specified criteria.
///
/// Parameters:
/// - [professionalId]: The ID of the professional associated with the appointments.
/// - [shopId]: The ID of the shop associated with the appointments.
/// - [status]: The desired [AppointmentStatus] to filter appointments.
/// - [date]: The specific date for which appointments are to be fetched.
///
/// Returns: A [Stream] that emits lists of [AppointmentModel] instances matching the criteria.
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

/// Adds a new appointment to Firebase Firestore.
///
/// This function creates a new appointment in the Firebase Firestore database.
/// The provided [appointment] instance is stored with a generated appointment ID.
///
/// Parameters:
/// - [appointment]: The [AppointmentModel] instance representing the appointment to be added.
///
/// Returns: A [Future] that completes when the appointment is successfully added.
Future<void> addAppointmentRef(AppointmentModel appointment) async {
  // Create a new document reference within the "appointments" collection.
  final docAppointment = FirebaseFirestore.instance.collection(FirebaseCollections.APPOINTMENT.name).doc();

  // Set the generated appointment ID within the appointment model.
  appointment.appointmentId = docAppointment.id;

  // Convert the appointment model to JSON format.
  final json = appointment.toJson();

  // Set the JSON data within the document reference.
  await docAppointment.set(json);
}


/// Retrieves a stream of appointments for the current user based on the specified status.
///
/// This function fetches a stream of [AppointmentModel] instances from Firebase
/// Firestore that belong to the currently logged-in user and match the provided
/// [status]. The resulting stream emits lists of [AppointmentModel] instances
/// that fulfill the criteria.
///
/// Parameters:
/// - [status]: The [AppointmentStatus] to filter appointments.
///
/// Returns: A [Stream] that emits lists of [AppointmentModel] instances for the user.
Stream<List<AppointmentModel>> getUserAppointmentsRef(AppointmentStatus status) async* {
  // Retrieve the current user's authentication information.
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser!;

  // List to hold the fetched appointment models.
  List<AppointmentModel> list = [];

  // Get a reference to the Firebase Firestore instance.
  var db = await FirebaseFirestore.instance;

  // Listen to snapshots from the Firestore collection based on user's appointments.
  await for (var querySnapshot in db
      .collection(FirebaseCollections.APPOINTMENT.name)
      .where(AppointmentModel.col_clientId, isEqualTo: user.uid)
      .where(AppointmentModel.col_status, isEqualTo: status.name)
      .snapshots()) {
    // Map the document snapshots to AppointmentModel instances.
    list = querySnapshot.docs
        .map((docSnapshot) => AppointmentModel.fromJson(docSnapshot.data()))
        .toList();

    // Fetch and assign professional images to appointment models.
    await Future.forEach(list, (element) async {
      Uint8List? image = await MethodHelper.getImageAndCovertToUint8list(element.professionalImagePath);
      element.professionalImageUint8list = image;
    });

    // Yield the list of appointment models.
    yield list;
  }
}


