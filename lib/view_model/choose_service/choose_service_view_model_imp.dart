
import '../../data_ref/services_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/service_model.dart';
import 'choose_service_view_model.dart';

class ChooseServiceViewModelImp implements ChooseServiceViewModel{

  @override
  Future<List<ServiceModel>> getServicesByUserIdAndShopIdFromFirebase(String userId,String shopId) async {
    return await getServicesByUserIdAndShopIdFromFirebaseRef(userId,shopId);
  }

}