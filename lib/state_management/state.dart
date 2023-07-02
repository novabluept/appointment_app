

import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';

/// Fill Profile
final imagePathProvider = StateProvider<String>((ref) => PROFILE_IMAGE_DIRECTORY);
final firstNameProvider = StateProvider<String>((ref) => '');
final lastNameProvider = StateProvider<String>((ref) => '');
final dateOfBirthProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');


/// ChooseShop
final currentShopProvider = StateProvider<ShopModel>((ref) => ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',users: []));
final currentShopIndexProvider = StateProvider<int>((ref) => 0);

/// Make appointments
final indexMakeAppointmentProvider = StateProvider<int>((ref) => 0);

final currentUserProvider = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));
final currentUserIndexProvider = StateProvider<int>((ref) => -1);

final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

