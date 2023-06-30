

import '../../model/service_model.dart';

abstract class ChooseServiceViewModel{

  Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebase(String userId,String shopId);

}