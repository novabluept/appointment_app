
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/state_controller.dart';
import 'make_appointment_screen_view_model.dart';

class MakeAppointmentScreenViewModelImp implements MakeAppointmentScreenViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }
}