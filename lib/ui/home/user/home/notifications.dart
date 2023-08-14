
import 'package:appointment_app_v2/ui_items/my_notification_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_responsive_layout.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({Key? key}): super(key: key);

  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends ConsumerState<Notifications> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          backgroundColor: grey50,
          resizeToAvoidBottomInset : true,
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: IconlyLight.arrow_left,
            backgroundColor: grey50,
            label: 'Notifications',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          separatorBuilder: (context, index) => SizedBox(height: 24.h),
          itemCount: 10,
          itemBuilder: (context, index) {
            return MyNotificationTile(type: MyNotificationTileType.GENERAL,index: index);
          },
        )
    );
  }

}