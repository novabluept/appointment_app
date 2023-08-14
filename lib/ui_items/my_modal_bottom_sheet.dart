

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyModalBottomSheet extends ConsumerWidget {

  final MyModalBottomSheetType type;
  final double height;
  final Widget content;

  const MyModalBottomSheet({super.key, required this.type,required this.height, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyModalBottomSheetType.GENERAL:
        return generalModalBottomSheet(height,content);
      default:
        return Container();
    }
  }

  Widget generalModalBottomSheet(double height,Widget content){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(48).r,topRight: Radius.circular(48).r),
      ),
      height: height.h,
      child: Column(
        children: [
          SizedBox(height: 8.h,),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 38.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: grey300,
                borderRadius: BorderRadius.circular(24.0).r,
              ),
            ),
          ),
          content
        ],
      ),
    );
  }


}