
import 'dart:typed_data';

import 'package:appointment_app_v2/model/appointment_model.dart';

import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/utils/method_helper.dart';

import '../../data_ref/appointment_ref.dart';
import '../../data_ref/users_ref.dart';
import 'appointments_history_view_model.dart';

class AppointmentsHistoryModelImp implements AppointmentsHistoryViewModel{

  @override
  Future<List<AppointmentModel>> getUserAppointments(AppointmentStatus status) async {
    List<AppointmentModel> list = await getUserAppointmentsRef(status);

    await Future.forEach(list,(element) async {
      Uint8List? image = await MethodHelper.getImageAndCovertToUint8list(element.professionalImagePath);
      image != null ? element.professionalImageUint8list = image : element.professionalImageUint8list = null;
    });

    return list;
  }

}