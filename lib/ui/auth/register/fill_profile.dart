
import 'dart:io';
import 'package:appointment_app_v2/ui/auth/register/create_password.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../../../state_management/choose_shop_state.dart';
import '../../../state_management/fill_profile_state.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_button.dart';
import '../../../ui_items/my_responsive_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/method_helper.dart';
import '../../../utils/validators.dart';
import '../../../view_model/fill_profile/fill_profile_view_model_imp.dart';
import '../../auth_observer.dart';

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
  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _dateOfBirthHasError = false;
  bool _emailHasError = false;
  bool _phoneNumberHasError = false;
  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;
  bool _isDateOfBirthFocused = false;
  bool _isEmailFocused = false;
  bool _isPhoneNumberFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertInitialTextEditingControllersValues();
    });

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  _insertInitialTextEditingControllersValues(){
    String imagePath = ref.read(imagePathProvider);
    _firstNameController.text = ref.read(firstNameProvider);
    _lastNameController.text = ref.read(lastNameProvider);
    _dateOfBirthController.text = ref.read(dateOfBirthProvider);
    _emailController.text = ref.read(emailProvider);
    _phoneNumberController.text = ref.read(phoneNumberProvider);
  }

  Future _saveValues() async{

    if(_formKey.currentState!.validate()){
      FillProfileModelImp().setValue(firstNameProvider.notifier, ref, _firstNameController.text.trim());
      FillProfileModelImp().setValue(lastNameProvider.notifier, ref, _lastNameController.text.trim());
      FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, _dateOfBirthController.text.trim());
      FillProfileModelImp().setValue(emailProvider.notifier, ref, _emailController.text.trim());
      FillProfileModelImp().setValue(phoneNumberProvider.notifier, ref, _phoneNumberController.text.trim());

      MethodHelper.transitionPage(context, widget, CreatePassword(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);
    }
  }

  Future pickImage() async{
    ///TODO: Fazer try catch e tratar de configurações
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String imagePath = image.path;

    FillProfileModelImp().setValue(imagePathProvider.notifier, ref, imagePath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.clearFillProfileControllers(ref);
        MethodHelper.transitionPage(context, widget, AuthObserver(), PageNavigatorType.PUSH_REPLACEMENT,PageTransitionType.leftToRightJoined);
        return false;
      },
      child: Scaffold(
        backgroundColor: light1,
        resizeToAvoidBottomInset : true,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: IconlyLight.arrow_left,
          label: 'Fill your profile',
          onTap: (){
            MethodHelper.clearFillProfileControllers(ref);
            MethodHelper.transitionPage(context, widget, AuthObserver(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
          },
        ),
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        color: light1,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: SizedBox(
                width: 200.h,
                height: 200.h,
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: light1,
                  backgroundImage: ref.read(imagePathProvider) != PROFILE_IMAGE_DIRECTORY ? Image.file(File(ref.watch(imagePathProvider))).image : Image.asset(PROFILE_IMAGE_DIRECTORY).image,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 50.w,
                          height: 50.h,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: blue,
                            child: Icon(IconlyBold.edit,color: light1,size: 30.sp),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  MyTextFormField(
                    type: MyTextFormFieldType.GENERAL,
                    textEditingController: _firstNameController,
                    label: 'First name',
                    contentPaddingHeight: 18,
                    hasError: _firstNameHasError,
                    errorText: 'Please enter a valid first name',
                    isFieldFocused: _isFirstNameFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isFirstNameFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.hasMinimumAndMaxCharacters(value)){
                        setState(() {_firstNameHasError = true;});
                        return '';
                      }
                      setState(() {_firstNameHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 24.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.GENERAL,
                    textEditingController: _lastNameController,
                    label: 'Last name',
                    contentPaddingHeight: 18,
                    hasError: _lastNameHasError,
                    errorText: 'Please enter a valid last name',
                    isFieldFocused: _isLastNameFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isLastNameFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.hasMinimumAndMaxCharacters(value)){
                        setState(() {_lastNameHasError = true;});
                        return '';
                      }
                      setState(() {_lastNameHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 24.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.SUFFIX,
                    textEditingController: _dateOfBirthController,
                    suffixIcon: IconlyLight.calendar,
                    label: 'Date of birth',
                    contentPaddingHeight: 18,
                    hasError: _dateOfBirthHasError,
                    errorText: 'Please enter a valid date of birth',
                    isDate: true,
                    isReadOnly: true,
                    showDateDialog: () async{
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2025),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          _dateOfBirthController.text = DateFormat(DATE_FORMAT_DAY_MONTH_YEAR).format(selectedDate);
                        }
                      });
                    },
                    isFieldFocused: _isDateOfBirthFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isDateOfBirthFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty){
                        setState(() {_dateOfBirthHasError = true;});
                        return '';
                      }
                      setState(() {_dateOfBirthHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 24.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.SUFFIX,
                    textEditingController: _emailController,
                    suffixIcon: IconlyLight.message,
                    label: 'Email',
                    contentPaddingHeight: 18,
                    hasError: _emailHasError,
                    errorText: 'Please enter a valid email',
                    isFieldFocused: _isEmailFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isEmailFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isEmailValid(value)){
                        setState(() {_emailHasError = true;});
                        return '';
                      }
                      setState(() {_emailHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 24.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.PHONE,
                    textEditingController: _phoneNumberController,
                    label: 'Phone number',
                    contentPaddingHeight: 18,
                    hasError: _phoneNumberHasError,
                    errorText: 'Phone number should have the format: 9XYYYYYYY',
                    isFieldFocused: _isPhoneNumberFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isPhoneNumberFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isPhoneValid(value)){
                        setState(() {_phoneNumberHasError = true;});
                        return '';
                      }
                      setState(() {_phoneNumberHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 24.h),

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