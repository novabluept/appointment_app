
import 'package:appointment_app_v2/model/user_model.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import '../../../../../state_management/persistent_bottom_navbar_state.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/validators.dart';
import '../../../../../view_model/edit_profile/edit_profile_view_model_imp.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}): super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _dateOfBirthHasError = false;
  bool _phoneHasError = false;
  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;
  bool _isDateOfBirthFocused = false;
  bool _isPhoneFocused = false;

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
    _phoneController.dispose();
    super.dispose();
  }

  _insertInitialTextEditingControllersValues(){
    UserModel user = ref.read(currentUserProvider);
    _firstNameController.text = user.firstname;
    _lastNameController.text = user.lastname;
    _dateOfBirthController.text = user.dateOfBirth;
    _phoneController.text = user.phone;
  }

  Future _updateUser() async{
    if(_formKey.currentState!.validate()){

      String firstname = _firstNameController.text.trim();
      String lastname = _lastNameController.text.trim();
      String dateOfBirth = _dateOfBirthController.text.trim();
      String phone = _phoneController.text.trim();

      Map<String, dynamic> fields = {
        UserModel.col_firstname: firstname,
        UserModel.col_lastname: lastname,
        UserModel.col_dateOfBirth: dateOfBirth,
        UserModel.col_phone: phone,
      };
      EditProfileModelImp().updateUser(fields);

      UserModel user = ref.read(currentUserProvider);
      UserModel newUser = UserModel(firstname: firstname, lastname: lastname, dateOfBirth: dateOfBirth, email: user.email, phone: phone, role: user.role,imagePath: user.imagePath);

      Navigator.of(context).pop();
      EditProfileModelImp().setValue(currentUserProvider.notifier, ref, newUser);

    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: light1,
        resizeToAvoidBottomInset : true,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: IconlyLight.arrow_left,
          label: 'Edit profile',
          onTap: (){
            Navigator.of(context).pop();
          },
        ),
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    type: MyTextFormFieldType.PHONE,
                    textEditingController: _phoneController,
                    label: 'Phone number',
                    contentPaddingHeight: 18,
                    hasError: _phoneHasError,
                    errorText: 'Phone number should have the format: 9XYYYYYYY',
                    isFieldFocused: _isPhoneFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isPhoneFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isPhoneValid(value)){
                        setState(() {_phoneHasError = true;});
                        return '';
                      }
                      setState(() {_phoneHasError = false;});
                      return null;
                    }
                  ),
                  SizedBox(height: 24.h),
                  MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Update',onPressed: _updateUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}