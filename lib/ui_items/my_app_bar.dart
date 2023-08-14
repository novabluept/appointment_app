import 'package:appointment_app_v2/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../style/general_style.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {

  final MyAppBarType type;
  final double height;
  final IconData? leadingIcon;
  final IconData? suffixIcon;
  final String? label;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isTabBar;
  final Color? backgroundColor;
  final UserModel? user;
  final Function()? onTap;

  const MyAppBar({super.key, required this.type, this.height = kToolbarHeight, this.leadingIcon, this.suffixIcon,
    this.label, this.scaffoldKey, this.isTabBar = false, this.backgroundColor,this.user,this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyAppBarType.GENERAL:
        return generalAppBar(label!,null,null,backgroundColor,isTabBar);
      case MyAppBarType.LEADING_ICON:
        return generalAppBar(label!,leadingIcon!,null,backgroundColor,isTabBar);
      case MyAppBarType.BOTTOM_TAB:
        return generalAppBar(label!,null,null,backgroundColor,isTabBar);
      case MyAppBarType.LEADING_SUFFIX_ICON:
        return homeAppBar(label!,leadingIcon!,suffixIcon!,backgroundColor,isTabBar,user!);
      default:
        return Container();
    }
  }

  Widget generalAppBar(String label,IconData? leadingIcon,IconData? suffixIcon,Color? backgroundColor,bool isTabBar) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.sp),
      child: AppBar(
        backgroundColor: backgroundColor != null ? backgroundColor : light1,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: leadingIcon != null ? 0 : 24.w,
        leadingWidth: 48.w,
        centerTitle: false,
        leading: leadingIcon != null ? GestureDetector(
            onTap: onTap,
            child: Icon(leadingIcon, size: 20.sp, color: dark1)
        ) : null,
        title: MyLabel(
          type: MyLabelType.H4,
          fontWeight: MyLabel.BOLD,
          label: label,
        ),
        bottom: isTabBar ? TabBar(
          labelStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 18.sp,
            fontWeight: MyLabel.SEMI_BOLD,
          ),
          labelColor: blue,
          unselectedLabelColor: grey500,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: blue,
          indicatorWeight: 4.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
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


  Widget homeAppBar(String label,IconData? leadingIcon,IconData? suffixIcon,Color? backgroundColor,bool isTabBar,UserModel user) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.sp),
      child: AppBar(
        backgroundColor: backgroundColor ?? light1,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leadingWidth: 80.w,
        centerTitle: false,
        leading: IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(16).r,
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
              user.imageUnit8list!,
              width: 30.w,
              height: 30.w,
              fit: BoxFit.cover
            ),
          ),
          onPressed: null,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: GestureDetector(
              onTap: onTap,
              child: Icon(
                  IconlyLight.notification,size: 28.sp,color: dark1
              ),
            )
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.sp);
}