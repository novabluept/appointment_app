

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_model.dart';

abstract class ChooseProfessionalViewModel{

  void setCurrentUser(AlwaysAliveRefreshable<StateController<UserModel>> notifier,WidgetRef ref,UserModel value);
  Future<Uint8List?> getImageAndCovertToUint8list(String path);
  Future<List<UserModel>> getUsersByShopFromFirebase(WidgetRef ref);

}