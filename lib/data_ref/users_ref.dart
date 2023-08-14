
import 'dart:io';
import 'dart:typed_data';
import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';
import '../state_management/choose_shop_state.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

/// Signs in a user using their email and password.
///
/// This function attempts to sign in a user using the provided [email] and [password]
/// credentials through FirebaseAuth. If the provided credentials are valid and match
/// a registered user, the user is successfully signed in.
///
/// Parameters:
/// - [email]: The user's email address.
/// - [password]: The user's password.
///
/// Returns: A [Future] that completes when the sign-in process is finished.
Future<void> signInRef(String email, String password) async {
  // Attempt to sign in the user using FirebaseAuth.
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// Signs in a user using their Google account.
///
/// This function initiates the Google authentication flow and allows a user
/// to sign in using their Google account. Upon successful authentication,
/// the user's information is retrieved and stored in Firebase Firestore.
///
/// Returns: A [Future] that completes when the Google sign-in process is finished.
Future<void> signInWithGoogleRef() async {
  // Trigger the Google authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the Google sign-in request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential using GoogleAuthProvider
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Sign in with the Google credential using FirebaseAuth
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  User? userCredentialUser = userCredential.user;

  // Add user data to Firebase if user is new
  if (userCredentialUser != null && userCredential.additionalUserInfo!.isNewUser) {
    List<String> nameList = userCredentialUser.displayName!.split(" ");
    String firstName = nameList[0];
    String lastName = nameList[1];

    String? phone = userCredentialUser.phoneNumber;

    // Create a new UserModel instance
    UserModel user = UserModel(
      userId: userCredentialUser.uid,
      firstname: firstName,
      lastname: lastName,
      dateOfBirth: '',
      phone: phone != null ? userCredentialUser.phoneNumber! : '',
      email: userCredentialUser.email!,
      imagePath: '/${FirebaseCollections.USER.name}/${userCredentialUser.uid}',
      role: UserRole.USER.name,
    );

    // Add user details to Firebase
    await addUserRef(user);

    // Add user profile picture
    File file = await MethodHelper.urlToFile(userCredentialUser.photoURL!);
    await addUserPictureRef(file, '/${FirebaseCollections.USER.name}/${userCredentialUser.uid}');
  }
}

/// Creates a new user account using the provided email and password.
///
/// This function attempts to create a new user account in FirebaseAuth using the
/// provided [email] and [password] credentials. If the provided credentials are
/// valid and the account is successfully created, a new user is registered.
///
/// Parameters:
/// - [email]: The email address for the new user account.
/// - [password]: The password for the new user account.
///
/// Returns: A [Future] that completes when the account creation process is finished.
Future<void> signUpRef(String email, String password) async {
  // Attempt to create a new user account using FirebaseAuth.
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// Adds a user to Firebase Firestore.
///
/// This function creates a new document in the "users" collection of Firebase Firestore
/// and populates it with the provided [user] details in JSON format.
///
/// Parameters:
/// - [user]: The [UserModel] instance representing the user to be added.
///
/// Returns: A [Future] that completes when the user is successfully added.
Future<void> addUserRef(UserModel user) async {
  // Use the user's userId as the document ID.
  final docUser = FirebaseFirestore.instance
      .collection(FirebaseCollections.USER.name)
      .doc(user.userId); // Assuming `uuid` is the field in your `UserModel`.

  // Convert the user model to JSON format.
  final json = user.toJson();

  // Set the JSON data within the document reference.
  await docUser.set(json);
}



/// Uploads a profile picture to Firebase Storage.
///
/// This function uploads the provided [file] (image) to Firebase Storage under
/// the specified [pathToSave]. If the provided [file] represents the default
/// profile image, it is converted to an actual file before uploading. The uploaded
/// image may also be compressed before being stored.
///
/// Parameters:
/// - [file]: The [File] instance representing the image to be uploaded.
/// - [pathToSave]: The path under which the image should be saved in Firebase Storage.
///
/// Returns: A [Future] that completes when the image upload is finished.
Future<void> addUserPictureRef(File file, String pathToSave) async {
  // Check if the provided file represents the default profile image.
  if (file.path == PROFILE_IMAGE_DIRECTORY) {
    // Convert to an actual file representing the default profile image.
    file = await MethodHelper.returnFillProfileImage(PROFILE_IMAGE_DIRECTORY);
  }

  // Compress the image (if applicable).
  File? imageCompressed = await MethodHelper.testCompressAndGetFile(file);

  // Get a reference to the Firebase Storage instance.
  final ref = FirebaseStorage.instance.ref().child(pathToSave);

  // Upload the image to Firebase Storage.
  ref.putFile(imageCompressed ?? file);
}

/// Sends a password reset email to the provided email address.
///
/// This function sends a password reset email to the specified [email] address
/// through FirebaseAuth. If the provided email is associated with a registered
/// user, they will receive instructions to reset their password.
///
/// Parameters:
/// - [email]: The email address to which the password reset email will be sent.
///
/// Returns: A [Future] that completes when the password reset email is sent.
Future<void> sendPasswordResetEmailRef(String email) async {
  // Send a password reset email using FirebaseAuth.
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

/// Sends an email verification link to the current user's email address.
///
/// This function sends an email verification link to the email address associated
/// with the current user's account through FirebaseAuth. The user will receive an
/// email containing a link to verify their email address.
///
/// Returns: A [Future] that completes when the email verification link is sent.
Future<void> sendEmailVerificationRef() async {
  // Get the current user's information from FirebaseAuth.
  final user = FirebaseAuth.instance.currentUser!;

  // Send an email verification link to the user's email address.
  await user.sendEmailVerification();
}

Future<UserModel> getUserRef() async {
  // Get the UID of the current user from FirebaseAuth.
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Get a reference to the Firebase Firestore instance.
  return await FirebaseFirestore.instance
      .collection(FirebaseCollections.USER.name)
      .doc(userId)
      .get()
      .then((documentSnapshot) async{

        Map<String, dynamic>? data = documentSnapshot.data();
        UserModel user = UserModel.fromJson(data!);

        Uint8List? image = await MethodHelper.getImageAndConvertToUint8List(user.imagePath);
        image != null ? user.imageUnit8list = image : user.imageUnit8list = null;

        return user;
      }
    );

}

/// Retrieves a list of users associated with the current shop from Firebase Firestore.
///
/// This function fetches a list of [UserModel] instances from Firebase Firestore,
/// based on the list of professionals associated with the current shop.
///
/// Parameters:
/// - [ref]: A [WidgetRef] used to access state data (e.g., professionals associated with a shop).
///
/// Returns: A [Future] that completes with a list of [UserModel] instances.
Future<List<UserModel>> getProfessionalUsersByShopRef(WidgetRef ref) async {
  // Get the list of professionals associated with the current shop.
  List usersFromShop = ref.read(currentShopProvider).professionals;

  // List to hold the fetched user models.
  List<UserModel> list = [];

  // Get a reference to the Firebase Firestore instance.
  var db = await FirebaseFirestore.instance;

  // Fetch users associated with the shop from the Firestore collection.
  await db.collection(FirebaseCollections.USER.name)
      .where(UserModel.col_userId, whereIn: usersFromShop)
      .get()
      .then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // Add the fetched user details to the list.
        list.add(UserModel.fromJson(docSnapshot.data()));
      }
    },
    onError: (e) => debugPrint("Error completing: $e"),
  );

  // Return the list of fetched user models.
  return list;
}