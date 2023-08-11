

import 'package:appointment_app_v2/style/general_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/enums.dart';
import 'my_label.dart';

class MyButton extends ConsumerWidget {

  final MyButtonType type;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String label;
  final String? imgUrl;
  final int height;
  final int verticalPadding;
  final Function() onPressed;


  const MyButton({super.key, required this.type, this.labelColor, this.backgroundColor, this.foregroundColor, required this.label, this.imgUrl,this.height = 60,this.verticalPadding = 18, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyButtonType.FILLED:
        return generalButton(MyButtonType.FILLED,label,labelColor!,backgroundColor!,foregroundColor!,height,verticalPadding,onPressed);
      case MyButtonType.OUTLINED:
        return generalButton(MyButtonType.OUTLINED,label,labelColor!,backgroundColor!,foregroundColor!,height,verticalPadding,onPressed);
      case MyButtonType.IMAGE:
        return buttonImage(label,imgUrl!,onPressed);
      default:
        return Container();
    }

  }

  Widget generalButton(MyButtonType type,String label,Color labelColor,Color backgroundColor,Color foregroundColor,int height,int verticalPadding,Function() onPressed){
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          side: BorderSide(color: type == MyButtonType.FILLED ? backgroundColor : foregroundColor)
        ),
        child: MyLabel(
          type: MyLabelType.BODY_LARGE,
          fontWeight: MyLabel.BOLD,
          label: label,
          color: labelColor,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget buttonImage(String label,String imgUrl,Function() onPressed){
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            side: BorderSide(color: grey200)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(imgUrl,width: 24.w,height: 24.h),
            SizedBox(width: 12.w),
            MyLabel(
              type: MyLabelType.BODY_LARGE,
              label: label,
              fontWeight: MyLabel.SEMI_BOLD,
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }


}