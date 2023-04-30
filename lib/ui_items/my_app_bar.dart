import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';



class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {

  final MyAppBarType type;
  final double height;
  final IconData? leadingIcon;
  final String? label;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function()? onTap;

  const MyAppBar({super.key, required this.type, this.height = kToolbarHeight, this.leadingIcon, this.label, this.scaffoldKey, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyAppBarType.GENERAL:
        return generalAppBar(label!,null);
      case MyAppBarType.LEADING_ICON:
        return generalAppBar(label!,leadingIcon!);
      default:
        return Container();
    }
  }

  Widget generalAppBar(String label,IconData? leadingIcon) {
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
      ),
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(height.sp);
}