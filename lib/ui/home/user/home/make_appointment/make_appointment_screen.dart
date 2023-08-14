
import 'dart:async';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/method_helper.dart';
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

  final List<Widget> _pages = [
    const ChooseProfessional(),
    const ChooseService(),
    const ChooseSchedule(),
  ];

  late var _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint('indexMakeAppointmentProvider: ${ref.read(currentAppointmentIndexProvider)}');
    _controller = TabController(length: _pages.length, initialIndex: ref.watch(currentAppointmentIndexProvider), vsync: this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles navigation back or resetting appointment-related variables.
  ///
  /// This function determines whether to navigate back to the previous screen or reset appointment-related variables and then navigate back. It uses the values from the [currentAppointmentIndexProvider] and [isNavigationFromHomeProvider] to make decisions. If the [index] of the current appointment is greater than 0 and the navigation is not from the home screen, it decrements the [index] using [MakeAppointmentScreenViewModelImp]. Otherwise, it pops the current screen and after a delay of [TRANSITION_DURATION] milliseconds, it cleans up appointment-related variables using [MethodHelper.cleanAppointmentsVariables].
  void _goBack() {
    int index = ref.read(currentAppointmentIndexProvider);
    bool isNavigationFromHome = ref.read(isNavigationFromHomeProvider);

    if (index > 0 && !isNavigationFromHome) {
      MakeAppointmentScreenViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, --index);
    } else {
      // Pop the current screen
      Navigator.of(context).pop();

      // Clean up appointment-related variables after a delay
      Timer(const Duration(milliseconds: TRANSITION_DURATION), () {
        MethodHelper.cleanAppointmentsVariables(ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        _goBack();
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
            onTap: _goBack,
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
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: _pages,
        );
      },
    );
  }


}