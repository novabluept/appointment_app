
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/appointment_model.dart';
import '../../utils/enums.dart';

abstract class AppointmentsHistoryViewModel{

  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future cancelAppointment(String appointmentId,Map<String,dynamic> fields);
}