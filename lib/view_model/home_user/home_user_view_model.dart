

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/shop_model.dart';

abstract class HomeUserViewModel{

  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future<List<ShopModel>> getShopsFromFirebase();

}