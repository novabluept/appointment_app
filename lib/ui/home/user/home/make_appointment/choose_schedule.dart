
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:appointment_app_v2/model/user_model.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui_items/my_choose_schedule_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../../../../model/service_model.dart';
import '../../../../../model/shop_model.dart';
import '../../../../../model/time_slot_model.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_exception.dart';
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

  StreamSubscription<List<AppointmentModel>>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to the stream when the widget is initialized
    _streamSubscription = getAppointmentByProfessionalShopStatusDateFromFirebaseRef(
      ref.read(currentProfessionalProvider).userId,
      ref.read(currentShopProvider).shopId,
      AppointmentStatus.BOOKED,
      DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(ref.read(selectedDayProvider)),
    ).listen((List<AppointmentModel> data) {
      // This block will be called when new data is available on the stream.
      // You can put your code here to update currentSlotIndexProvider with -1.
      ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
    });
  }

  @override
  void dispose() {
    // Don't forget to cancel the subscription when the widget is disposed
    _streamSubscription?.cancel();
    super.dispose();
  }

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
      ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
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
              stream: getAppointmentByProfessionalShopStatusDateFromFirebaseRef(
                  ref.read(currentProfessionalProvider).userId,
                  ref.read(currentShopProvider).shopId,
                  AppointmentStatus.BOOKED,
                  DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(ref.read(selectedDayProvider))),
              builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text('waiting');
                }else if(snapshot.hasError){
                  return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
                }else{

                  List<TimeSlotModel> list = _getAvailableSlots(ref,snapshot.data!,ref.read(currentServiceProvider).duration);

                  return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: (120.0.w / 45.h),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 1.w),
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 16.h,
                    children: List.generate(list.length, (index) {

                      TimeSlotModel slot = list[index];

                      return MyChooseScheduleTile(
                          type: MyChooseScheduleTileType.GENERAL,
                          index: index,
                          timeSlot: slot,
                          onTap: (){
                            if(index == ref.read(currentSlotIndexProvider)) {
                              ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
                            }else{
                              ChooseScheduleViewModelImp().setValue(currentSlotProvider.notifier, ref, slot);
                              ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, index);
                            }
                          }
                      );
                    }),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 16.h),
          MyButton(
            type: MyButtonType.FILLED,
            label: 'Continue',
            onPressed: (){
              _saveAppointment(context,ref);
            }
          ),
          SizedBox(height: 24.h,)
        ],
      ),
    );
  }

}

_saveAppointment(BuildContext context,WidgetRef ref){
  if(ref.read(currentSlotIndexProvider) == -1){
    MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Terá de selecionar um horario para continuar');
  }else{

    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    ServiceModel service = ref.read(currentServiceProvider);
    TimeSlotModel slot = ref.read(currentSlotProvider);
    UserModel professional = ref.read(currentProfessionalProvider);
    ShopModel shop = ref.read(currentShopProvider);

    AppointmentModel appointment = AppointmentModel(
        shopId: shop.shopId,
        professionalId: professional.userId,
        clientId: user.uid,
        serviceId: service.serviceId,
        professionalPhone: professional.phone,
        professionalFirstName: professional.firstname,
        professionalLastName: professional.lastname,
        professionalImagePath: professional.imagePath,
        startDate: MethodHelper.convertTimeOfDayToTimestamp(TimeOfDay(hour: slot.startTime.hour, minute: slot.startTime.minute)),
        endDate: MethodHelper.convertTimeOfDayToTimestamp(TimeOfDay(hour: slot.endTime.hour, minute: slot.endTime.minute)),
        date: DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(ref.read(selectedDayProvider)),
        serviceName: service.name,
        servicePrice: service.price,
        serviceDuration: service.duration,
        status: AppointmentStatus.BOOKED.name
    );

    ChooseScheduleViewModelImp().addAppointment(appointment);

    // Create a Completer to manage the timer completion
    Completer<void> completer = Completer<void>();

    Timer(Duration(milliseconds: TRANSITION_DURATION), () {
      Navigator.of(context).pop();
      completer.complete();
    });

    completer.future.then((_) {
      Timer(Duration(milliseconds: TRANSITION_DURATION), () {
        MethodHelper.cleanAppointmentsVariables(ref);
      });
    });


  }
}

List<TimeSlotModel> _generateSlotsByRangeAndInterval(TimeOfDay startTime,TimeOfDay endTime,int interval){

  List<TimeSlotModel> timeSlots = [];

  TimeOfDay currentTime = startTime;

  while (currentTime.hour < endTime.hour) {

    TimeOfDay nextTime;

    if(currentTime.minute == (60 - INTERVAL_SLOT)){
      nextTime = TimeOfDay(hour: currentTime.hour + 1, minute: 0);
    }else{
      nextTime = TimeOfDay(hour: currentTime.hour, minute: currentTime.minute + interval);
    }

    TimeSlotModel slotToAdd = TimeSlotModel(
      startTime: currentTime,
      endTime: nextTime,
    );

    timeSlots.add(slotToAdd);

    currentTime = nextTime;
  }

  return timeSlots;
}

