
import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data_ref/appointment_ref.dart';
import '../../data_ref/services_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/service_model.dart';
import '../../model/shop_model.dart';
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