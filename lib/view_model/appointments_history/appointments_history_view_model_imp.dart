
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data_ref/appointment_ref.dart';
import 'appointments_history_view_model.dart';

class AppointmentsHistoryModelImp implements AppointmentsHistoryViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

  @override
  Future cancelAppointment(String appointmentId,Map<String,dynamic> fields) {
    return updateAppointmentRef(appointmentId,fields);
  }
}