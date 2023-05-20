

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyInkwell extends ConsumerWidget {

  final MyInkwellType type;
  final Widget widget;
  final Function()? onTap;

  const MyInkwell({super.key, required this.type, required this.widget,required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyInkwellType.GENERAL:
        return generalInkwell(widget,onTap);
      default:
        return Container();
    }

  }

  Widget generalInkwell(Widget widget,Function()? onTap){

    return Stack(
      children: [
        widget,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: blue.withOpacity(0.1),
              splashColor: blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              onTap: onTap,

            ),
          ),
        ),
      ],
    );
  }


}