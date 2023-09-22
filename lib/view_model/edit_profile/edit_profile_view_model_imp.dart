
import 'package:appointment_app_v2/data_ref/users_ref.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/state_controller.dart';
import 'edit_profile_view_model.dart';

class EditProfileModelImp implements EditProfileViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

  @override
  Future updateUser(Map<String, dynamic> fields) async{
    return await updateUserRef(fields);
  }


}