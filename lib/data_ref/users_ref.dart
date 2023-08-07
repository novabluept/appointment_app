
import 'dart:io';
import 'dart:math';
import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
    await addUserDetailsRef(user);

    // Add user profile picture
    File file = await _urlToFile(userCredentialUser.photoURL!);
    await addProfilePictureRef(file, '/${FirebaseCollections.USER.name}/${userCredentialUser.uid}');
  }
}


/// Downloads an image from a URL and saves it as a temporary file.
///
/// This function downloads an image from the specified [imageUrl], saves it as a
/// temporary file on the device, and returns the [File] instance representing the
/// downloaded image.
///
/// Parameters:
/// - [imageUrl]: The URL of the image to be downloaded.
///
/// Returns: A [Future] that completes with the [File] instance of the downloaded image.
Future<File> _urlToFile(String imageUrl) async {
  var rng = new Random();

  // Get the device's temporary directory
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

  // Generate a unique filename for the downloaded image
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');

  // Download the image using an HTTP request
  http.Response response = await http.get(Uri.parse(imageUrl));

  // Write the downloaded image data to the temporary file
  await file.writeAsBytes(response.bodyBytes);

  // Return the File instance of the downloaded image
  return file;
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


/// Adds user details to Firebase Firestore.
///
/// This function adds the provided [user] details to the Firebase Firestore database.
/// The user details are stored in the "users" collection under a newly generated document.
///
/// Parameters:
/// - [user]: The [UserModel] instance representing the user details to be added.
///
/// Returns: A [Future] that completes when the user details are successfully added.
Future<void> addUserDetailsRef(UserModel user) async {
  // Create a new document reference within the "users" collection.
  final docUser = FirebaseFirestore.instance.collection(FirebaseCollections.USER.name).doc();

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
Future<void> addProfilePictureRef(File file, String pathToSave) async {
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


/// Retrieves the role of the current user from Firebase Firestore.
///
/// This function fetches the role of the current user from Firebase Firestore based on their UID.
/// The resulting role is used to determine whether the user is a "PROFESSIONAL" or a "USER".
///
/// Returns: A [Future] that completes with the [UserRole] of the current user.
Future<UserRole> getUserRoleRef() async {
  // Get the UID of the current user from FirebaseAuth.
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Initialize the role variable.
  String role = "";

  // Get a reference to the Firebase Firestore instance.
  await FirebaseFirestore.instance
      .collection(FirebaseCollections.USER.name)
      .where(UserModel.col_userId, isEqualTo: userId)
      .get()
      .then(
        (querySnapshot) {
      // Print a success message for debugging.
      print("Successfully completed");

      // Retrieve the role from the first document in the query results.
      var doc = querySnapshot.docs.first;
      role = doc.data()[UserModel.col_role];
    },
    onError: (e) => print("Error completing: $e"),
  );

  // Return the corresponding UserRole based on the retrieved role.
  switch (role) {
    case 'PROFESSIONAL':
      return UserRole.PROFESSIONAL;
    default:
      return UserRole.USER;
  }
}


/// Retrieves a list of users with specified roles from Firebase Firestore.
///
/// This function fetches a list of [UserModel] instances from Firebase Firestore
/// based on the roles specified, including "PROFESSIONAL" and "ADMIN". The resulting
/// list contains user details of professionals and administrators.
///
/// Returns: A [Future] that completes with a list of [UserModel] instances.
Future<List<UserModel>> getUsersFromFirebaseRef() async {
  // List to hold the fetched user models.
  List<UserModel> list = [];

  // Get a reference to the Firebase Firestore instance.
  var db = await FirebaseFirestore.instance;

  // Fetch users with specified roles from the Firestore collection.
  await db.collection(FirebaseCollections.USER.name)
      .where(UserModel.col_role, whereIn: [UserRole.PROFESSIONAL.name, UserRole.ADMIN.name])
      .get()
      .then(
        (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // Replace the role "ADMIN" with "PROFESSIONAL" for disguising purposes.
        Map<String, dynamic> data = docSnapshot.data();
        data[UserModel.col_role] = UserRole.PROFESSIONAL.name;

        // Add the fetched user details to the list.
        list.add(UserModel.fromJson(data));
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  // Return the list of fetched user models.
  return list;
}


/// Retrieves a list of users associated with specific shops from Firebase Firestore.
///
/// This function fetches a list of [UserModel] instances from Firebase Firestore,
/// based on the list of professionals associated with a specific shop. The resulting
/// list contains user details of professionals linked to the shop.
///
/// Parameters:
/// - [ref]: A [WidgetRef] used to access state data (e.g., professionals associated with a shop).
///
/// Returns: A [Future] that completes with a list of [UserModel] instances.
Future<List<UserModel>> getUsersFromShopsFromFirebaseRef(WidgetRef ref) async {
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
    onError: (e) => print("Error completing: $e"),
  );

  // Return the list of fetched user models.
  return list;
}
