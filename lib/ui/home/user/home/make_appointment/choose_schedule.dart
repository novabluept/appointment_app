
import 'dart:async';
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:appointment_app_v2/ui_items/my_choose_schedule_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../model/appointment_model.dart';
import '../../../../../model/service_model.dart';
import '../../../../../model/shop_model.dart';
import '../../../../../model/time_slot_model.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
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
    bool isNavigationFromHome = ref.read(isNavigationFromHomeProvider);
    AppointmentModel appointment = ref.read(appointmentFromAppointmentsHistoryProvider);

    _streamSubscription = getAppointmentsByProfessionalShopStatusDateRef(
      isNavigationFromHome ? appointment.professionalId : ref.read(currentProfessionalProvider).userId,
      isNavigationFromHome ? appointment.shopId : ref.read(currentShopProvider).shopId,
      AppointmentStatus.BOOKED,
      DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(ref.read(selectedDayProvider)),
    ).listen((List<AppointmentModel> data) {
      ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
    });
  }

  @override
  void dispose() {
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

  /// Checks if a given day is in the past and shows a warning if true.
  ///
  /// This function takes a [day] parameter of type [DateTime] and checks if it represents a date in the past
  /// by comparing it with the current date. If the provided day is in the past, a warning dialog is shown
  /// using [MethodHelper.showDialogAlert()] to indicate that making appointments on past days is not allowed.
  ///
  /// Parameters:
  ///   - day: The [DateTime] representing the day to be checked.
  ///
  /// Returns: void
  void _isDisabledDayFromPast(DateTime day) {
    // Compare the provided day with the current date.
    if (DateTime.utc(day.year, day.month, day.day).compareTo(DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day)) < 0) {
      // Show a warning dialog indicating that appointments on past days are not allowed.
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'It\'s not possible to make appointments on a day from the past.');
    }
  }

  /// Checks if a given day is in the past relative to a focused day.
  ///
  /// This function takes a [day] parameter of type [DateTime] and a [focusedDay] parameter of type [DateTime],
  /// and checks if the provided day is in the past relative to the focused day by comparing their dates.
  ///
  /// Parameters:
  ///   - day: The [DateTime] representing the day to be checked.
  ///   - focusedDay: The [DateTime] representing the focused day for comparison.
  ///
  /// Returns: A [bool] indicating whether the provided day is in the past relative to the focused day.
  bool _isDayFromPast(DateTime day, DateTime focusedDay) {
    // Compare the provided day with the current date.
    if (DateTime.utc(day.year, day.month, day.day).compareTo(DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day)) >= 0) {
      return false; // The day is not in the past relative to the focused day.
    }
    return true; // The day is in the past relative to the focused day.
  }

  /// Handles the selection of a day in the calendar and takes appropriate actions.
  ///
  /// This function takes a [day] parameter of type [DateTime] and a [focusedDay] parameter of type [DateTime],
  /// and checks if the provided day is not in the past relative to the focused day using [_isDayFromPast()].
  /// If the day is not in the past, it sets the [currentSlotIndexProvider] and [selectedDayProvider] state variables
  /// using [ChooseScheduleViewModelImp().setValue()], allowing further interaction with the selected day.
  /// If the day is in the past, it shows a warning dialog indicating that making appointments on past days is not allowed.
  ///
  /// Parameters:
  ///   - day: The [DateTime] representing the selected day.
  ///   - focusedDay: The [DateTime] representing the focused day for comparison.
  ///
  /// Returns: void
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    if (!_isDayFromPast(day, focusedDay)) {
      // Set the current slot index to -1 and the selected day to the chosen day.
      ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
      ChooseScheduleViewModelImp().setValue(selectedDayProvider.notifier, ref, day);
    } else {
      // Show a warning dialog indicating that appointments on past days are not allowed.
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Não é possível efetuar marcações em um dia do passado.');
    }
  }

  Widget mobileBody(){
    bool isNavigationFromHome = ref.read(isNavigationFromHomeProvider);
    AppointmentModel appointment = ref.read(appointmentFromAppointmentsHistoryProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          const MyLabel(
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
              onDisabledDayTapped: _isDisabledDayFromPast,
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
          const MyLabel(
            type: MyLabelType.H5,
            fontWeight: MyLabel.BOLD,
            label: 'Select hour',
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 180.h,
            child: StreamBuilder(
              stream: getAppointmentsByProfessionalShopStatusDateRef(
                  isNavigationFromHome ? appointment.professionalId : ref.read(currentProfessionalProvider).userId,
                  isNavigationFromHome ? appointment.shopId : ref.read(currentShopProvider).shopId,
                  AppointmentStatus.BOOKED,
                  DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(ref.read(selectedDayProvider))),
              builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Text('waiting');
                }else if(snapshot.hasError){
                  return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
                }else{
                  List<TimeSlotModel> list = _getAvailableSlots(ref,snapshot.data!,isNavigationFromHome ? appointment.serviceDuration : ref.read(currentServiceProvider).duration);
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
            labelColor: light1,
            backgroundColor: blue,
            foregroundColor: light1,
            label: 'Continue',
            onPressed: ()=> _saveAppointment(context,ref,isNavigationFromHome)
          ),
          SizedBox(height: 24.h,)
        ],
      ),
    );
  }

}

