

import 'dart:typed_data';

import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../model/appointment_model.dart';
import '../model/time_slot_model.dart';
import '../model/user_model.dart';
import '../state_management/appointments_state.dart';
import '../state_management/choose_shop_state.dart';
import '../style/general_style.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyChooseScheduleTile extends ConsumerWidget {

  final MyChooseScheduleTileType type;
  final int? index;
  final TimeSlotModel? timeSlot;
  final Function()? onTap;


  const MyChooseScheduleTile({super.key, required this.type,this.index,this.timeSlot,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseScheduleTileType.GENERAL:
        return generalChooseScheduleTile(index!,timeSlot!,ref,onTap);
      case MyChooseScheduleTileType.SHIMMER:
        return shimmerChooseShopTile();
      default:
        return Container();
    }

  }

  Widget generalChooseScheduleTile(int index,TimeSlotModel slot,WidgetRef ref,Function()? onTap){
    int currentIndex = ref.watch(currentSlotIndexProvider);

    String startDate = MethodHelper.convertHourAndMinuteToFormattedDate(slot.startTime.hour, slot.startTime.minute);
    String endDate = MethodHelper.convertHourAndMinuteToFormattedDate(slot.endTime.hour, slot.endTime.minute);

    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Center(
          child: Container(
            width: 118.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: index == currentIndex ? blue : light1,
              borderRadius: BorderRadius.circular(100.0).r,
              border: Border.all(
                  width: 2.w,
                  color: blue,
                  strokeAlign: BorderSide.strokeAlignCenter),
            ),
            child: Center(
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.BOLD,
                label: '$startDate - $endDate',
                color: index == currentIndex ? light1 : blue,
              ),
            ),
          )
      ),
      onTap: onTap,
    );
  }



  Widget shimmerChooseShopTile(){
    return Shimmer.fromColors(
      baseColor: grey300,
      highlightColor: grey100,
      child: Center(
          child: Container(
            width: 118.w,
            height: 45.h,
            decoration: BoxDecoration(
              color: light1,
              borderRadius: BorderRadius.circular(100.0).r,
              border: Border.all(
                  width: 2.w,
                  color: blue,
                  strokeAlign: BorderSide.strokeAlignCenter),
            ),
            child: Center(
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.BOLD,
                label: '09:00 - 10:00',
                color: blue,
              ),
            ),
          )
      ),
    );
  }


}