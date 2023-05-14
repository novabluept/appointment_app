

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyProfileTile extends ConsumerWidget {

  final MyProfileTileType type;
  final IconData icon;
  final String label;
  final bool isLogout;
  final Function()? onTap;


  const MyProfileTile({super.key, required this.type, required this.icon, required this.label,this.isLogout = false, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyProfileTileType.GENERAL:
        return generalProfileTile();
      default:
        return Container();
    }

  }

  Widget generalProfileTile(){

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,size: 28.sp,color: isLogout ? red : black),
              SizedBox(width: 20.w,),
              MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.SEMI_BOLD,
                label: label,
                color: isLogout ? red : black,
              ),
            ],
          ),
          Icon(IconlyLight.arrow_right_2,size: 28.sp,color: isLogout ? red : black),
        ],
      ),
    );
  }


}