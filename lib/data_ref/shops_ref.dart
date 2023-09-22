
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/shop_model.dart';
import '../utils/enums.dart';

/// Retrieves a list of shop models from Firebase Firestore.
///
/// This function fetches a list of [ShopModel] instances from Firebase Firestore,
/// containing details of various shops available in the database.
///
/// Returns: A [Future] that completes with a list of [ShopModel] instances.
Future<List<ShopModel>> getShopsRef() async {
  // List to hold the fetched shop models.
  List<ShopModel> list = [];

  // Get a reference to the Firebase Firestore instance.
  var db = FirebaseFirestore.instance;

  // Fetch shops from the Firestore collection.
  await db.collection(FirebaseCollections.SHOP.name)
      .get()
      .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          // Add the fetched shop details to the list.
          list.add(ShopModel.fromJson(docSnapshot.data()));
        }
    },
    onError: (e) => debugPrint("Error completing: $e"),
  );

  // Return the list of fetched shop models.
  return list;
}