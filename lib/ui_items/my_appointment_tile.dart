

import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../model/appointment_model.dart';
import '../style/general_style.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyAppointmentTile extends ConsumerWidget {

  final MyAppointmentTileType type;
  final int? index;
  final AppointmentModel? appointment;
  final bool hasButtons;


  const MyAppointmentTile({super.key, required this.type, this.index,this.appointment,this.hasButtons = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyAppointmentTileType.BOOKED:
        return generalAppointmentTile(type,index!,appointment!,hasButtons);
      case MyAppointmentTileType.COMPLETED:
        return generalAppointmentTile(type,index!,appointment!,hasButtons);
      case MyAppointmentTileType.CANCELLED:
        return generalAppointmentTile(type,index!,appointment!,hasButtons);
      case MyAppointmentTileType.SHIMMER:
        return shimmerAppointmentTile(hasButtons);
      default:
        return Container();
    }

  }

  Widget generalAppointmentTile(MyAppointmentTileType type,int index,AppointmentModel appointment,bool hasButtons){

    TimeOfDay appointmentStartTime = MethodHelper.convertTimestampToTimeOfDay(appointment.startDate);
    TimeOfDay appointmentEndTime = MethodHelper.convertTimestampToTimeOfDay(appointment.endDate);

    String startDate = MethodHelper.convertHourAndMinuteToFormattedDate(appointmentStartTime.hour, appointmentStartTime.minute);
    String endDate = MethodHelper.convertHourAndMinuteToFormattedDate(appointmentEndTime.hour, appointmentEndTime.minute);

    return Container(
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.circular(16.0).r,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w,top: 16.w,right: 16.w),
            child: SizedBox(
              height: 110.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16).r,
                          child: Image.memory(
                              frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded!) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.linear,
                                  child: child,
                                );
                              },
                              appointment.professionalImageUint8list!,
                              width: 110.h,
                              height: 110.h,
                              fit: BoxFit.cover
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              type == MyAppointmentTileType.BOOKED ? MyPill(type: MyPillType.PRIMARY_FILLED_TRANSPARENT,label: 'Upcomming') :
                              type == MyAppointmentTileType.COMPLETED ? MyPill(type: MyPillType.SUCCESS_FILLED_TRANSPARENT,label: 'Completed') :
                              MyPill(type: MyPillType.DANGER_FILLED_TRANSPARENT,label: 'Cancelled'),
                              MyLabel(
                                type: MyLabelType.H6,
                                fontWeight: MyLabel.BOLD,
                                label: appointment.professionalFirstName + " " + appointment.professionalLastName,
                                overflow: TextOverflow.ellipsis,
                              ),
                              MyLabel(
                                type: MyLabelType.BODY_SMALL,
                                fontWeight: MyLabel.MEDIUM,
                                label: appointment.date + ' | ' + startDate + " - " + endDate,
                                color: grey800,
                                overflow: TextOverflow.ellipsis,
                              ),
                              MyLabel(
                                type: MyLabelType.BODY_SMALL,
                                fontWeight: MyLabel.MEDIUM,
                                label: appointment.serviceName,
                                color: grey800,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 22.w,),
                  Center(
                    child: CircleAvatar(
                      radius: 28.sp,
                      backgroundColor: lightBlue,
                      child: IconButton(
                        icon: Icon(
                          IconlyBold.chat,
                          size: 24.sp,
                          color: blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: hasButtons ?  8.w : 16.w),
          hasButtons ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w,right: 16.w),
                child: Divider(
                  color: grey200,
                  thickness: 1.0,
                ),
              ),
              SizedBox(height: 8.w),
              Padding(
                padding: EdgeInsets.only(left: 16.w,bottom: 16.w,right: 16.w),
                child: Row(
                  children: [
                    Flexible(child: MyButton(type: MyButtonType.OUTLINED, label: 'Cancel Appointment',height: 32,verticalPadding: 6,onPressed:() {})),
                    SizedBox(width: 16.w),
                    Flexible(child: MyButton(type: MyButtonType.FILLED, label: 'Reschedule',height: 32,verticalPadding: 6,onPressed:() {}))
                  ],
                ),
              )
            ],
          ) : Container()

        ],
      ),
    );
  }

  Widget shimmerAppointmentTile(bool hasButtons){

    return Container(
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.circular(16.0).r,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w,top: 16.w,right: 16.w),
            child: SizedBox(
              height: 110.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: grey300,
                          highlightColor: grey100,
                          child: Container(
                            width: 110.h,
                            height: 110.h,
                            decoration: BoxDecoration(
                                color: light1,
                                borderRadius: BorderRadius.all(Radius.circular(16).r)
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: grey300,
                                highlightColor: grey100,
                                child: Container(
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                      color: light1,
                                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                                  ),
                                  child: MyPill(type: MyPillType.DANGER_FILLED_TRANSPARENT,label: 'Cancelled'),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: grey300,
                                highlightColor: grey100,
                                child: Container(
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                      color: light1,
                                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                                  ),
                                  child: MyLabel(
                                    type: MyLabelType.BODY_XSMALL,
                                    label: 'Porta 54',
                                    fontWeight: MyLabel.MEDIUM,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: grey300,
                                highlightColor: grey100,
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: light1,
                                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                                  ),
                                  child: MyLabel(
                                    type: MyLabelType.BODY_XSMALL,
                                    label: 'Porta 54',
                                    fontWeight: MyLabel.MEDIUM,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: grey300,
                                highlightColor: grey100,
                                child: Container(
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                      color: light1,
                                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                                  ),
                                  child: MyLabel(
                                    type: MyLabelType.BODY_XSMALL,
                                    label: 'Porta 54',
                                    fontWeight: MyLabel.MEDIUM,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 22.w,),
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: grey300,
                      highlightColor: grey100,
                      child: CircleAvatar(
                        radius: 28.sp,
                        backgroundColor: lightBlue,
                        child: IconButton(
                          icon: Icon(
                            IconlyBold.chat,
                            size: 24.sp,
                            color: blue,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: hasButtons ?  8.w : 16.w),
          hasButtons ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w,right: 16.w),
                child: Divider(
                  color: grey200,
                  thickness: 1.0,
                ),
              ),
              SizedBox(height: 8.w),
              Padding(
                padding: EdgeInsets.only(left: 16.w,bottom: 16.w,right: 16.w),
                child: Row(
                  children: [
                    Flexible(
                      child: Shimmer.fromColors(
                        baseColor: grey300,
                        highlightColor: grey100,
                        child: MyButton(
                          type: MyButtonType.FILLED,
                          label: 'Cancel Appointment',
                          height: 32,
                          verticalPadding: 6,
                          onPressed:() {

                          }
                        ),
                      )
                    ),
                    SizedBox(width: 16.w),
                    Flexible(
                      child: Shimmer.fromColors(
                        baseColor: grey300,
                        highlightColor: grey100,
                        child: MyButton(
                          type: MyButtonType.FILLED,
                          label: 'Reschedule',
                          height: 32,
                          verticalPadding: 6,
                          onPressed:() {

                          }
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ) : Container()

        ],
      ),
    );
  }


}