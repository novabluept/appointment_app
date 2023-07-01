
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_service.dart';
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

import '../../../../../model/user_model.dart';
import '../../../../../state_management/state.dart';
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
import '../../../../../view_model/choose_professional/choose_professional_view_model_imp.dart';

class ChooseProfessional extends ConsumerStatefulWidget {
  const ChooseProfessional({Key? key}): super(key: key);

  @override
  ChooseProfessionalState createState() => ChooseProfessionalState();
}

class ChooseProfessionalState extends ConsumerState<ChooseProfessional> with AutomaticKeepAliveClientMixin {


  late Future<List<UserModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _getUsersByShopFirebase();
  }

  Future<List<UserModel>> _getUsersByShopFirebase() async{
    List<UserModel> list = await ChooseProfessionalViewModelImp().getUsersByShopFromFirebase(ref);
    return await Future.delayed(Duration(milliseconds: LOAD_DATA_DURATION), () => list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey50,
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 24.h),
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemCount: 5,
              itemBuilder: (context, index) {
                return MyChooseProfessionalTile(type: MyChooseProfessionalTileType.SHIMMER);
              }
            );

          } else if (snapshot.hasError) {
            return Container(child: Text('error'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(child: Text('no data or empty'));
          } else {

            List<UserModel> list = snapshot.data!;
            String shopName = ref.read(currentShopProvider).name;

            return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: list.length,
                itemBuilder: (context, index) {

                  UserModel user = list[index];

                  return MyChooseProfessionalTile(
                    type: MyChooseProfessionalTileType.GENERAL,
                    image: user.imageUnit8list,
                    firstName: user.firstname,
                    lastName: user.lastname,
                    shopName: shopName,
                    index: index,
                    onTap: (){
                      ChooseProfessionalViewModelImp().setValue(currentUserProvider.notifier, ref, user);
                      ChooseProfessionalViewModelImp().setValue(indexMakeAppointmentProvider.notifier, ref, 1);
                      print('indexMakeAppointmentProvider -> ' + ref.read(indexMakeAppointmentProvider).toString());
                    }
                );
              }
            );

          }
        }
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}