
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';

class MyModalBottomSheet extends ConsumerWidget {

  final MyModalBottomSheetType type;
  final Widget content;

  const MyModalBottomSheet({super.key, required this.type, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyModalBottomSheetType.GENERAL:
        return generalModalBottomSheet(content);
      default:
        return Container();
    }
  }

  Widget generalModalBottomSheet(Widget content){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: light1,
            borderRadius: BorderRadius.only(topLeft: const Radius.circular(48).r,topRight: const Radius.circular(48).r),
          ),
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
        )
      ],
    );
  }


}