bool _isSlotAvailable(TimeSlotModel slot,TimeOfDay appointmentStartTime,TimeOfDay appointmentEndTime){
  if(MethodHelper.timeOfDayToDouble(slot.startTime) >= MethodHelper.timeOfDayToDouble(appointmentStartTime)
      && MethodHelper.timeOfDayToDouble(slot.endTime) <= MethodHelper.timeOfDayToDouble(appointmentEndTime) ){
    return true;
  }
  return false;
}

_checkAvailableAndUnavailableSlots(List<AppointmentModel> appointments,List<TimeSlotModel> slots,TimeOfDay slotStartTime,TimeOfDay slotEndTime){
  for(var appointment in appointments){

    TimeOfDay appointmentStartTime = MethodHelper.convertTimestampToTimeOfDay(appointment.startDate);
    TimeOfDay appointmentEndTime = MethodHelper.convertTimestampToTimeOfDay(appointment.endDate);

    /// If the appointment is in the interval of the time slot
    if(MethodHelper.timeOfDayToDouble(appointmentStartTime) >= MethodHelper.timeOfDayToDouble(slotStartTime)
        && MethodHelper.timeOfDayToDouble(appointmentEndTime) <= MethodHelper.timeOfDayToDouble(slotEndTime) ){

      for(var slot in slots){
        _isSlotAvailable(slot,appointmentStartTime,appointmentEndTime) ? slot.hasAppointment = true : null;
      }

    }

  }
}

_checkPossibleSlotsForServiceDuration(List<TimeSlotModel> slots,List<TimeSlotModel> possibleSlots,double numServiceInstances,int serviceDuration){
  for(int i = 0; i < slots.length; i++){

    if(!slots[i].hasAppointment!){

      int countNumServiceInstances = 0;

      for(int j = i; j < slots.length; j++){

        if(!slots[i + countNumServiceInstances].hasAppointment!){

          countNumServiceInstances++;

          if(countNumServiceInstances == numServiceInstances){

            TimeOfDay endTime;
            if(slots[i].startTime.minute + serviceDuration >= 60){
              endTime = TimeOfDay(hour: slots[i].startTime.hour + 1, minute: slots[i].startTime.minute + serviceDuration -  60);
            }else{
              endTime = TimeOfDay(hour: slots[i].startTime.hour, minute: slots[i].startTime.minute + serviceDuration);
            }
            possibleSlots.add(TimeSlotModel(startTime: slots[i].startTime, endTime: endTime));
            break;
          }

        }

      }
    }
  }
  //print(possibleSlots);
}

double _calculateServiceInstances(int serviceDuration){
  return serviceDuration / INTERVAL_SLOT;
}

List<TimeSlotModel> _getAvailableSlots(WidgetRef ref,List<AppointmentModel> listBookedAppointments, int serviceDuration) {

  List<TimeSlotModel> listAvailableAppointments = [];
  double numServiceInstances = _calculateServiceInstances(serviceDuration);

  /// Define the list of time slots for the day (start times and end times)
  List<TimeSlotModel> timeSlots = [
    TimeSlotModel(startTime: TimeOfDay(hour: 9, minute: 0),endTime: TimeOfDay(hour: 13, minute: 0)),
    TimeSlotModel(startTime: TimeOfDay(hour: 14, minute: 0),endTime: TimeOfDay(hour: 18, minute: 0)),
  ];

  /// Define the booked appointments and sort the booked appointments by their start date and time
  List<AppointmentModel> appointments = listBookedAppointments;
  appointments.sort((a, b) => a.startDate.compareTo(b.startDate));

  /// Iterate through the time slots
  for (TimeSlotModel slot in timeSlots) {

    List<TimeSlotModel> possibleSlots = [];

    TimeOfDay slotStartTime = slot.startTime;
    TimeOfDay slotEndTime = slot.endTime;

    List<TimeSlotModel> slots = _generateSlotsByRangeAndInterval(slotStartTime,slotEndTime,INTERVAL_SLOT);

    _checkAvailableAndUnavailableSlots(appointments,slots,slotStartTime,slotEndTime);

    _checkPossibleSlotsForServiceDuration(slots,possibleSlots,numServiceInstances,serviceDuration);

    listAvailableAppointments.addAll(possibleSlots);
  }


  return listAvailableAppointments;
}







