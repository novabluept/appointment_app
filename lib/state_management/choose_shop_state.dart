

import 'package:appointment_app_v2/model/service_model.dart';
import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';

/// ChooseShop
final currentShopProvider = StateProvider<ShopModel>((ref) => ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',professionals: []));
final currentShopIndexProvider = StateProvider<int>((ref) => 0);

