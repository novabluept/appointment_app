
import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ChooseShop
final currentShopProvider = StateProvider<ShopModel>((ref) => ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',professionals: []));
final currentShopIndexProvider = StateProvider<int>((ref) => 0);

