

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
      case MyPillType.PRIMARY:
        return generalPill(label);
      default:
        return Container();
    }

  }

  Widget generalPill(String label){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0).r,
        border: Border.all(
            width: 1.w,
            color: blue,
            strokeAlign: BorderSide.strokeAlignCenter)
      ),
      child: MyLabel(
        type: MyLabelType.BODY_SMALL,
        fontWeight: MyLabel.MEDIUM,
        label: label,
        color: blue,
      ),
    );
  }


}