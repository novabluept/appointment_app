
import 'package:appointment_app_v2/state_management/home_user_state.dart';
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui/home/user/home/notifications.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../../ui_items/my_button.dart';
import '../../../../../../ui_items/my_label.dart';
import '../../../../../../ui_items/my_responsive_layout.dart';
import '../../../../model/shop_model.dart';
import '../../../../state_management/choose_shop_state.dart';
import '../../../../ui_items/my_app_bar.dart';
import '../../../../ui_items/my_exception.dart';
import '../../../../ui_items/my_home_shop.dart';
import '../../../../ui_items/my_pill.dart';
import '../../../../utils/constants.dart';
import '../../../../view_model/home_user/home_user_view_model_imp.dart';
import 'choose_shop.dart';
import 'make_appointment/make_appointment_screen.dart';

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

  Future<List<ShopModel>> _getShopsFromFirebase() async{
    List<ShopModel> list = [];
    list = await HomeUserModelImp().getShopsFromFirebase();
    HomeUserModelImp().setValue(listShops.notifier, ref, list);
    /// Selecionar a shop
    ShopModel shop = ref.read(currentShopProvider) != ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',professionals: []) ? ref.read(currentShopProvider) : list[0];

    HomeUserModelImp().setValue(currentShopProvider.notifier,ref,shop);
    return await Future.delayed(Duration(milliseconds: LOAD_DATA_DURATION), () => list);
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
          onTap: (){
            pushNewScreen(
              context,
              screen: Notifications(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  Widget _shopsShimmer(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: grey300,
              highlightColor: grey100,
              child: MyLabel(
                type: MyLabelType.H5,
                fontWeight: MyLabel.BOLD,
                label: 'Featured',
              ),
            ),
            Shimmer.fromColors(
              baseColor: grey300,
              highlightColor: grey100,
              child: MyLabel(
                type: MyLabelType.BODY_LARGE,
                fontWeight: MyLabel.BOLD,
                label: 'See all',
                color: blue,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),

        MyHomeShop(type: MyHomeShopType.SHIMMER),

      ],
    );
  }

  Widget _shopsList(List<ShopModel> list){

    ShopModel shop = ref.watch(currentShopProvider) != ShopModel(imagePath: '', imageUnit8list: null, name: '', city: '', state: '', streetName: '', zipCode: '',professionals: []) ? ref.read(currentShopProvider) : list[0];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyLabel(
              type: MyLabelType.H5,
              fontWeight: MyLabel.BOLD,
              label: 'Featured',
            ),
            GestureDetector(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: ChooseShop(),
                  withNavBar: false,
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

        SizedBox(height: 24.h),

        MyHomeShop(
          type: MyHomeShopType.GENERAL,
          image: shop.imageUnit8list,
          name: shop.name,
          city: shop.city,
          state: shop.state,
          onTap: () {
            pushNewScreen(
              context,
              screen: ChooseScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
      ],
    );
  }

  Widget mobileBody(){

    List<ShopModel> list = ref.watch(listShops);

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

          SizedBox(height: 96.h),



          list.isEmpty ? FutureBuilder(
            future: _getShopsFromFirebase(),
            builder: (BuildContext context, AsyncSnapshot<List<ShopModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _shopsShimmer();
              } else if (snapshot.hasError) {
                return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(child: Text('no data or empty'));
              } else {
                List<ShopModel> list = snapshot.data!;
                return _shopsList(list);
              }
            }
          ) : _shopsList(list),

          SizedBox(height: 24.h)
        ],
      )

    );
  }

}