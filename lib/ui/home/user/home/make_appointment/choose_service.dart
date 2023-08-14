
import 'dart:async';
import 'package:appointment_app_v2/ui_items/my_choose_service_tile.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../model/service_model.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../utils/constants.dart';
import '../../../../../view_model/choose_service/choose_service_view_model_imp.dart';
import '../../../../../view_model/make_appointment_screen/make_appointment_screen_view_model_imp.dart';

class ChooseService extends ConsumerStatefulWidget {
  const ChooseService({Key? key}): super(key: key);

  @override
  ChooseServiceState createState() => ChooseServiceState();
}

class ChooseServiceState extends ConsumerState<ChooseService> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late Future<List<ServiceModel>> _future;

  @override
  void initState() {
    _future = _getServicesByUserIdAndShopIdFromDB();
    super.initState();
  }

  /// Fetches a list of service models associated with a specific professional and shop from the database.
  ///
  /// This function retrieves the current professional's [userId] and the current shop's [shopId] from the context's providers. It then uses the [ChooseServiceViewModelImp] to get the services by professional and shop, and updates the [listServices] notifier using [MakeAppointmentScreenViewModelImp]. It returns a list of [ServiceModel] instances after a delay of [LOAD_DATA_DURATION] milliseconds.
  ///
  /// Returns:
  ///   - A future containing a list of [ServiceModel] instances.
  Future<List<ServiceModel>> _getServicesByUserIdAndShopIdFromDB() async {
    String userId = ref.read(currentProfessionalProvider).userId;
    String shopId = ref.read(currentShopProvider).shopId;

    List<ServiceModel> list = await ChooseServiceViewModelImp().getServicesByProfessionalShop(userId, shopId);

    // Update the list of services in the notifier
    ChooseServiceViewModelImp().setValue(listServices.notifier, ref, list);

    // Return the list of services after a delay
    return await Future.delayed(Duration(milliseconds: LOAD_DATA_DURATION), () => list);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: grey50,
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  Widget _servicesListShimmer(){
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: 9,
      itemBuilder: (context, index) {
        return const MyChooseServiceTile(type: MyChooseServiceTileType.SHIMMER);
      },
    );
  }

  /// Handles selecting a service for making an appointment.
  ///
  /// This function is called when a user selects a service for making an appointment.
  /// It takes the selected [service] and its [index] in the list of services.
  /// It sets the [service] as the current service using [ChooseServiceViewModelImp] and updates the [currentServiceIndexProvider].
  /// After a delay of [TRANSITION_DURATION] milliseconds, it sets the [currentAppointmentIndexProvider] to 2, which advances to the next step of the appointment process.
  void _chooseService(ServiceModel service, int index) {
    ChooseServiceViewModelImp().setValue(currentServiceProvider.notifier, ref, service);
    ChooseServiceViewModelImp().setValue(currentServiceIndexProvider.notifier, ref, index);

    // Navigate to the next step after a delay
    Timer(const Duration(milliseconds: TRANSITION_DURATION), () {
      ChooseServiceViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 2);
    });
  }

  Widget _servicesList(List<ServiceModel> list){

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
          onTap: () => _chooseService(service,index)
        );
      },
    );
  }

  Widget mobileBody(){

    List<ServiceModel> list = ref.read(listServices);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: list.isEmpty ? FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _servicesListShimmer();
          } else if (snapshot.hasError) {
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'No services available',);
          } else {
            List<ServiceModel> list = snapshot.data!;
            return _servicesList(list);
          }
        },
      ) : _servicesList(list)
    );
  }



}