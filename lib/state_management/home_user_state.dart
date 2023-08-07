

import 'package:appointment_app_v2/model/shop_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listShops = StateProvider<List<ShopModel>>((ref) => []);
