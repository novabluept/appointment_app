
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/appointment_model.dart';

abstract class ChooseScheduleViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future addAppointment(AppointmentModel appointment);
  Future updateAppointment(String appointmentId,Map<String,dynamic> fields);
}