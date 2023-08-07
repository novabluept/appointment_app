

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyException extends ConsumerWidget {

  final MyExceptionType type;
  final String? imagePath;
  final String? firstLabel;
  final String? secondLabel;

  const MyException({super.key, required this.type,this.imagePath, this.firstLabel,this.secondLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyExceptionType.GENERAL:
        return generalException(imagePath!, firstLabel!,secondLabel!);
      default:
        return Container();
    }

  }

  Widget generalException(String imagePath,String firstLabel,String secondLabel){

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath,width: 225.w,height: 220.h),
          SizedBox(height: 48.h),
          MyLabel(
            type: MyLabelType.H5,
            fontWeight: MyLabel.BOLD,
            label: firstLabel,
            color: grey900,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          MyLabel(
            type: MyLabelType.BODY_LARGE,
            fontWeight: MyLabel.NORMAL,
            label: secondLabel,
            color: grey900,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


}