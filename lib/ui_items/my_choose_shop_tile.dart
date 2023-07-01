

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../state_management/state.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyChooseShopTile extends ConsumerWidget {

  final MyChooseShopTileType type;
  final int? index;
  final Uint8List? image;
  final String? name;
  final String? city;
  final String? state;
  final Function()? onTap;

  const MyChooseShopTile({super.key, required this.type, this.index, this.image, this.name, this.city, this.state, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseShopTileType.GENERAL:
        return generalChooseShopTile(index!,image!,name!,city!,state!,ref,onTap);
      case MyChooseShopTileType.SHIMMER:
        return shimmerChooseShopTile();
      default:
        return Container();
    }

  }

  Widget generalChooseShopTile(int index,Uint8List image, String name, String city,String state,WidgetRef ref,Function()? onTap){
    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: index == ref.watch(currentShopIndexProvider) ? blue : light1,
          border: Border.all(
              width: 1.w,
              color: light1,
              strokeAlign: BorderSide.strokeAlignCenter),
          borderRadius: BorderRadius.circular(16.0).r,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16).r,
                    child: Image.memory(
                        frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded!) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.linear,
                            child: child,
                          );
                        },
                        image,
                        width: 110.h,
                        height: 110.h,
                        fit: BoxFit.cover
                    ),
                  ),
                ],
              ),

              SizedBox(width: 16.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.location_on,size: 10.sp,color: index == ref.watch(currentShopIndexProvider) ? light1 : blue),
                      SizedBox(width: 6.w),
                      MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: '${city}, ${state}',
                        fontWeight: MyLabel.MEDIUM,
                        color: index == ref.watch(currentShopIndexProvider) ? grey300 : grey800,
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  MyLabel(
                    type: MyLabelType.H6,
                    label: name,
                    fontWeight: MyLabel.BOLD,
                    color: index == ref.watch(currentShopIndexProvider) ? light1 : grey800,
                  ),

                  SizedBox(height: 8.h),

                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    label: 'Obter direções',
                    fontWeight: MyLabel.MEDIUM,
                    color: index == ref.watch(currentShopIndexProvider) ? grey300 : blue,
                  ),


                ],
              )

            ]
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget shimmerChooseShopTile(){
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
            children: [

              Shimmer.fromColors(
                baseColor: grey300,
                highlightColor: grey100,
                child: Container(
                  width: 110.h,
                  height: 110.h,
                  decoration: BoxDecoration(
                      color: light1,
                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                  ),
                ),
              ),

              SizedBox(width: 16.w),

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
                      child:  MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: 'Porto, Paços de Ferreira',
                        fontWeight: MyLabel.MEDIUM,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Shimmer.fromColors(
                    baseColor: grey300,
                    highlightColor: grey100,
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: light1,
                          borderRadius: BorderRadius.all(Radius.circular(16).r)
                      ),
                      child: MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: 'Porta 54',
                        fontWeight: MyLabel.MEDIUM,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Shimmer.fromColors(
                    baseColor: grey300,
                    highlightColor: grey100,
                    child: MyLabel(
                      type: MyLabelType.BODY_SMALL,
                      label: 'Obter direções',
                      fontWeight: MyLabel.MEDIUM,
                      color: blue,
                    ),
                  ),


                ],
              )

            ]
        ),
      ),
    );
  }

}