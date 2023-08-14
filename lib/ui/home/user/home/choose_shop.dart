
import 'dart:async';
import 'package:appointment_app_v2/model/service_model.dart';
import 'package:appointment_app_v2/state_management/make_appointments_state.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../utils/constants.dart';
import '../../../../model/shop_model.dart';
import '../../../../model/user_model.dart';
import '../../../../state_management/choose_shop_state.dart';
import '../../../../state_management/home_user_state.dart';
import '../../../../ui_items/my_choose_shop_tile.dart';
import '../../../../view_model/choose_shop/choose_shop_view_model_imp.dart';

class ChooseShop extends ConsumerStatefulWidget {
  const ChooseShop({Key? key}): super(key: key);

  @override
  ChooseShopState createState() => ChooseShopState();
}

class ChooseShopState extends ConsumerState<ChooseShop> {

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
            label: 'Choose Shop',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  /// Handles selecting a shop.
  ///
  /// This function is called when a user selects a shop. It takes the selected [shop] and its [index] in the list of shops. It sets the [shop] as the current shop using [ChooseShopViewModelImp] and updates the [currentShopIndexProvider]. It also clears the lists of professionals and services associated with the shop. After a delay of [TRANSITION_DURATION] milliseconds, it navigates back to the previous screen.
  void _chooseShop(ShopModel shop, int index) {
    ChooseShopViewModelImp().setValue(currentShopProvider.notifier, ref, shop);
    ChooseShopViewModelImp().setValue(currentShopIndexProvider.notifier, ref, index);

    // Clear the lists of professionals and services
    ChooseShopViewModelImp().setValue(listProfessionals.notifier, ref, <UserModel>[]);
    ChooseShopViewModelImp().setValue(listServices.notifier, ref, <ServiceModel>[]);

    // Navigate back after a delay
    Timer(Duration(milliseconds: TRANSITION_DURATION), () {
      Navigator.of(context).pop();
    });
  }

  Widget _shopsList(List<ShopModel> list){
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: list.length,
      itemBuilder: (context, index) {
        ShopModel shop = list[index];
        return MyChooseShopTile(
          type: MyChooseShopTileType.GENERAL,
          index: index,
          shop: shop,
          onTap: ()=> _chooseShop(shop,index)
        );
      },
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: _shopsList(ref.read(listShops))
    );
  }

}