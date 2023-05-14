
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';

class AppointmentsUpcoming extends ConsumerStatefulWidget {
  const AppointmentsUpcoming({Key? key}): super(key: key);

  @override
  AppointmentsUpcomingState createState() => AppointmentsUpcomingState();
}

class AppointmentsUpcomingState extends ConsumerState<AppointmentsUpcoming> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),);
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 20.h,),
        itemCount: 10,
        itemBuilder: (context, index) {
          if(index == 0){
            return Padding(padding: EdgeInsets.only(top: 24.h),child: MyAppointmentTile(type: MyAppointmentTileType.GENERAL,hasButtons: true,));
          } else if(index == 10 - 1){
            return Padding(padding: EdgeInsets.only(bottom: 24.h),child: MyAppointmentTile(type: MyAppointmentTileType.GENERAL,hasButtons: true,));
          }else {
            return MyAppointmentTile(type: MyAppointmentTileType.GENERAL,hasButtons: true,);
          }
        },
      )
    );
  }

}