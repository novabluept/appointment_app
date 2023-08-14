
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AppointmentsHistoryViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future cancelAppointment(String appointmentId,Map<String,dynamic> fields);
}