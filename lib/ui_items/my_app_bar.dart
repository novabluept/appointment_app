import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';



class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {

  final MyAppBarType type;
  final double height;
  final IconData? leadingIcon;
  final String? label;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isTabBar;
  final Function()? onTap;

  const MyAppBar({super.key, required this.type, this.height = kToolbarHeight, this.leadingIcon,
    this.label, this.scaffoldKey, this.isTabBar = false,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyAppBarType.GENERAL:
        return generalAppBar(label!,null,isTabBar);
      case MyAppBarType.LEADING_ICON:
        return generalAppBar(label!,leadingIcon!,isTabBar);
      case MyAppBarType.BOTTOM_TAB:
        return generalAppBar(label!,null,isTabBar);
      default:
        return Container();
    }
  }

  Widget generalAppBar(String label,IconData? leadingIcon,bool isTabBar) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.sp),
      child: AppBar(
        backgroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leadingIcon != null ? GestureDetector(
            onTap: onTap,
            child: Icon(leadingIcon, size: 20.sp, color: black,)
        ) : null,
        title: MyLabel(
          type: MyLabelType.H4,
          fontWeight: MyLabel.BOLD,
          label: label,
        ),
        bottom: isTabBar ? TabBar(
          labelStyle: GoogleFonts.urbanist(fontSize: 18.sp,fontWeight: MyLabel.SEMI_BOLD),
          labelColor: blue,
          unselectedLabelColor: grey500,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: blue,
          indicatorWeight: 4.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w,),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashBorderRadius: BorderRadius.circular(100).r,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled')
          ],
        ) : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.sp);
}