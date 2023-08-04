
import '../../model/appointment_model.dart';
import '../../utils/enums.dart';

abstract class AppointmentsHistoryViewModel{

  Future<List<AppointmentModel>> getUserAppointments(AppointmentStatus status);
}