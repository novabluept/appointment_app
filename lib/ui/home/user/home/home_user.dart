
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_professional.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../../ui_items/my_button.dart';
import '../../../../../../ui_items/my_label.dart';
import '../../../../../../ui_items/my_responsive_layout.dart';
import '../../../../ui_items/my_app_bar.dart';
import '../../../../ui_items/my_home_shop.dart';
import '../../../../ui_items/my_pill.dart';
import 'choose_shop.dart';

class HomeUser extends ConsumerStatefulWidget {
  const HomeUser({Key? key}): super(key: key);

  @override
  HomeUserState createState() => HomeUserState();
}

class HomeUserState extends ConsumerState<HomeUser> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey50,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_SUFFIX_ICON,
          label: 'Profile',
          backgroundColor: grey50,
          height: kToolbarHeight,
          leadingIcon: IconlyLight.notification,
          suffixIcon: IconlyLight.notification,
        ),
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),)
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: MyLabel(
              type: MyLabelType.H2,
              fontWeight: MyLabel.BOLD,
              label: 'It\'s time to book your next appointment',
              color: blue,
            ),
          ),

          SizedBox(height: 96.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyLabel(
                type: MyLabelType.H5,
                fontWeight: MyLabel.BOLD,
                label: 'Featured',
              ),
              GestureDetector(
                onTap: (){
                  pushNewScreen(
                    context,
                    screen: ChooseShop(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: MyLabel(
                  type: MyLabelType.BODY_LARGE,
                  fontWeight: MyLabel.BOLD,
                  label: 'See all',
                  color: blue,
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h,),

          MyHomeShop(
            type: MyHomeShopType.GENERAL,
            onTap: (){
              pushNewScreen(
                context,
                screen: ChooseProfessional(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),

          SizedBox(height: 24.h,)
        ],
      )

    );
  }

}