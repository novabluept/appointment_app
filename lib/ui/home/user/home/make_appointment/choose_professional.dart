
import 'dart:async';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/view_model/make_appointment_screen/make_appointment_screen_view_model_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../model/service_model.dart';
import '../../../../../model/user_model.dart';
import '../../../../../state_management/choose_shop_state.dart';
import '../../../../../state_management/make_appointments_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_choose_professional_tile.dart';
import '../../../../../ui_items/my_exception.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../utils/constants.dart';
import '../../../../../view_model/choose_professional/choose_professional_view_model.dart';
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

  /// Retrieves a list of professional users associated with the current shop from Firebase.
  ///
  /// This function retrieves a list of [UserModel] instances using [ChooseProfessionalViewModelImp().getProfessionalUsersByShop(ref)].
  /// The retrieved list of professionals is then stored in the [listProfessionals] state variable using [MakeAppointmentScreenViewModelImp().setValue()].
  /// The function returns the list of professional users after a delay of [LOAD_DATA_DURATION] milliseconds.
  ///
  /// Returns: A [Future] containing the list of professional users associated with the current shop.
  Future<List<UserModel>> _getUsersByShopFirebase() async {
    // Retrieve the list of professional users associated with the current shop.
    List<UserModel> list = await ChooseProfessionalViewModelImp().getProfessionalUsersByShop(ref);
    // Store the retrieved list of professionals in the listProfessionals state variable.
    ChooseProfessionalViewModelImp().setValue(listProfessionals.notifier, ref, list);
    // Return the list of professional users after a delay.
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

  Widget _professionalsListShimmer(){
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 24.h),
      separatorBuilder: (context, index) => SizedBox(height: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const MyChooseProfessionalTile(type: MyChooseProfessionalTileType.SHIMMER);
      }
    );
  }

  /// Handles selecting a professional for making an appointment.
  ///
  /// This function is called when a user selects a professional for making an appointment.
  /// It takes the selected [user] and its [index] in the list of professionals.
  /// It checks if the current professional index is different from the selected index and if there is a current professional index set.
  /// If so, it resets the list of services using [ChooseProfessionalViewModelImp].
  /// It then sets the [user] as the current professional using [ChooseProfessionalViewModelImp] and updates the [currentProfessionalIndexProvider].
  /// After a delay of [TRANSITION_DURATION] milliseconds, it sets the [currentAppointmentIndexProvider] to 1, which navigates to the appointment details screen.
  /// Debug information is printed for the [currentAppointmentIndexProvider].
  void _chooseProfessional(UserModel user, int index) {
    if (ref.read(currentProfessionalIndexProvider) != -1 && ref.read(currentProfessionalIndexProvider) != index) {
      ChooseProfessionalViewModelImp().setValue(listServices.notifier, ref, <ServiceModel>[]);
    }
    ChooseProfessionalViewModelImp().setValue(currentProfessionalProvider.notifier, ref, user);
    ChooseProfessionalViewModelImp().setValue(currentProfessionalIndexProvider.notifier, ref, index);

    // Navigate to the appointment details screen after a delay
    Timer(const Duration(milliseconds: TRANSITION_DURATION), () {
      ChooseProfessionalViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 1);
    });

    debugPrint('indexMakeAppointmentProvider -> ${ref.read(currentAppointmentIndexProvider)}');
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
          onTap: () => _chooseProfessional(user,index)
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
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/warning_image.svg',firstLabel: 'Something went wrong',secondLabel: 'Please try again later.',);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const MyException(type: MyExceptionType.GENERAL,imagePath: 'images/blue/no_data_image.svg',firstLabel: 'There is no data available',secondLabel: 'No professionals available',);
          } else {
            List<UserModel> list = snapshot.data!;
            return _professionalsList(list);
          }
        }
      ) : _professionalsList(list)
    );
  }

}