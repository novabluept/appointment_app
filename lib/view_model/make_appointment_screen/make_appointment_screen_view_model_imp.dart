
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/src/consumer.dart';

import 'package:riverpod/src/framework.dart';

import 'package:riverpod/src/state_controller.dart';

import '../../data_ref/shops_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/shop_model.dart';
import '../../model/user_model.dart';
import '../../state_management/state.dart';
import 'make_appointment_screen_view_model.dart';

class MakeAppointmentScreenViewModelImp implements MakeAppointmentScreenViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

}