
import 'dart:async';
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/view_model/make_appointment_screen/make_appointment_screen_view_model_imp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../model/service_model.dart';
import '../../../../../model/user_model.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_choose_professional_tile.dart';
import '../../../../../ui_items/my_exception.dart';
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

  @override
  bool get wantKeepAlive => true;

  late Future<List<UserModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _getUsersByShopFirebase();
  }

  Future<List<UserModel>> _getUsersByShopFirebase() async{
    List<UserModel> list = await ChooseProfessionalViewModelImp().getUsersByShopFromFirebase(ref);
    MakeAppointmentScreenViewModelImp().setValue(listProfessionals.notifier, ref, list);
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

  Widget _professionalsListShimmer(){
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 24.h),
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return MyChooseProfessionalTile(type: MyChooseProfessionalTileType.SHIMMER);
        }
    );
  }

  Widget _professionalsList(List<UserModel> list){

    String shopName = ref.read(currentShopProvider).name;

    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemCount: list.length,
        itemBuilder: (context, index) {

          UserModel user = list[index];

          return MyChooseProfessionalTile(
              type: MyChooseProfessionalTileType.GENERAL,
              user: user,
              shopName: shopName,
              index: index,
              onTap: (){

                if(ref.read(currentProfessionalIndexProvider) != -1 && ref.read(currentProfessionalIndexProvider) != index){
                  ChooseProfessionalViewModelImp().setValue(listServices.notifier, ref, <ServiceModel>[]);
                }

                ChooseProfessionalViewModelImp().setValue(currentProfessionalProvider.notifier, ref, user);
                ChooseProfessionalViewModelImp().setValue(currentProfessionalIndexProvider.notifier, ref, index);


                Timer(Duration(milliseconds: TRANSITION_DURATION), () {
                  ChooseProfessionalViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 1);
                });

                print('indexMakeAppointmentProvider -> ' + ref.read(currentAppointmentIndexProvider).toString());
              }
          );
        }
    );
  }

  Widget mobileBody(){

    List<UserModel> list = ref.read(listProfessionals);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: list.isEmpty ? FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _professionalsListShimmer();
          } else if (snapshot.hasError) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'No professionals available',);
          } else {
            List<UserModel> list = snapshot.data!;

            return _professionalsList(list);
          }
        }
      ) : _professionalsList(list)
    );
  }

}