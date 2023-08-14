
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../data_ref/appointment_ref.dart';
import '../../../../../model/appointment_model.dart';
import '../../../../../ui_items/my_appointment_tile.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';

class AppointmentsCancelled extends ConsumerStatefulWidget {
  const AppointmentsCancelled({Key? key}): super(key: key);

  @override
  AppointmentsHistoryState createState() => AppointmentsHistoryState();
}

class AppointmentsHistoryState extends ConsumerState<AppointmentsCancelled> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody());
  }

  Widget _cancelledAppointmentListShimmer(){
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const MyAppointmentTile(
          type: MyAppointmentTileType.SHIMMER,
        );
      },
    );
  }

  Widget _cancelledAppointmentList(List<AppointmentModel> list){
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: list.length,
      itemBuilder: (context, index) {
        AppointmentModel appointment = list[index];
        return MyAppointmentTile(
          type: MyAppointmentTileType.CANCELLED,
          index: index,
          appointment: appointment,
        );
      },
    );
  }

  Widget mobileBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: StreamBuilder(
          stream: getAppointmentsByUserRef(AppointmentStatus.CANCELLED),
          builder: (BuildContext context, AsyncSnapshot<List<AppointmentModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _cancelledAppointmentListShimmer();
            } else if (snapshot.hasError) {
              return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'You have no appointments cancelled at the moment.',);
            } else {
              List<AppointmentModel> list = snapshot.data!;
              return _cancelledAppointmentList(list);
            }
          }
      ),
    );
  }

}