

import 'package:appointment_app_v2/model/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../state_management/make_appointments_state.dart';
import '../state_management/choose_shop_state.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';

class MyChooseServiceTile extends ConsumerWidget {

  final MyChooseServiceTileType type;
  final int? index;
  final ServiceModel? service;
  final Function()? onTap;


  const MyChooseServiceTile({super.key, required this.type,this.index,this.service,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseServiceTileType.GENERAL:
        return generalChooseServiceTile(index!,service!,ref,onTap);
      case MyChooseServiceTileType.SHIMMER:
        return shimmerChooseServiceTile();
      default:
        return Container();
    }

  }

  Widget generalChooseServiceTile(int index,ServiceModel service,WidgetRef ref,Function()? onTap){
    int currentIndex = ref.watch(currentServiceIndexProvider);
    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: index == currentIndex ? blue : light1,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyLabel(
                    type: MyLabelType.BODY_LARGE,
                    fontWeight: MyLabel.BOLD,
                    label: service.name,
                    color: index == currentIndex ? light1 : dark1,
                  ),
                  SizedBox(height: 8.h),
                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    fontWeight: MyLabel.MEDIUM,
                    label: 'Information',
                    color: index == currentIndex ? grey300 : grey800,
                  ),
                ],
              ),
              Column(
                children: [
                  MyLabel(
                    type: MyLabelType.BODY_XLARGE,
                    fontWeight: MyLabel.BOLD,
                    label: service.price.toString() + "€",
                    color: index == currentIndex ? light1 : blue,
                  ),
                  SizedBox(height: 8.h),
                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    fontWeight: MyLabel.MEDIUM,
                    label: service.duration.toString()+ " min",
                    color: index == currentIndex ? grey300 : grey800,
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

  Widget shimmerChooseServiceTile(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: light1,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(Radius.circular(16).r)
                    ),
                    child: MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      fontWeight: MyLabel.BOLD,
                      label: 'aacaaae',
                      color: dark1,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(Radius.circular(16).r)
                    ),
                    child: MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      fontWeight: MyLabel.MEDIUM,
                      label: 'information',
                      color: grey800,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 20.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(Radius.circular(16).r)
                    ),
                    child: MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      fontWeight: MyLabel.BOLD,
                      label: '20',
                      color: blue,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(Radius.circular(16).r)
                    ),
                    child: MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      fontWeight: MyLabel.MEDIUM,
                      label: '30 mins',
                      color: grey800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}