/// Adds a new appointment to the schedule and updates the view model.
///
/// This function takes a [context] of type [BuildContext], a [ref] of type [WidgetRef], [startDate] and [endDate] of type [Timestamp],
/// and a [date] of type [String]. It constructs an [AppointmentModel] based on the provided data,
/// including the current user, selected service, professional, and shop information.
/// The constructed appointment is then added to the schedule using [ChooseScheduleViewModelImp().addAppointment()].
///
/// Parameters:
///   - context: The [BuildContext] to access navigation and show dialogs.
///   - ref: The [WidgetRef] to access state and view model functions.
///   - startDate: The start date and time of the appointment.
///   - endDate: The end date and time of the appointment.
///   - date: The date of the appointment in string format.
///
/// Returns: void
void _addNewAppointment(BuildContext context, WidgetRef ref, Timestamp startDate, Timestamp endDate, String date) {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser!;
  ServiceModel service = ref.read(currentServiceProvider);
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
    startDate: startDate,
    endDate: endDate,
    date: date,
    serviceName: service.name,
    servicePrice: service.price,
    serviceDuration: service.duration,
    status: AppointmentStatus.BOOKED.name,
  );

  // Add the newly created appointment to the schedule.
  ChooseScheduleViewModelImp().addAppointment(appointment);
}


/// Updates an existing appointment with new date and time information.
///
/// This function takes a [context] of type [BuildContext], a [ref] of type [WidgetRef], [startDate] and [endDate] of type [Timestamp],
/// and a [date] of type [String]. It retrieves the current appointment from the [appointmentFromAppointmentsHistoryProvider] using the [ref].
/// The provided [startDate], [endDate], and [date] are used to create a map of fields to update, and then the [ChooseScheduleViewModelImp().updateAppointment()] method is called to update the appointment.
///
/// Parameters:
///   - context: The [BuildContext] to access navigation and show dialogs.
///   - ref: The [WidgetRef] to access state and view model functions.
///   - startDate: The updated start date and time of the appointment.
///   - endDate: The updated end date and time of the appointment.
///   - date: The updated date of the appointment in string format.
///
/// Returns: void
void _updateAppointment(BuildContext context, WidgetRef ref, Timestamp startDate, Timestamp endDate, String date) {
  AppointmentModel appointment = ref.read(appointmentFromAppointmentsHistoryProvider);

  // Create a map of fields to update for the appointment.
  Map<String, dynamic> fields = {
    AppointmentModel.col_startDate: startDate,
    AppointmentModel.col_endDate: endDate,
    AppointmentModel.col_date: date,
  };

  // Update the appointment using the provided fields.
  ChooseScheduleViewModelImp().updateAppointment(appointment.appointmentId, fields);
}


