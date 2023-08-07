
import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_history.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../view_model/appointments_history/appointments_history_view_model_imp.dart';

class AppointmentsUpcoming extends ConsumerStatefulWidget {
  const AppointmentsUpcoming({Key? key}): super(key: key);

  @override
  AppointmentsUpcomingState createState() => AppointmentsUpcomingState();
}

class AppointmentsUpcomingState extends ConsumerState<AppointmentsUpcoming> with AutomaticKeepAliveClientMixin {

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
        stream: getUserAppointmentsRef(AppointmentStatus.BOOKED),
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
                    hasButtons: true
                );
              },
            );
          } else if (snapshot.hasError) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments booked at the moment.',);
          } else {

            List<AppointmentModel> list = snapshot.data!;

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemCount: list.length,
              itemBuilder: (context, index) {

                AppointmentModel appointment = list[index];

                return MyAppointmentTile(
                  type: MyAppointmentTileType.BOOKED,
                  index: index,
                  appointment: appointment,
                  hasButtons: true,
                  negativeButtonOnPressed: () async{
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          decoration: BoxDecoration(
                            color: light1,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40).r,topRight: Radius.circular(48).r),
                          ),
                          height: 391.h,
                          child: Column(
                            children: [
                              SizedBox(height: 32.h,),
                              MyLabel(
                                type: MyLabelType.H4,
                                fontWeight: MyLabel.BOLD,
                                label: 'Cancel Appointment',
                                color: red,
                              ),
                              MyLabel(
                                type: MyLabelType.BODY_XLARGE,
                                fontWeight: MyLabel.MEDIUM,
                                label: 'Are you sure you want to cancel your appointment?',
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                children: [
                                  Flexible(child: MyButton(type: MyButtonType.OUTLINED, label: 'Cancel Appointment',height: 32,verticalPadding: 6,onPressed: (){})),
                                  SizedBox(width: 16.w),
                                  Flexible(child: MyButton(type: MyButtonType.FILLED, label: 'Reschedule',height: 32,verticalPadding: 6,onPressed: (){}))
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                  positiveButtonOnPressed: (){

                  },
                );
              },
            );
          }
        }
      ),
    );
  }

}