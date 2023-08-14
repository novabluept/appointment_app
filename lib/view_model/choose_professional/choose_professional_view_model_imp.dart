
import 'dart:typed_data';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/state_controller.dart';
import '../../data_ref/users_ref.dart';
import '../../model/user_model.dart';
import '../../utils/method_helper.dart';
import 'choose_professional_view_model.dart';

class ChooseProfessionalViewModelImp implements ChooseProfessionalViewModel{

  @override
  Future<List<UserModel>> getProfessionalUsersByShop(WidgetRef ref) async {

    List<UserModel> list = await getProfessionalUsersByShopRef(ref);

    await Future.forEach(list,(element) async {
      Uint8List? image = await MethodHelper.getImageAndConvertToUint8List(element.imagePath);
      image != null ? element.imageUnit8list = image : element.imageUnit8list = null;
    });

    return list;
  }

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }
}