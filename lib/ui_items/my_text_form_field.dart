
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyTextFormField extends ConsumerWidget {

  final MyTextFormFieldType type;
  final TextEditingController textEditingController;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String label;
  final bool showObscureText;
  final bool isObscure;
  final bool hasError;
  final String errorText;
  final bool isDate;
  final bool isReadOnly;
  final bool isFieldFocused;
  final FocusNode? focusNode;
  final double? contentPaddingWidth;
  final double? contentPaddingHeight;
  final String? Function(String?)? validator;
  final Function()? triggerObscureTextVisibility;
  final Function()? showDateDialog;
  final Function(bool) onFocusChange;

  const MyTextFormField({super.key, required this.type, required this.textEditingController,
    this.prefixIcon,this.suffixIcon, required this.label, this.showObscureText = false, this.isObscure = false,
    required this.hasError,required this.errorText,this.isDate = false,this.isReadOnly = false,required this.isFieldFocused,this.focusNode, this.contentPaddingWidth,this.contentPaddingHeight,
    required this.validator,this.triggerObscureTextVisibility,this.showDateDialog,required this.onFocusChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyTextFormFieldType.GENERAL:
        return generalTextFormField(textEditingController,null,null,label,showObscureText,isObscure,hasError,errorText,isDate,isReadOnly,isFieldFocused,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator,null,showDateDialog,onFocusChange);
      case MyTextFormFieldType.PREFIX:
        return generalTextFormField(textEditingController,prefixIcon!,null,label,showObscureText,isObscure,hasError,errorText,isDate,isReadOnly,isFieldFocused,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator,null,showDateDialog,onFocusChange);
      case MyTextFormFieldType.SUFFIX:
        return generalTextFormField(textEditingController,null,suffixIcon!,label,showObscureText,isObscure,hasError,errorText,isDate,isReadOnly,isFieldFocused,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator,triggerObscureTextVisibility,showDateDialog,onFocusChange);
      case MyTextFormFieldType.PREFIX_SUFIX:
        return generalTextFormField(textEditingController,prefixIcon!,suffixIcon,label,showObscureText,isObscure,hasError,errorText,isDate,isReadOnly,isFieldFocused,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator,triggerObscureTextVisibility,showDateDialog,onFocusChange);
      case MyTextFormFieldType.PHONE:
        return phoneTextFormField(textEditingController,null,null,label,hasError,errorText,isFieldFocused,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator,onFocusChange);
      default:
        return Container();
    }
  }

  _suffixIcon(){
    if(isObscure){ /// Verifica se é texto oculto
      return IconButton(icon: Icon(showObscureText ? IconlyBold.hide : IconlyBold.show,size: 20.sp,color: grey500),onPressed: triggerObscureTextVisibility);
    }else{
      return suffixIcon != null ? Icon(suffixIcon,size: 20.sp,color: grey500) : null;
    }
  }

  Widget generalTextFormField(TextEditingController textEditingController,IconData? prefixIcon,
      IconData? suffixIcon,String label,bool showObscureText,bool isObscure,bool hasError,String errorText,bool isDate,bool isReadOnly,bool isFieldFocused,
      double contentPaddingWidth, double contentPaddingHeight,String? Function(String?)? validator,Function()? triggerObscureTextVisibility, Function()? showDateDialog,Function(bool) onFocusChange){

    return Column(
      children: [
        Focus(
          onFocusChange: onFocusChange,
          child: TextFormField(
            readOnly: isReadOnly ? true : false,
            controller: textEditingController,
            cursorColor: blue,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.sp,
              fontWeight: MyLabel.MEDIUM,
            ),
            obscureText: showObscureText,
            obscuringCharacter: '●',
            onTap: isDate ? showDateDialog : null,
            decoration: InputDecoration(
              fillColor: isFieldFocused ? lightBlue : grey50,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingWidth.w,vertical: contentPaddingHeight.h),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon,size: 20.sp,color: grey500) : null,
              suffixIcon: _suffixIcon(),
              hintText: label,
              hintStyle: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14.sp,
                fontWeight: MyLabel.MEDIUM,
              ),
              errorStyle: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 0.sp,
                fontWeight: MyLabel.MEDIUM,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey50, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              focusColor: red,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
            ),
            validator: validator,
          ),
        ),
        hasError == true ? Row(
          children: [
            Icon(IconlyBold.danger,size: 14.sp,color: red),
            SizedBox(width: 8.w),
            MyLabel(
              type: MyLabelType.BODY_MEDIUM,
              fontWeight: MyLabel.MEDIUM,
              color: red,
              label: errorText,
            ),
          ],
        ) : Container()
      ],
    );
  }

  Widget phoneTextFormField(TextEditingController textEditingController,IconData? prefixIcon,
      IconData? suffixIcon,String label,bool hasError,String errorText,bool isFieldFocused,
      double contentPaddingWidth, double contentPaddingHeight,String? Function(String?)? validator,Function(bool) onFocusChange){

    return Column(
      children: [
        Focus(
          onFocusChange: onFocusChange,
          child: TextFormField(
            controller: textEditingController,
            cursorColor: blue,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14.sp,
              fontWeight: MyLabel.MEDIUM,
            ),
            decoration: InputDecoration(
              fillColor: isFieldFocused ? lightBlue : grey50,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingWidth.w,vertical: contentPaddingHeight.h),
              prefixIcon: Container(
                  margin: EdgeInsets.only(left: 20.w,right: 8.w),
                  child: SvgPicture.asset('images/flag_of_portugal.svg',width: 24.w,height: 18.h)
              ),
              hintText: label,
              hintStyle: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14.sp,
                fontWeight: MyLabel.MEDIUM,
              ),
              errorStyle: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 0.sp,
                fontWeight: MyLabel.MEDIUM,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey50, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: blue, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red, width: 1.0.w),
                borderRadius: BorderRadius.circular(16.0).r,
              ),
            ),
            validator: validator,
          ),
        ),
        hasError == true ? Row(
          children: [
            Icon(IconlyBold.danger,size: 14.sp,color: red),
            SizedBox(width: 8.w),
            MyLabel(
              type: MyLabelType.BODY_MEDIUM,
              fontWeight: MyLabel.MEDIUM,
              color: red,
              label: errorText,
            ),
          ],
        ) : Container()
      ],
    );
  }


}