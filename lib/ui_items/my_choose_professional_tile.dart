

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

class MyChooseProfessionalTile extends ConsumerWidget {

  final MyChooseProfessionalTileType type;
  final int index;
  final Function()? onTap;


  const MyChooseProfessionalTile({super.key, required this.type,required this.index, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyChooseProfessionalTileType.GENERAL:
        return generalChooseProfessionalTile(index,onTap);
      default:
        return Container();
    }

  }

  Widget generalChooseProfessionalTile(int index,Function()? onTap){


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
                      index == 0 ? 'images/barber_1.jpg' :
                      index == 1 ? 'images/barber_2.jpg' :
                      index == 2 ? 'images/barber_3.jpg' :
                      index == 3 ? 'images/barber_4.jpg' :
                      index == 4 ? 'images/barber_5.jpg' :
                      index == 5 ? 'images/barber_6.jpg' :
                      index == 6 ? 'images/barber_7.jpg' :
                      'images/girl.jpg',
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

                  MyLabel(
                    type: MyLabelType.BODY_XSMALL,
                    label: 'Porta 54',
                    fontWeight: MyLabel.MEDIUM,
                    color: index == 1 ? grey300 : grey800,
                  ),

                  SizedBox(height: 8.h,),

                  MyLabel(
                    type: MyLabelType.H6,
                    label: 'Jenny Watson',
                    fontWeight: MyLabel.BOLD,
                    color: index == 1 ? light1 : grey800,
                  ),

                  SizedBox(height: 8.h,),

                  MyPill(type: MyPillType.PRIMARY_FILLED_TRANSPARENT,label: 'Barbeiro',),



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