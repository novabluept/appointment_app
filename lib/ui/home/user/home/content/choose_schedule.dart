
import 'dart:async';
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_service.dart';
import 'package:appointment_app_v2/ui_items/my_choose_schedule_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../model/appointment_model.dart';
import '../../../../../state_management/appointments_state.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
import '../../../../../utils/validators.dart';
import '../../../../../view_model/choose_schedule/choose_schedule_view_model_imp.dart';

class ChooseSchedule extends ConsumerStatefulWidget {
  const ChooseSchedule({Key? key}): super(key: key);

  @override
  ChooseScheduleState createState() => ChooseScheduleState();
}

class ChooseScheduleState extends ConsumerState<ChooseSchedule> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey50,
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  _isDisabledDayOfPast(DateTime day){
    if(DateTime.utc(day.year,day.month,day.day).compareTo(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day)) < 0){
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Não é possivel efetuar marcações num dia do passado');
    }
  }

  _isDayOfPast(DateTime day,DateTime focusedDay){
    if(DateTime.utc(day.year,day.month,day.day).compareTo(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day)) >= 0){
      return false;
    }
    return true;
  }

  _onDaySelected(DateTime day,DateTime focusedDay){
    if(!_isDayOfPast(day,focusedDay)){
      ChooseScheduleViewModelImp().setValue(selectedDayProvider.notifier, ref, day);
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Não é possivel efetuar marcações num dia do passado');
    }
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          MyLabel(
            type: MyLabelType.H5,
            fontWeight: MyLabel.BOLD,
            label: 'Select date',
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            height: 400.h,
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(24.0).r,
            ),
            child: TableCalendar(
              sixWeekMonthsEnforced: true,
              shouldFillViewport: true,
              startingDayOfWeek: StartingDayOfWeek.monday,
              firstDay: DateTime.utc(DateTime.now().year,DateTime.now().month,1),
              lastDay: DateTime.utc(DateTime.now().year + 1,12,1),
              focusedDay: ref.watch(selectedDayProvider),
              selectedDayPredicate: (day) => isSameDay(day,ref.watch(selectedDayProvider)),
              onDaySelected: _onDaySelected,
              onDisabledDayTapped: _isDisabledDayOfPast,
              headerStyle: HeaderStyle(
                leftChevronVisible: false,
                rightChevronVisible: false,
                formatButtonVisible: false,
                headerMargin: EdgeInsets.only(left: 16.w,bottom: 12.h),
                titleTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.SEMI_BOLD,fontSize: 18.sp),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.SEMI_BOLD,fontSize: 12.sp),
                  weekdayStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.SEMI_BOLD,fontSize: 12.sp)
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                selectedDecoration: BoxDecoration(
                  color: blue,
                  shape: BoxShape.circle,
                ),
                disabledTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp,color: grey400),
                outsideTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp,color: grey400),
                weekendTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp),
                defaultTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp),
                todayTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp),
                selectedTextStyle: TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp,color: light1),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          MyLabel(
            type: MyLabelType.H5,
            fontWeight: MyLabel.BOLD,
            label: 'Select hour',
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 180.h,
            child: StreamBuilder(
              stream: getAppointmentByProfessionalShopStatusDateFromFirebaseRef("pcCs5lax0sgIc5d6EJ0QQIbidUn1","vsvWcBONOYI4ArQ3tZL2","BOOKED","08-09-2023"),
              builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text('waiting');
                }else if(snapshot.hasError){
                  return Text('has error');
                }else{

                  List<AppointmentModel> list = snapshot.data!;
                  list.sort((a, b) => a.startDate.compareTo(b.startDate));

                  return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: (120.0.w / 45.h),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 1.w),
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 16.h,
                    children: List.generate(list.length, (index) {

                      AppointmentModel appointment = list[index];

                      return MyChooseScheduleTile(
                          type: MyChooseScheduleTileType.GENERAL,
                          index: index,
                          appointment: appointment,
                          onTap: (){
                            ChooseScheduleViewModelImp().setValue(currentAppointmentProvider.notifier, ref, appointment);
                            ChooseScheduleViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, index);
                            print('currentScheduleIndexProvider -> ' + ref.read(currentAppointmentIndexProvider).toString());
                          }
                      );
                    }),
                  );
                }
              },
            )
          ),
          SizedBox(height: 16.h),
          MyButton(type: MyButtonType.FILLED, label: 'Continue',onPressed: (){}),
          SizedBox(height: 24.h,)
        ],
      ),
    );
  }

}