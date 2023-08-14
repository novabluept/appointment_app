

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_label.dart';

class MyDialog extends ConsumerWidget {

  final MyDialogType type;
  final String label;
  final Function() positiveButtonOnPressed;

  const MyDialog({super.key, required this.type, required this.label,required this.positiveButtonOnPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return generalDivider(type,label,positiveButtonOnPressed);
  }

  Widget generalDivider(MyDialogType type,String label,Function() positiveButtonOnPressed){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 44.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: light1,
              borderRadius: BorderRadius.all(Radius.circular(48.0).r),
            ),
            child: Material(
              child: Column(
                children: [
                  SvgPicture.asset(type == MyDialogType.SUCCESS ? 'images/success_image.svg' : 'images/failure_image.svg',width: 180.w,height: 185.h),
                  SizedBox(height: 32.h,),
                  MyLabel(
                    type: MyLabelType.H4,
                    fontWeight: MyLabel.BOLD,
                    color: red,
                    label: type == MyDialogType.SUCCESS ? 'Success!' : 'Oops, Failed!',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h,),
                  MyLabel(
                    type: MyLabelType.BODY_LARGE,
                    fontWeight: MyLabel.NORMAL,
                    label: label, //'Appointment failed. Please check your internet connection then try again.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h,),
                  MyButton(
                    type: MyButtonType.FILLED,
                    labelColor: light1,
                    backgroundColor: blue,
                    foregroundColor: light1,
                    label: 'Ok',
                    verticalPadding: 6,
                    onPressed: positiveButtonOnPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}