
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_service.dart';
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

import '../../../../../state_management/state.dart';
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

  TextStyle titleStyle = TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.SEMI_BOLD,fontSize: 18.sp);
  TextStyle calendarStyle = TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp);
  TextStyle selectedDayStyle = TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.MEDIUM,fontSize: 14.sp,color: light1);
  TextStyle daysOfWeekStyle = TextStyle(fontFamily: 'Urbanist',fontWeight: MyLabel.BOLD,fontSize: 12.sp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey50,
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  _onDaySelected(DateTime day,DateTime focusedDay){
    if(DateTime.utc(day.year,day.month,day.day).compareTo(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day)) >= 0){
      ChooseScheduleViewModelImp().setValue(selectedDayProvider.notifier, ref, day);
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Não é possivel efetuar marcações num dia do passado');
    }
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            MyLabel(
              type: MyLabelType.H5,
              fontWeight: MyLabel.BOLD,
              label: 'Select date',
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 350.h,
              child: Container(
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(16.0).r,
                ),
                child: TableCalendar(
                  shouldFillViewport: true,
                  focusedDay: ref.watch(selectedDayProvider),
                  selectedDayPredicate: (day) => isSameDay(day,ref.watch(selectedDayProvider)),
                  onDaySelected: _onDaySelected,
                  firstDay: DateTime.utc(DateTime.now().year,DateTime.now().month,1),
                  lastDay: DateTime.utc(DateTime.now().year + 1,12,1),
                  headerStyle: HeaderStyle(
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    formatButtonVisible: false,
                    headerMargin: EdgeInsets.only(left: 12.w,bottom: 12.h),
                    titleTextStyle: titleStyle,
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: daysOfWeekStyle,
                      weekdayStyle: daysOfWeekStyle
                  ),
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
                    selectedDecoration: BoxDecoration(
                      color: blue,
                      shape: BoxShape.circle,
                    ),
                    disabledTextStyle: calendarStyle,
                    outsideTextStyle: calendarStyle,
                    weekendTextStyle: calendarStyle,
                    defaultTextStyle: calendarStyle,
                    todayTextStyle: calendarStyle,
                    selectedTextStyle: selectedDayStyle
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            MyLabel(
              type: MyLabelType.H5,
              fontWeight: MyLabel.BOLD,
              label: 'Select hour',
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 228.h,
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 3,
                children: List.generate(12, (index) {
                  return Container(
                    color: index % 2 == 0 ? Colors.red : Colors.blue,
                    width: 10.w,
                    height: 10.h,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

}