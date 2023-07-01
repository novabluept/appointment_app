
import 'package:flutter_riverpod/src/consumer.dart';

import 'package:riverpod/src/framework.dart';

import 'package:riverpod/src/state_controller.dart';

import '../../data_ref/services_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/service_model.dart';
import 'choose_service_view_model.dart';

class ChooseServiceViewModelImp implements ChooseServiceViewModel{

  @override
  Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebase(String userId,String shopId) async {
    return await getServicesByUserIdAndShopIdFromFirebaseRef(userId,shopId);
  }

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }


}