/// Saves or updates an appointment based on the selected time slot and date.
///
/// This function takes a [context] of type [BuildContext], a [ref] of type [WidgetRef], and a [isNavigationFromHome] of type [bool] to determine whether it's a new appointment or an update from the appointments history. It first checks if a time slot has been selected by reading the [currentSlotIndexProvider] from the [ref]. If no time slot is selected, it displays a warning dialog. Otherwise, it retrieves the selected time slot, date, and converts them to [Timestamp] format using [MethodHelper.convertTimeOfDayToTimestamp]. If it's a new appointment, it calls the [_addNewAppointment] function with the required parameters. If it's an update from the appointments history, it calls the [_updateAppointment] function with the updated date and time information. After completing the appropriate action, it navigates back to the previous screen and cleans up the appointments-related variables.
///
/// Parameters:
///   - context: The [BuildContext] to access navigation and show dialogs.
///   - ref: The [WidgetRef] to access state and view model functions.
///   - isNavigationFromHome: A flag indicating whether the navigation is from the home screen or not.
///
/// Returns: void
void _saveAppointment(BuildContext context, WidgetRef ref, bool isNavigationFromHome) {
  if (ref.read(currentSlotIndexProvider) == -1) {
    MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Must select a time slot to continue');
  } else {
    TimeSlotModel slot = ref.read(currentSlotProvider);
    DateTime selectedDate = ref.read(selectedDayProvider);

    Timestamp startDate = MethodHelper.convertTimeOfDayToTimestamp(TimeOfDay(hour: slot.startTime.hour, minute: slot.startTime.minute));
    Timestamp endDate = MethodHelper.convertTimeOfDayToTimestamp(TimeOfDay(hour: slot.endTime.hour, minute: slot.endTime.minute));
    String date = DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(selectedDate);

    if (!isNavigationFromHome) {
      _addNewAppointment(context, ref, startDate, endDate, date);
    } else {
      _updateAppointment(context, ref, startDate, endDate, date);
    }

    // Create a Completer to manage the timer completion
    Completer<void> completer = Completer<void>();

    Timer(const Duration(milliseconds: TRANSITION_DURATION), () {
      Navigator.of(context).pop();
      completer.complete();
    });

    completer.future.then((_) {
      Timer(const Duration(milliseconds: TRANSITION_DURATION), () {
        MethodHelper.cleanAppointmentsVariables(ref);
      });
    });
  }
}

