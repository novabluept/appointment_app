

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_label.dart';

class MyAppointmentTile extends ConsumerWidget {

  final MyAppointmentTileType type;
  final bool hasButtons;


  const MyAppointmentTile({super.key, required this.type,this.hasButtons = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyAppointmentTileType.GENERAL:
        return generalAppointmentTile();
      default:
        return Container();
    }

  }

  Widget generalAppointmentTile(){

    return Container(
      decoration: BoxDecoration(
        color: white,
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
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16).r,
                        child: Image.asset(
                          'images/girl.jpg',
                          width: 110.h,
                          height: 110.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyLabel(
                            type: MyLabelType.H6,
                            fontWeight: MyLabel.BOLD,
                            label: 'Dr. Aidan Allende',
                          ),
                          Row(
                            children: [
                              MyLabel(
                                type: MyLabelType.BODY_SMALL,
                                fontWeight: MyLabel.MEDIUM,
                                label: 'Video Call',
                                color: grey800,
                              ),
                            ],
                          ),
                          MyLabel(
                            type: MyLabelType.BODY_SMALL,
                            fontWeight: MyLabel.MEDIUM,
                            label: 'Dec 14, 2022 | 04:00 PM',
                            color: grey800,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: blue,
                      child: IconButton(
                        icon: Icon(
                          IconlyBold.chat,
                          size: 24.sp,
                          color: white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: hasButtons ?  8.w : 16.w,),
          hasButtons ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w,right: 16.w),
                child: Divider(
                  color: grey200,
                  thickness: 1.0,
                ),
              ),
              SizedBox(height: 8.w,),
              Padding(
                padding: EdgeInsets.only(left: 16.w,bottom: 16.w,right: 16.w),
                child: Row(
                  children: [
                    Flexible(child: MyButton(type: MyButtonType.OUTLINED, label: 'Cancel Appointment',height: 32,verticalPadding: 6,onPressed:() {})),
                    SizedBox(width: 16.w,),
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


}