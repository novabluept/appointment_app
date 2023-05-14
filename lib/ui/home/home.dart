
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_history.dart';
import 'package:appointment_app_v2/ui/home/user/home/home_user.dart';
import 'package:appointment_app_v2/ui/home/user/profile/profile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/view_model/home/home_view_model_imp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_app_bar.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';


class Home extends ConsumerStatefulWidget {
  const Home({Key? key}): super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildScreensTest() {
    return [
      Container(color: Colors.green,),
      Container(color: Colors.yellow,),
    ];
  }

  List<Widget> _buildScreensUser() {
    return [
      HomeUser(),
      AppointmentsHistory(),
      Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsTest() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.home,size: 24.sp,),
        inactiveIcon: Icon(IconlyLight.home,size: 24.sp,),
        title: "Home",
        textStyle: GoogleFonts.urbanist(fontSize: 10.sp,fontWeight: MyLabel.MEDIUM),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.calendar,size: 24.sp,),
        inactiveIcon: Icon(IconlyLight.calendar,size: 24.sp,),
        title: "Appointments",
        textStyle: GoogleFonts.urbanist(fontSize: 10.sp,fontWeight: MyLabel.MEDIUM),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsUser() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.home,size: 24.sp,),
        inactiveIcon: Icon(IconlyLight.home,size: 24.sp,),
        title: "Home",
        textStyle: GoogleFonts.urbanist(fontSize: 10.sp,fontWeight: MyLabel.MEDIUM),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.calendar,size: 24.sp,),
        inactiveIcon: Icon(IconlyLight.calendar,size: 24.sp,),
        title: "Appointments",
        textStyle: GoogleFonts.urbanist(fontSize: 10.sp,fontWeight: MyLabel.MEDIUM),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.profile,size: 24.sp,),
        inactiveIcon: Icon(IconlyLight.profile,size: 24.sp,),
        title: "Profile",
        textStyle: GoogleFonts.urbanist(fontSize: 10.sp,fontWeight: MyLabel.MEDIUM),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        print('hrello');
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return FutureBuilder(
      future: HomeViewModelImp().getUserRole(),
      builder: (BuildContext context, AsyncSnapshot<UserRole> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('waiting');
        }else if(snapshot.hasError){
          return Text('has error');
        }else{

          UserRole? role = snapshot.data;

          List<Widget> screens = role == UserRole.USER ? _buildScreensUser() : _buildScreensTest();
          List<PersistentBottomNavBarItem> navBarsItems = role == UserRole.USER ? _navBarsItemsUser() : _navBarsItemsTest();

          return PersistentTabView(
            context,
            controller: _controller,
            screens: screens,
            items: navBarsItems,
            navBarHeight: kBottomNavigationBarHeight.h,
            confineInSafeArea: true,
            backgroundColor: white, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              colorBehindNavBar: white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.simple, // Choose the nav bar style with this property.
          );
        }
      },
    );
  }
}