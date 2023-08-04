
import 'dart:async';
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_professional.dart';
import 'package:appointment_app_v2/ui/home/user/home/content/choose_schedule.dart';
import 'package:appointment_app_v2/ui_items/my_choose_service_tile.dart';
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

import '../../../../../model/service_model.dart';
import '../../../../../state_management/appointments_state.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_choose_professional_tile.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
import '../../../../../utils/validators.dart';
import '../../../../../view_model/choose_service/choose_service_view_model_imp.dart';

class ChooseService extends ConsumerStatefulWidget {
  const ChooseService({Key? key}): super(key: key);

  @override
  ChooseServiceState createState() => ChooseServiceState();
}

class ChooseServiceState extends ConsumerState<ChooseService> with AutomaticKeepAliveClientMixin {

  late Future<List<ServiceModel>> _future;


  @override
  void initState() {
    _future = _getServicesByUserIdAndShopIdFromDB();
    super.initState();
  }

  Future<List<ServiceModel>> _getServicesByUserIdAndShopIdFromDB() async{
    String userId = ref.read(currentProfessionalProvider).userId;
    String shopId = ref.read(currentShopProvider).shopId;
    List<ServiceModel> list = await ChooseServiceViewModelImp().getServicesByUserIdAndShopIdFromFirebase(userId,shopId);
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
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return MyChooseServiceTile(type: MyChooseServiceTileType.SHIMMER);
                },
              );

            } else if (snapshot.hasError) {
              return MyException(type: MyExceptionType.NO_DATA,imagePath: 'images/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return MyException(type: MyExceptionType.NO_DATA,imagePath: 'images/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'No services available',);
            } else {

              List<ServiceModel> list = snapshot.data!;

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: list.length,
                itemBuilder: (context, index) {

                  ServiceModel service = list[index];

                  return MyChooseServiceTile(
                    type: MyChooseServiceTileType.GENERAL,
                    index: index,
                    service: service,
                    onTap: (){
                      ChooseServiceViewModelImp().setValue(currentServiceProvider.notifier, ref, service);
                      ChooseServiceViewModelImp().setValue(currentServiceIndexProvider.notifier, ref, index);

                      Timer(Duration(milliseconds: TRANSITION_DURATION), () {
                        ChooseServiceViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 2);
                      });
                    }
                  );
                },
              );
            }
          },
        )

    );
  }

  @override
  bool get wantKeepAlive => true;

}