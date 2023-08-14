
import 'package:flutter_riverpod/src/consumer.dart';

import 'package:riverpod/src/framework.dart';

import 'package:riverpod/src/state_controller.dart';

import '../../data_ref/users_ref.dart';
import '../../model/user_model.dart';
import 'persistent_bottom_navbar_view_model.dart';

class PersistentBottomNavbarViewModelImp implements PersistentBottomNavbarViewModel{

  @override
  Future<UserModel> getUser() {
    return getUserRef();
  }

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }
}