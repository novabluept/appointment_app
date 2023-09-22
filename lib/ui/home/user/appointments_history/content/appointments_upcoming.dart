
import 'dart:io';

import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui_items/my_modal_bottom_sheet.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
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
    super.build(context);
    return MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody());
  }

  Widget _bookedAppointmentListShimmer(){
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const MyAppointmentTile(
            type: MyAppointmentTileType.SHIMMER,
            hasButtons: true
        );
      },
    );
  }

  Widget _cancelAppointmentBottomSheet(BuildContext context,AppointmentModel appointment){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        MyLabel(
          type: MyLabelType.H4,
          fontWeight: MyLabel.BOLD,
          label: 'Cancel Appointment',
          color: red,
        ),
        SizedBox(height: 24.h),
        const MyLabel(
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
    );
  }

  _showCancelBottomSheet(AppointmentModel appointment){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return MyModalBottomSheet(
              type: MyModalBottomSheetType.GENERAL,
              content: _cancelAppointmentBottomSheet(context,appointment)
          );
        }
    );
  }

  _rescheduleAppointment(AppointmentModel appointment){
    AppointmentsHistoryModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 2);
    AppointmentsHistoryModelImp().setValue(isNavigationFromHomeProvider.notifier, ref, true);
    AppointmentsHistoryModelImp().setValue(appointmentFromAppointmentsHistoryProvider.notifier, ref, appointment);
    MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const MakeAppointmentScreen(), null);
  }

  _openSmsWithProfessionalPhone(AppointmentModel appointment) async {

    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: appointment.professionalPhone,
      queryParameters: <String, String>{
        'body': Uri.encodeComponent('A tua prima!').replaceAll('%20', ' '),
      },
    );

    if(await canLaunchUrl(smsLaunchUri)){
      await launchUrl(smsLaunchUri);
    }else{
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'This service is not available for this device.');
    }
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
          negativeButtonOnPressed: () => _showCancelBottomSheet(appointment),
          positiveButtonOnPressed: () => _rescheduleAppointment(appointment),
          sendSms: () => _openSmsWithProfessionalPhone(appointment),
        );
      },
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: StreamBuilder(
        stream: getAppointmentsByUserRef(AppointmentStatus.BOOKED),
        builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _bookedAppointmentListShimmer();
          } else if (snapshot.hasError) {
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments booked at the moment.',);
          } else {
            List<AppointmentModel> list = snapshot.data!;
            return _bookedAppointmentList(list);
          }
        }
      ),
    );
  }

}