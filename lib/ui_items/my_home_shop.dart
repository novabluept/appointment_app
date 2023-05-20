

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_button.dart';
import 'my_inkwell.dart';
import 'my_label.dart';
import 'my_pill.dart';

class MyHomeShop extends ConsumerWidget {

  final MyHomeShopType type;
  final Function()? onTap;


  const MyHomeShop({super.key, required this.type,required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyHomeShopType.GENERAL:
        return generalHomeShop(onTap);
      default:
        return Container();
    }

  }

  Widget generalHomeShop(Function()? onTap){

    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0).r),
                child: Image.asset(
                  'images/barbershop_4.png',
                  fit: BoxFit.cover,
                  width: 380.w,
                  height: 380.h,),
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
                  Colors.black.withOpacity(0.5),
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
                  label: 'Porta 54',
                  color: light1,
                ),
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Icon(Icons.location_on,size: 16.sp,color: blue,),
                    SizedBox(width: 6.w,),
                    MyLabel(
                      type: MyLabelType.BODY_XLARGE,
                      fontWeight: MyLabel.MEDIUM,
                      label: 'Porto, Paços de Ferreira',
                      color: light1,
                    ),
                  ],
                ),
                SizedBox(height: 12.h,),
                MyButton(type: MyButtonType.FILLED, label: 'Book Appointment',onPressed: (){}),
              ],
            ),
          ),
        ]
      ),
      onTap: onTap,
    );

    /*return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Container(
        decoration: BoxDecoration(
          color: light1,
          borderRadius: BorderRadius.circular(16.0).r,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15.0).r,topLeft: Radius.circular(15.0).r),
              child: Image.asset(
                'images/house.jpg',
                fit: BoxFit.cover,
                width: 380.w,
                height: 200.h,),
            ),
            Container(
              margin: EdgeInsets.all(24.h),
              width: double.infinity,
              height: 120.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyPill(type: MyPillType.PRIMARY_FILLED_TRANSPARENT,label: 'Barbearia',),
                  MyLabel(
                    type: MyLabelType.H5,
                    fontWeight: MyLabel.BOLD,
                    label: 'Porta 54',
                  ),
                  Row(
                    children: [

                      Icon(Icons.location_on,size: 16.sp,color: blue,),
                      SizedBox(width: 6.w,),
                      MyLabel(
                        type: MyLabelType.BODY_XLARGE,
                        fontWeight: MyLabel.MEDIUM,
                        label: 'Porto, Paços de Ferreira',
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: onTap,
    );*/
  }


}