
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/state_controller.dart';
import '../../data_ref/appointment_ref.dart';
import '../../model/appointment_model.dart';
import 'choose_schedule_view_model.dart';

class ChooseScheduleViewModelImp implements ChooseScheduleViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

  @override
  Future addAppointment(AppointmentModel appointment) async{
    await addAppointmentRef(appointment);
  }

  @override
  Future updateAppointment(String appointmentId, Map<String, dynamic> fields) async{
    await updateAppointmentRef(appointmentId, fields);
  }
}