

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/shop_model.dart';

abstract class HomeUserViewModel{

  void setCurrentShop(AlwaysAliveRefreshable<StateController<ShopModel>> notifier,WidgetRef ref,ShopModel value);
  Future<List<ShopModel>> getShopsFromFirebase();

}