

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyHomeShop extends ConsumerWidget {

  final MyHomeShopType type;
  final Uint8List? image;
  final String? name;
  final String? city;
  final String? state;
  final Function()? onTap;

  const MyHomeShop({super.key,required this.type,this.image,this.name,this.city,this.state,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyHomeShopType.GENERAL:
        return generalHomeShop(image!,name!,city!,state!,onTap);
      case MyHomeShopType.SHIMMER:
        return shimmerHomeShop();
      default:
        return Container();
    }
  }

  Widget generalHomeShop(Uint8List image,String name,String city,String state,Function()? onTap){
    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0).r),
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
                    width: 380.w,
                    height: 380.h,
                    fit: BoxFit.cover
                ),
              ),
            ],
          ),
          Container(
            width: 380.w,
            height: 380.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0).r),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Container(),
          ),
          Container(
            width: 380.w,
            height: 380.h,
            padding: EdgeInsets.all(24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabel(
                  type: MyLabelType.H5,
                  fontWeight: MyLabel.BOLD,
                  label: name,
                  color: light1,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.location_on,size: 16.sp,color: blue),
                    SizedBox(width: 6.w),
                    MyLabel(
                      type: MyLabelType.BODY_XLARGE,
                      fontWeight: MyLabel.MEDIUM,
                      label: '${city}, ${state}',
                      color: light1,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Book Appointment',onPressed: (){}),
              ],
            ),
          ),
        ]
      ),
      onTap: onTap,
    );
  }


  Widget shimmerHomeShop(){
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: grey300,
          highlightColor: grey100,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0).r),
                child: Container(
                  color: grey300,
                  width: 380.w,
                  height: 380.h,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 380.w,
          height: 380.h,
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: grey300,
                highlightColor: grey100,
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: light1,
                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                  ),
                  child: Text(''),
                ),
              ),
              SizedBox(height: 12.h),
              Shimmer.fromColors(
                baseColor: grey300,
                highlightColor: grey100,
                child: Container(
                  width: 250.w,
                  decoration: BoxDecoration(
                      color: light1,
                      borderRadius: BorderRadius.all(Radius.circular(16).r)
                  ),
                  child: Text(''),
                ),
              ),
              SizedBox(height: 12.h),
              Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 380.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(Radius.circular(16).r)
                    ),
                    child: Text(''),
                  ),
              )
            ],
          ),
        ),
      ]
    );
  }


}