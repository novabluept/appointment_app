
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_history.dart';
import 'package:appointment_app_v2/ui/home/user/home/home_user.dart';
import 'package:appointment_app_v2/ui/home/user/profile/profile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../data_ref/users_ref.dart';
import '../../state_management/persistent_bottom_navbar_state.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';
import '../../view_model/persistent_bottom_navbar/persistent_bottom_navbar_view_model_imp.dart';

class PersistentBottomNavbar extends ConsumerStatefulWidget {
  const PersistentBottomNavbar({Key? key}): super(key: key);

  @override
  PersistentBottomNavbarState createState() => PersistentBottomNavbarState();
}

class PersistentBottomNavbarState extends ConsumerState<PersistentBottomNavbar> {

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
      Container(color: Colors.green,child: TextButton(child: Text("sair"),onPressed: () async{
        await FirebaseAuth.instance.signOut();
      },),),
      Container(color: Colors.yellow),
    ];
  }

  List<Widget> _buildScreensUser() {
    return [
      const HomeUser(),
      const AppointmentsHistory(),
      const Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsTest() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.home,size: 24.sp),
        inactiveIcon: Icon(IconlyLight.home,size: 24.sp),
        title: "Home",
        textStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 10.sp,
          fontWeight: MyLabel.MEDIUM,
        ),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.calendar,size: 24.sp),
        inactiveIcon: Icon(IconlyLight.calendar,size: 24.sp),
        title: "Appointments",
        textStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 10.sp,
          fontWeight: MyLabel.MEDIUM,
        ),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsUser() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.home,size: 24.sp),
        inactiveIcon: Icon(IconlyLight.home,size: 24.sp),
        title: "Home",
        textStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 10.sp,
          fontWeight: MyLabel.MEDIUM,
        ),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.calendar,size: 24.sp),
        inactiveIcon: Icon(IconlyLight.calendar,size: 24.sp),
        title: "Appointments",
        textStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 10.sp,
          fontWeight: MyLabel.MEDIUM,
        ),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconlyBold.profile,size: 24.sp),
        inactiveIcon: Icon(IconlyLight.profile,size: 24.sp),
        title: "Profile",
        textStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 10.sp,
          fontWeight: MyLabel.MEDIUM,
        ),
        activeColorPrimary: blue,
        inactiveColorPrimary: grey500,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }


  Future<UserRole> getUserStatusAndSetImage(WidgetRef ref) async{
    UserRole role = await PersistentBottomNavbarViewModelImp().getUserStatusAndSetImage(ref);
    return role;
  }


  Widget mobileBody(){
    return FutureBuilder(
      future: getUserStatusAndSetImageRef(ref),
      builder: (BuildContext context, AsyncSnapshot<UserRole> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SpinKitRing(
              color: blue,
              size: 60.w,
            ),
          );
        }else if(snapshot.hasError){
          return const Text('has error');
        }else{

          UserRole? role = snapshot.data;

          List<Widget> screens = role == UserRole.USER ? _buildScreensUser() : _buildScreensTest();
          List<PersistentBottomNavBarItem> navBarsItems = role == UserRole.USER ? _navBarsItemsUser() : _navBarsItemsTest();

          return PersistentTabView(
            context,
            controller: ref.watch(controllerPersistentBottomNavbarProvider),
            screens: screens,
            items: navBarsItems,
            navBarHeight: kBottomNavigationBarHeight.h,
            confineInSafeArea: true,
            backgroundColor: light1, // Default is light1.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              colorBehindNavBar: light1,
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