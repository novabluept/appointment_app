

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/service_model.dart';

abstract class ChooseServiceViewModel{

  Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebase(String userId,String shopId);
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);


}