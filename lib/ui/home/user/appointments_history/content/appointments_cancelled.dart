
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../model/appointment_model.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../view_model/appointments_history/appointments_history_view_model_imp.dart';

class AppointmentsCancelled extends ConsumerStatefulWidget {
  const AppointmentsCancelled({Key? key}): super(key: key);

  @override
  AppointmentsHistoryState createState() => AppointmentsHistoryState();
}

class AppointmentsHistoryState extends ConsumerState<AppointmentsCancelled> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody());
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: StreamBuilder(
          stream: getUserAppointmentsRef(AppointmentStatus.CANCELLED),
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
              return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments cancelled at the moment.',);
            } else {

              List<AppointmentModel> list = snapshot.data!;

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: list.length,
                itemBuilder: (context, index) {

                  AppointmentModel appointment = list[index];

                  return MyAppointmentTile(
                      type: MyAppointmentTileType.CANCELLED,
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