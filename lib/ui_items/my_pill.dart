
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyPill extends ConsumerWidget {

  final MyPillType type;
  final String label;

  const MyPill({super.key, required this.type, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyPillType.PRIMARY_OUTLINED:
        return generalPill(type,label);
      case MyPillType.SUCCESS_OUTLINED:
        return generalPill(type,label);
      case MyPillType.DANGER_OUTLINED:
        return generalPill(type,label);
      case MyPillType.PRIMARY_FILLED_TRANSPARENT:
        return generalPill(type,label);
      case MyPillType.SUCCESS_FILLED_TRANSPARENT:
        return generalPill(type,label);
      case MyPillType.DANGER_FILLED_TRANSPARENT:
        return generalPill(type,label);
      default:
        return Container();
    }
  }

  Color _borderColor(MyPillType type){
    switch(type){
      case MyPillType.PRIMARY_OUTLINED:
        return blue;
      case MyPillType.SUCCESS_OUTLINED:
        return green;
      case MyPillType.DANGER_OUTLINED:
        return red;
      case MyPillType.PRIMARY_FILLED_TRANSPARENT:
        return lightBlue;
      case MyPillType.SUCCESS_FILLED_TRANSPARENT:
        return lightGreen;
      case MyPillType.DANGER_FILLED_TRANSPARENT:
        return lightRed;
    }
  }

  Color _labelColor(MyPillType type){
    switch(type){
      case MyPillType.PRIMARY_OUTLINED:
        return blue;
      case MyPillType.SUCCESS_OUTLINED:
        return green;
      case MyPillType.DANGER_OUTLINED:
        return red;
      case MyPillType.PRIMARY_FILLED_TRANSPARENT:
        return blue;
      case MyPillType.SUCCESS_FILLED_TRANSPARENT:
        return green;
      case MyPillType.DANGER_FILLED_TRANSPARENT:
        return red;
    }
  }

  Color _backgroundColor(MyPillType type){
    switch(type){
      case MyPillType.PRIMARY_OUTLINED:
        return light1;
      case MyPillType.SUCCESS_OUTLINED:
        return light1;
      case MyPillType.DANGER_OUTLINED:
        return light1;
      case MyPillType.PRIMARY_FILLED_TRANSPARENT:
        return lightBlue;
      case MyPillType.SUCCESS_FILLED_TRANSPARENT:
        return lightGreen;
      case MyPillType.DANGER_FILLED_TRANSPARENT:
        return lightRed;
    }
  }

  Widget generalPill(MyPillType type,String label){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0).r,
        color: _backgroundColor(type),
        border: Border.all(
          width: 1.w,
          color: _borderColor(type),
          strokeAlign: BorderSide.strokeAlignCenter
        )
      ),
      child: MyLabel(
        type: MyLabelType.BODY_SMALL,
        fontWeight: MyLabel.MEDIUM,
        label: label,
        color: _labelColor(type),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


}