

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';

class MyChooseServiceTile extends ConsumerWidget {

  final MyChooseServiceTileType type;
  final int index;
  final Function()? onTap;


  const MyChooseServiceTile({super.key, required this.type,required this.index, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseServiceTileType.GENERAL:
        return generalChooseServiceTile(index,onTap);
      default:
        return Container();
    }

  }

  Widget generalChooseServiceTile(int index,Function()? onTap){

    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: index == 1 ? blue : light1,
          border: Border.all(
              width: 1.w,
              color: light1,
              strokeAlign: BorderSide.strokeAlignCenter),
          borderRadius: BorderRadius.circular(16.0).r,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  MyLabel(
                    type: MyLabelType.BODY_LARGE,
                    fontWeight: MyLabel.BOLD,
                    label: 'Package',
                    color: index == 1 ? light1 : dark1,
                  ),
                  SizedBox(height: 8.h,),
                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    fontWeight: MyLabel.MEDIUM,
                    label: 'Information',
                    color: index == 1 ? grey300 : grey800,
                  ),
                ],
              ),
              Column(
                children: [
                  MyLabel(
                    type: MyLabelType.BODY_XLARGE,
                    fontWeight: MyLabel.BOLD,
                    label: '20€',
                    color: index == 1 ? light1 : blue,
                  ),
                  SizedBox(height: 8.h,),
                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    fontWeight: MyLabel.MEDIUM,
                    label: '30 mins',
                    color: index == 1 ? grey300 : grey800,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }


}