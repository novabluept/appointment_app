

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import '../model/user_model.dart';
import '../state_management/appointments_state.dart';
import '../state_management/choose_shop_state.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyChooseProfessionalTile extends ConsumerWidget {

  final MyChooseProfessionalTileType type;
  final int? index;
  final UserModel? user;
  final String? shopName;
  final Function()? onTap;


  const MyChooseProfessionalTile({super.key, required this.type,this.index,this.user,this.shopName,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseProfessionalTileType.GENERAL:
        return generalChooseProfessionalTile(index!,user!,shopName!,ref,onTap);
      case MyChooseProfessionalTileType.SHIMMER:
        return shimmerChooseShopTile();
      default:
        return Container();
    }

  }

  Widget generalChooseProfessionalTile(int index,UserModel user,String shopName,WidgetRef ref,Function()? onTap){
    int currentIndex = ref.watch(currentProfessionalIndexProvider);
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
                        user.imageUnit8list!,
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

                  MyLabel(
                    type: MyLabelType.BODY_XSMALL,
                    label: shopName,
                    fontWeight: MyLabel.MEDIUM,
                    color: index == currentIndex ? grey300 : grey800,
                  ),

                  SizedBox(height: 8.h),

                  MyLabel(
                    type: MyLabelType.H6,
                    label: '${user.firstname} ${user.lastname}',
                    fontWeight: MyLabel.BOLD,
                    color: index == currentIndex ? light1 : grey800,
                  ),

                  SizedBox(height: 8.h),

                  MyPill(type: MyPillType.PRIMARY_FILLED_TRANSPARENT,label: 'Barbeiro  ( Colocar dinamico )'),



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
                      width: 50.w,
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
                    child: Container(
                      width: 200.w,
                      decoration: BoxDecoration(
                          color: light1,
                          borderRadius: BorderRadius.all(Radius.circular(16).r)
                      ),
                      child: MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: 'Jenna Watson',
                        fontWeight: MyLabel.BOLD,
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
                        label: 'Jenna Watson',
                        fontWeight: MyLabel.BOLD,
                      ),
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