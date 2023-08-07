
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/service_model.dart';

/// Retrieves a list of services based on the specified professional and shop IDs.
///
/// This function fetches a list of [ServiceModel] instances from Firebase Firestore
/// that match the provided [professionalId] and [shopId]. The resulting list contains
/// service details associated with the specified professional and shop.
///
/// Parameters:
/// - [professionalId]: The ID of the professional associated with the services.
/// - [shopId]: The ID of the shop associated with the services.
///
/// Returns: A [Future] that completes with a list of [ServiceModel] instances.
Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebaseRef(
    String professionalId,
    String shopId,
    ) async {
  // List to hold the fetched service models.
  List<ServiceModel> list = [];

  // Get a reference to the Firebase Firestore instance.
  var db = await FirebaseFirestore.instance;

  // Print debugging information.
  print("col_userId: " + professionalId.toString());
  print("col_shopId: " + shopId.toString());

  // Fetch services based on professional and shop IDs.
  await db.collection(FirebaseCollections.SERVICE.name)
      .where(ServiceModel.col_professionalId, isEqualTo: professionalId)
      .where(ServiceModel.col_shopId, isEqualTo: shopId)
      .get()
      .then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // Add the fetched service details to the list.
        list.add(ServiceModel.fromJson(docSnapshot.data()));
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  // Return the list of fetched service models.
  return list;
}
