
import 'dart:io';
import 'package:appointment_app_v2/ui/auth/register/create_password.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../state_management/fill_profile_state.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_button.dart';
import '../../../ui_items/my_responsive_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/method_helper.dart';
import '../../../utils/validators.dart';
import '../../../view_model/fill_profile/fill_profile_view_model_imp.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _dateOfBirthHasError = false;
  bool _emailHasError = false;
  bool _phoneHasError = false;
  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;
  bool _isDateOfBirthFocused = false;
  bool _isEmailFocused = false;
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
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Inserts initial values into text editing controllers based on context data.
  ///
  /// This function retrieves data from context providers and inserts the initial values
  /// into the corresponding text editing controllers, such as [_firstNameController],
  /// [_lastNameController], [_dateOfBirthController], [_emailController], and [_phoneController].
  ///
  /// Returns: void
  void _insertInitialTextEditingControllersValues() {
    // Retrieve values from context providers.
    String firstName = ref.read(firstNameProvider);
    String lastName = ref.read(lastNameProvider);
    String dateOfBirth = ref.read(dateOfBirthProvider);
    String email = ref.read(emailProvider);
    String phone = ref.read(phoneProvider);

    // Insert values into text editing controllers.
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _dateOfBirthController.text = dateOfBirth;
    _emailController.text = email;
    _phoneController.text = phone;
  }

  /// Saves form values and navigates to the next page if form validation is successful.
  ///
  /// This function validates the form using [_formKey]. If the form is valid, it saves the
  /// form values to their corresponding providers using [FillProfileModelImp().setValue()].
  /// After saving the values, it navigates to the [CreatePassword] page.
  ///
  /// Returns: A [Future] that completes when the form values are saved and navigation is performed.
  Future _saveValues() async {
    if (_formKey.currentState!.validate()) {
      // Save form values to corresponding providers.
      FillProfileModelImp().setValue(firstNameProvider.notifier, ref, _firstNameController.text.trim());
      FillProfileModelImp().setValue(lastNameProvider.notifier, ref, _lastNameController.text.trim());
      FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, _dateOfBirthController.text.trim());
      FillProfileModelImp().setValue(emailProvider.notifier, ref, _emailController.text.trim());
      FillProfileModelImp().setValue(phoneProvider.notifier, ref, _phoneController.text.trim());

      // Navigate to the next page.
      MethodHelper.switchPage(context, PageNavigatorType.PUSH, const CreatePassword(), widget);

    }
  }

  /// Picks an image from the device's gallery and updates the image path.
  ///
  /// This function uses the [ImagePicker] package to allow the user to pick an image
  /// from the device's gallery. Once an image is selected, its path is retrieved,
  /// and the image path provider is updated using [FillProfileModelImp().setValue()].
  /// The widget state is then updated to reflect the change.
  ///
  /// Returns: A [Future] that completes when an image is successfully picked and the state is updated.
  Future<void> _pickImage() async {
    // Use ImagePicker to pick an image from the gallery.
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    // Define the maximum file size in bytes.
    var maxFileSizeInBytes = MAX_FILE_SIZE_UPLOAD_IN_BYTES;

    // If no image is picked, return.
    if (image == null) return;

    // Read the image as bytes.
    var imageAsBytes = await image.readAsBytes();

    // Check if the image size is within the allowed limit.
    if (imageAsBytes.length <= maxFileSizeInBytes) {
      // Get the selected image's path.
      String imagePath = image.path;

      // Update the image path provider using FillProfileModelImp().
      FillProfileModelImp().setValue(imagePathProvider.notifier, ref, imagePath);

      // Update the widget state to reflect the change.
      setState(() {});
    } else {
      // Display a warning dialog if the image size exceeds the limit.
      MethodHelper.showDialogAlert(
        context,
        MyDialogType.WARNING,
        'The size of the picture should be under $MAX_FILE_SIZE MB.',
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.clearFillProfileControllers(ref);
        return true;
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
        color: light1,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
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
                  MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Continue',onPressed: _saveValues),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}