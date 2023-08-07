
import 'dart:async';
import 'dart:io';

import 'package:appointment_app_v2/model/service_model.dart';
import 'package:appointment_app_v2/state_management/make_appointments_state.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_choose_professional_tile.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
import '../../../../../utils/validators.dart';
import '../../../../model/shop_model.dart';
import '../../../../model/user_model.dart';
import '../../../../state_management/choose_shop_state.dart';
import '../../../../state_management/home_user_state.dart';
import '../../../../ui_items/my_choose_shop_tile.dart';
import '../../../../ui_items/my_exception.dart';
import '../../../../view_model/choose_shop/choose_shop_view_model_imp.dart';
import '../../../../view_model/home_user/home_user_view_model_imp.dart';

class ChooseShop extends ConsumerStatefulWidget {
  const ChooseShop({Key? key}): super(key: key);

  @override
  ChooseShopState createState() => ChooseShopState();
}

class ChooseShopState extends ConsumerState<ChooseShop> {

  Future<List<ShopModel>> _getShopsFromFirebase() async{
    List<ShopModel> list = [];
    list = await HomeUserModelImp().getShopsFromFirebase();
    return await Future.delayed(Duration(milliseconds: LOAD_DATA_DURATION), () => list);
  }

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
            onTap: (){
              ChooseShopViewModelImp().setValue(currentShopProvider.notifier, ref, shop);
              ChooseShopViewModelImp().setValue(currentShopIndexProvider.notifier, ref, index);

              ChooseShopViewModelImp().setValue(listProfessionals.notifier, ref, <UserModel>[]);
              ChooseShopViewModelImp().setValue(listServices.notifier, ref, <ServiceModel>[]);

              Timer(Duration(milliseconds: TRANSITION_DURATION), () {
                Navigator.of(context).pop();
              });

            }
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