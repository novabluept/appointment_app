

import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';

/// Fill Profile
final imagePathProvider = StateProvider<String>((ref) => PROFILE_IMAGE_DIRECTORY);
final firstNameProvider = StateProvider<String>((ref) => '');
final lastNameProvider = StateProvider<String>((ref) => '');
final dateOfBirthProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');


/// Home
final currentShop = StateProvider<ShopModel>((ref) => ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',users: []));
final currentShopIndex = StateProvider<int>((ref) => 0);

/// Appointments
final currentUser = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));

