

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
import 'my_pill.dart';

class MyChooseShopTile extends ConsumerWidget {

  final MyChooseShopTileType type;
  final int index;
  final Function()? onTap;


  const MyChooseShopTile({super.key, required this.type,required this.index, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseShopTileType.GENERAL:
        return generalChooseShopTile(index,onTap);
      default:
        return Container();
    }

  }

  Widget generalChooseShopTile(int index,Function()? onTap){


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
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16).r,
                    child: Image.asset(
                      index == 0 ? 'images/barbershop_1.png' :
                      'images/barbershop_4.png',
                      width: 110.h,
                      height: 110.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 16.w,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.location_on,size: 10.sp,color: index == 1 ? light1 : blue,),
                      SizedBox(width: 6.w,),
                      MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: 'Porto, Paços de Ferreira',
                        fontWeight: MyLabel.MEDIUM,
                        color: index == 1 ? grey300 : grey800,
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h,),

                  MyLabel(
                    type: MyLabelType.H6,
                    label: 'Porta 54',
                    fontWeight: MyLabel.BOLD,
                    color: index == 1 ? light1 : grey800,
                  ),

                  SizedBox(height: 8.h,),

                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    label: 'Obter direções',
                    fontWeight: MyLabel.MEDIUM,
                    color: index == 1 ? grey300 : blue,
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
}