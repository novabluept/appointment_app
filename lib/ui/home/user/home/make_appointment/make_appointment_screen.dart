
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui_items/my_choose_service_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../../model/service_model.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_choose_professional_tile.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
import '../../../../../utils/validators.dart';
import '../../../../../view_model/choose_service/choose_service_view_model_imp.dart';
import '../../../../../view_model/make_appointment_screen/make_appointment_screen_view_model_imp.dart';
import 'choose_professional.dart';
import 'choose_schedule.dart';
import 'choose_service.dart';

class ChooseScreen extends ConsumerStatefulWidget {
  const ChooseScreen({Key? key}): super(key: key);

  @override
  ChooseScreenState createState() => ChooseScreenState();
}

class ChooseScreenState extends ConsumerState<ChooseScreen> with TickerProviderStateMixin{

  List<Widget> _pages = [
    ChooseProfessional(),
    ChooseService(),
    ChooseSchedule(),
  ];

  late var _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('indexMakeAppointmentProvider: ' + ref.read(currentAppointmentIndexProvider).toString());
    _controller = TabController(length: _pages.length, initialIndex: ref.watch(currentAppointmentIndexProvider), vsync: this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        /// Este codigo esta igual ao de baixo por causa do back nativo
        int index = ref.read(currentAppointmentIndexProvider);
        if(index > 0){
          MakeAppointmentScreenViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, --index);
        }else{
          Navigator.of(context).pop();
          MethodHelper.cleanAppointmentsVariables(ref);
        }

        return false;
      },
      child: Scaffold(
          backgroundColor: grey50,
          resizeToAvoidBottomInset : true,
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: IconlyLight.arrow_left,
            backgroundColor: grey50,
            label: ref.watch(currentAppointmentIndexProvider) == 0 ? 'Choose Professional' :
            ref.watch(currentAppointmentIndexProvider) == 1 ? 'Choose Service' :
            ref.watch(currentAppointmentIndexProvider) == 2 ? 'Choose Schedule' : '',
            onTap: (){
              int index = ref.read(currentAppointmentIndexProvider);
              if(index > 0){
                MakeAppointmentScreenViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, --index);
              }else{
                Navigator.of(context).pop();
                MethodHelper.cleanAppointmentsVariables(ref);
              }
            },
          ),
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {

        final index = ref.watch(currentAppointmentIndexProvider);
        _controller = TabController(length: _pages.length, initialIndex: index, vsync: this);

        return TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: _pages,
        );
      },
    );
  }


}