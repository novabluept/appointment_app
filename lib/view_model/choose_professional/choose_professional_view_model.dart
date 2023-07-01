

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_model.dart';

abstract class ChooseProfessionalViewModel{

  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future<Uint8List?> getImageAndCovertToUint8list(String path);
  Future<List<UserModel>> getUsersByShopFromFirebase(WidgetRef ref);
  

}