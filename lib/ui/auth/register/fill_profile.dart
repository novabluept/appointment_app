
import 'package:appointment_app_v2/ui/auth/register/create_password.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import '../../../state_management/state.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_button.dart';
import '../../../ui_items/my_responsive_layout.dart';
import '../../../utils/method_helper.dart';
import '../../../view_model/fill_profile/fill_profile_view_model_imp.dart';
import '../../main_page.dart';

class FillProfile extends ConsumerStatefulWidget {
  const FillProfile({Key? key}): super(key: key);

  @override
  FillProfileState createState() => FillProfileState();
}

class FillProfileState extends ConsumerState<FillProfile> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future _saveValues() async{

    await FillProfileModelImp().setValue(firstNameProvider.notifier, ref, _firstNameController.text.trim());
    await FillProfileModelImp().setValue(lastNameProvider.notifier, ref, _lastNameController.text.trim());
    await FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, _dateOfBirthController.text.trim());
    await FillProfileModelImp().setValue(emailProvider.notifier, ref, _emailController.text.trim());
    await FillProfileModelImp().setValue(phoneNumberProvider.notifier, ref, _phoneNumberController.text.trim());

    MethodHelper.transitionPage(context, widget, CreatePassword(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.transitionPage(context, widget, MainPage(), PageNavigatorType.PUSH_REPLACEMENT,PageTransitionType.leftToRightJoined);
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset : true,
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: CupertinoIcons.arrow_left,
            label: 'Fill your profile',
            onTap: (){
              MethodHelper.transitionPage(context, widget, MainPage(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
            },
          ),
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),)
      ),
    );
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        color: white,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.h,
              height: 200.h,
              child: CircleAvatar(
                radius: 58,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 50.w,
                        height: 50.h,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white70,
                          child: Icon(CupertinoIcons.camera),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),

            SizedBox(height: 24.h,),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  MyTextFormField(type: MyTextFormFieldType.GENERAL,textEditingController: _firstNameController, label: 'First name',contentPaddingHeight: 18,validator: (value){

                  }),

                  SizedBox(height: 24.h,),

                  MyTextFormField(type: MyTextFormFieldType.GENERAL,textEditingController: _lastNameController, label: 'Last name',contentPaddingHeight: 18,validator: (value){

                  }),

                  SizedBox(height: 24.h,),

                  MyTextFormField(type: MyTextFormFieldType.SUFFIX,textEditingController: _dateOfBirthController,suffixIcon: CupertinoIcons.calendar, label: 'Date of Birth',contentPaddingHeight: 18,validator: (value){

                  }),

                  SizedBox(height: 24.h,),

                  MyTextFormField(type: MyTextFormFieldType.SUFFIX,textEditingController: _emailController,suffixIcon: CupertinoIcons.mail, label: 'Email',contentPaddingHeight: 18,validator: (value){

                  }),

                  SizedBox(height: 24.h,),

                  MyTextFormField(type: MyTextFormFieldType.PHONE,textEditingController: _phoneNumberController,label: 'Phone number',contentPaddingHeight: 18,validator: (value){

                  }),

                  SizedBox(height: 24.h,),

                  MyButton(type: MyButtonType.FILLED, label: 'Continue',onPressed: _saveValues),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}