/// Generates a list of time slots based on the specified start and end times and interval.
///
/// This function takes a [startTime] of type [TimeOfDay], an [endTime] of type [TimeOfDay], and an [interval] of type [int]. It creates an empty list of [TimeSlotModel] objects to store the generated time slots. It then iterates through the time range defined by [startTime] and [endTime], incrementing by the specified [interval]. For each iteration, it calculates the next time based on the current time and interval. It creates a [TimeSlotModel] with the calculated start and end times and adds it to the list of time slots. The function continues this process until the current time exceeds the end time. Finally, it returns the list of generated time slots.
///
/// Parameters:
///   - startTime: The starting time of the time slots.
///   - endTime: The ending time of the time slots.
///   - interval: The interval between each time slot.
///
/// Returns: A list of [TimeSlotModel] representing the generated time slots.
List<TimeSlotModel> _generateSlotsByRangeAndInterval(TimeOfDay startTime, TimeOfDay endTime, int interval) {
  List<TimeSlotModel> timeSlots = [];
  TimeOfDay currentTime = startTime;

  while (currentTime.hour < endTime.hour) {
    TimeOfDay nextTime;

    if (currentTime.minute == (60 - INTERVAL_SLOT)) {
      nextTime = TimeOfDay(hour: currentTime.hour + 1, minute: 0);
    } else {
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

/// Checks if a given time slot is available for an appointment within the specified time range.
///
/// This function takes a [slot] of type [TimeSlotModel], an [appointmentStartTime] of type [TimeOfDay], and an [appointmentEndTime] of type [TimeOfDay]. It compares the start and end times of the [slot] with the [appointmentStartTime] and [appointmentEndTime]. If the start time of the slot is greater than or equal to the appointment start time and the end time of the slot is less than or equal to the appointment end time, it returns true, indicating that the slot is available for the appointment. Otherwise, it returns false.
///
/// Parameters:
///   - slot: The time slot to check.
///   - appointmentStartTime: The start time of the appointment.
///   - appointmentEndTime: The end time of the appointment.
///
/// Returns: True if the slot is available for the appointment, false otherwise.
bool _isSlotAvailable(TimeSlotModel slot, TimeOfDay appointmentStartTime, TimeOfDay appointmentEndTime) {
  if (MethodHelper.timeOfDayToDouble(slot.startTime) >= MethodHelper.timeOfDayToDouble(appointmentStartTime) &&
      MethodHelper.timeOfDayToDouble(slot.endTime) <= MethodHelper.timeOfDayToDouble(appointmentEndTime)) {
    return true;
  }
  return false;
}

/// Checks the availability of time slots based on existing appointments.
///
/// This function takes a list of [appointments] of type [List<AppointmentModel>], a list of [slots] of type [List<TimeSlotModel>], a [slotStartTime] of type [TimeOfDay], and a [slotEndTime] of type [TimeOfDay]. It iterates through each appointment and compares its start and end times with the [slotStartTime] and [slotEndTime] to determine if the appointment falls within the interval of the time slot. If an appointment is within the time slot, it marks the corresponding slot as unavailable for booking.
///
/// Parameters:
///   - appointments: List of existing appointments.
///   - slots: List of time slots.
///   - slotStartTime: Start time of the time slot.
///   - slotEndTime: End time of the time slot.
void _checkAvailableAndUnavailableSlots(
    List<AppointmentModel> appointments,
    List<TimeSlotModel> slots,
    TimeOfDay slotStartTime,
    TimeOfDay slotEndTime) {
  for (var appointment in appointments) {
    TimeOfDay appointmentStartTime =
    MethodHelper.convertTimestampToTimeOfDay(appointment.startDate);
    TimeOfDay appointmentEndTime =
    MethodHelper.convertTimestampToTimeOfDay(appointment.endDate);

    // If the appointment is in the interval of the time slot
    if (MethodHelper.timeOfDayToDouble(appointmentStartTime) >=
        MethodHelper.timeOfDayToDouble(slotStartTime) &&
        MethodHelper.timeOfDayToDouble(appointmentEndTime) <=
            MethodHelper.timeOfDayToDouble(slotEndTime)) {
      for (var slot in slots) {
        if (_isSlotAvailable(slot, appointmentStartTime, appointmentEndTime)) {
          slot.hasAppointment = true;
        }
      }
    }
  }
}

/// Checks and identifies possible time slots based on service duration and availability.
///
/// This function takes a list of [slots] of type [List<TimeSlotModel>], a list of [possibleSlots] of type [List<TimeSlotModel>], the number of [numServiceInstances] that can be accommodated in a single booking, and the [serviceDuration] in minutes. It iterates through each slot and checks if there are enough consecutive available slots to accommodate the required number of service instances. If found, it calculates the end time of the possible slot and adds it to the [possibleSlots] list.
///
/// Parameters:
///   - slots: List of available time slots.
///   - possibleSlots: List to store identified possible time slots.
///   - numServiceInstances: Number of service instances to be accommodated.
///   - serviceDuration: Duration of each service instance in minutes.
void _checkPossibleSlotsForServiceDuration(
    List<TimeSlotModel> slots,
    List<TimeSlotModel> possibleSlots,
    double numServiceInstances,
    int serviceDuration) {
  for (int i = 0; i < slots.length; i++) {
    if (!slots[i].hasAppointment!) {
      int countNumServiceInstances = 0;

      for (int j = i; j < slots.length; j++) {
        if (!slots[i + countNumServiceInstances].hasAppointment!) {
          countNumServiceInstances++;

          if (countNumServiceInstances == numServiceInstances) {
            TimeOfDay endTime;
            if (slots[i].startTime.minute + serviceDuration >= 60) {
              endTime = TimeOfDay(
                  hour: slots[i].startTime.hour + 1,
                  minute: slots[i].startTime.minute + serviceDuration - 60);
            } else {
              endTime = TimeOfDay(
                  hour: slots[i].startTime.hour,
                  minute: slots[i].startTime.minute + serviceDuration);
            }
            possibleSlots.add(
                TimeSlotModel(startTime: slots[i].startTime, endTime: endTime));
            break;
          }
        }
      }
    }
  }
}

/// Generates a list of available time slots for appointments based on predefined time slots and booked appointments.
///
/// This function takes a [ref] of type [WidgetRef], a list of [listBookedAppointments] of type [List<AppointmentModel>], and [serviceDuration] in minutes. It generates a list of available [TimeSlotModel] instances for booking appointments. The function calculates the number of service instances that can fit in the service duration and then iterates through predefined time slots to check availability and identify possible slots that can accommodate the service instances.
///
/// Parameters:
///   - ref: Reference to the widget context.
///   - listBookedAppointments: List of booked appointments.
///   - serviceDuration: Duration of the service in minutes.
///
/// Returns:
///   - A list of available [TimeSlotModel] instances for booking appointments.
List<TimeSlotModel> _getAvailableSlots(
    WidgetRef ref,
    List<AppointmentModel> listBookedAppointments,
    int serviceDuration) {
  List<TimeSlotModel> listAvailableAppointments = [];
  double numServiceInstances = serviceDuration / INTERVAL_SLOT;

  /// Define the list of time slots for the day (start times and end times)
  List<TimeSlotModel> timeSlots = [
    TimeSlotModel(startTime: const TimeOfDay(hour: 9, minute: 0),endTime: const TimeOfDay(hour: 13, minute: 0)),
    TimeSlotModel(startTime: const TimeOfDay(hour: 14, minute: 0),endTime: const TimeOfDay(hour: 18, minute: 0)),
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








