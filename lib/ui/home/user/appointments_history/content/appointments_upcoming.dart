
import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_history.dart';
import 'package:appointment_app_v2/ui_items/my_divider.dart';
import 'package:appointment_app_v2/ui_items/my_modal_bottom_sheet.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../view_model/appointments_history/appointments_history_view_model_imp.dart';
import '../../home/make_appointment/make_appointment_screen.dart';

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

  Widget _bookedAppointmentListShimmer(){
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
  }

  Widget _cancelAppointment(BuildContext context,AppointmentModel appointment){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyLabel(
            type: MyLabelType.H4,
            fontWeight: MyLabel.BOLD,
            label: 'Cancel Appointment',
            color: red,
          ),
          SizedBox(height: 24.h),
          MyLabel(
            type: MyLabelType.BODY_XLARGE,
            fontWeight: MyLabel.MEDIUM,
            label: 'Are you sure you want to cancel your appointment?',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Flexible(
                child: MyButton(
                  type: MyButtonType.FILLED,
                  labelColor: blue,
                  backgroundColor: lightBlue,
                  foregroundColor: blue,
                  label: 'Back',
                  onPressed: (){Navigator.of(context).pop();}
                )
              ),
              SizedBox(width: 16.w),
              Flexible(
                child: MyButton(
                  type: MyButtonType.FILLED,
                  labelColor: light1,
                  backgroundColor: blue,
                  foregroundColor: light1,
                  label: 'Yes, Cancel',
                  onPressed: () async {
                    Map<String, dynamic> fields = {AppointmentModel.col_status : AppointmentStatus.CANCELLED.name};
                    await AppointmentsHistoryModelImp().cancelAppointment(appointment.appointmentId,fields);
                    Navigator.of(context).pop();
                  }
                )
              ),
            ],
          ),
          SizedBox(height: 24.h,),
        ],
      ),
    );
  }

  Widget _bookedAppointmentList(List<AppointmentModel> list){
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
                  return MyModalBottomSheet(
                    type: MyModalBottomSheetType.GENERAL,
                    height: 300,
                    content: _cancelAppointment(context,appointment)
                  );
                }
            );
          },
          positiveButtonOnPressed: (){
            AppointmentsHistoryModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 2);
            AppointmentsHistoryModelImp().setValue(isNavigationFromHomeProvider.notifier, ref, true);
            AppointmentsHistoryModelImp().setValue(appointmentFromAppointmentsHistoryProvider.notifier, ref, appointment);

            pushNewScreen(
              context,
              screen: ChooseScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        );
      },
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: StreamBuilder(
        stream: getUserAppointmentsRef(AppointmentStatus.BOOKED),
        builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _bookedAppointmentListShimmer();
          } else if (snapshot.hasError) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments booked at the moment.',);
          } else {
            List<AppointmentModel> list = snapshot.data!;
            return _bookedAppointmentList(list);
          }
        }
      ),
    );
  }

}