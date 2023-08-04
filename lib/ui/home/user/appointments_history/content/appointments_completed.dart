
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../../model/appointment_model.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../view_model/appointments_history/appointments_history_view_model_imp.dart';

class AppointmentsCompleted extends ConsumerStatefulWidget {
  const AppointmentsCompleted({Key? key}): super(key: key);

  @override
  AppointmentsCompletedState createState() => AppointmentsCompletedState();
}

class AppointmentsCompletedState extends ConsumerState<AppointmentsCompleted> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody());
  }

  Future<List<AppointmentModel>> _getUserAppointmentsFromFirebase(AppointmentStatus appointmentStatus){
    return AppointmentsHistoryModelImp().getUserAppointments(appointmentStatus);
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FutureBuilder(
          future: _getUserAppointmentsFromFirebase(AppointmentStatus.COMPLETED),
          builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return MyAppointmentTile(
                    type: MyAppointmentTileType.SHIMMER,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return MyException(type: MyExceptionType.NO_DATA,imagePath: 'images/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return MyException(type: MyExceptionType.NO_DATA,imagePath: 'images/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments completed at the moment.',);
            } else {

              List<AppointmentModel> list = snapshot.data!;

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: list.length,
                itemBuilder: (context, index) {

                  AppointmentModel appointment = list[index];

                  return MyAppointmentTile(
                      type: MyAppointmentTileType.COMPLETED,
                      index: index,
                      appointment: appointment,
                  );
                },
              );
            }
          }
      ),
    );
  }

}