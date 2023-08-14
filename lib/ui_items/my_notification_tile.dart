

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

class MyNotificationTile extends ConsumerWidget {

  final MyNotificationTileType type;
  final int index;

  const MyNotificationTile({super.key, required this.type,required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyNotificationTileType.GENERAL:
        return generalNotificationTile(index);
      default:
        return Container();
    }
  }

  Widget generalNotificationTile(int index){
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundColor: lightBlue,
              child: IconButton(
                icon: Icon(
                  IconlyBold.calendar,
                  size: 28.sp,
                  color: blue,
                ),
                onPressed: null,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabel(
                  type: MyLabelType.H5,
                  fontWeight: MyLabel.BOLD,
                  label: 'Appointment Success!',
                ),
                SizedBox(height: 6.h),
                MyLabel(
                  type: MyLabelType.BODY_MEDIUM,
                  fontWeight: MyLabel.MEDIUM,
                  label: '19 Dec, 2022 | 18:35 PM',
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: MyLabel(
                type: MyLabelType.BODY_MEDIUM,
                fontWeight: MyLabel.NORMAL,
                label: 'You have successfully booked an appointment with Dr. Alan Watson on December 24, 2024, 10:00 am. Don'
                    '\'t forget to activate your reminder.',
                color: grey800,
              ),
            ),
          ],
        )
      ],
    );
  }
}