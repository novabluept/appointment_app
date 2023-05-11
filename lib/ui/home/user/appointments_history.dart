
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/appointments_upcoming.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_responsive_layout.dart';
import 'appointments_history/appointments_cancelled.dart';

class AppointmentsHistory extends ConsumerStatefulWidget {
  const AppointmentsHistory({Key? key}): super(key: key);

  @override
  AppointmentsHistoryState createState() => AppointmentsHistoryState();
}

class AppointmentsHistoryState extends ConsumerState<AppointmentsHistory> {
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: white,
        appBar: const MyAppBar(
          type: MyAppBarType.BOTTOM_TAB,
          label: 'Forgot password',
          height: kToolbarHeight * 2,
          isTabBar: true,
        ),
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),)
      ),
    );
  }

  Widget mobileBody(){
    return const TabBarView(
      children: [AppointmentsUpcoming(),AppointmentsCompleted(),AppointmentsCancelled()],
    );
  }
  
}