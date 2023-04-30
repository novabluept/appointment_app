
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';

class MyTextFormField extends ConsumerWidget {

  final MyTextFormFieldType type;
  final TextEditingController textEditingController;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String label;
  final bool isPassword;
  final double? contentPaddingWidth;
  final double? contentPaddingHeight;
  final String? Function(String?)? validator;

  const MyTextFormField({super.key, required this.type, required this.textEditingController,
    this.prefixIcon,this.suffixIcon, required this.label, this.isPassword = false, this.contentPaddingWidth, this.contentPaddingHeight,
  required this.validator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyTextFormFieldType.GENERAL:
        return generalTextFormField(textEditingController,null,null,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      case MyTextFormFieldType.PREFIX:
        return generalTextFormField(textEditingController,prefixIcon!,null,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      case MyTextFormFieldType.SUFFIX:
        return generalTextFormField(textEditingController,null,suffixIcon!,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      case MyTextFormFieldType.PREFIX_SUFIX:
        return generalTextFormField(textEditingController,prefixIcon!,suffixIcon!,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      case MyTextFormFieldType.PHONE:
        return phoneTextFormField(textEditingController,null,null,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      case MyTextFormFieldType.PASSWORD:
        return generalTextFormField(textEditingController,prefixIcon!,suffixIcon!,label,isPassword,contentPaddingWidth ?? 20,contentPaddingHeight ?? 20,validator);
      default:
        return Container();
    }

  }

  Widget generalTextFormField(TextEditingController textEditingController,IconData? prefixIcon,IconData? sufixIcon,String label,bool isPassword, double contentPaddingWidth, double contentPaddingHeight,String? Function(String?)? validator){

    return TextFormField(
      controller: textEditingController,
      cursorColor: blue,
      style: GoogleFonts.urbanist(fontSize: 14.sp,fontWeight: FontWeight.w500),
      obscureText: isPassword ? true : false,
      obscuringCharacter: '●',
      decoration: InputDecoration(
        fillColor: grey50,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingWidth.w,vertical: contentPaddingHeight.h),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon,size: 20.sp,color: grey500) : null,
        suffixIcon: sufixIcon != null ? Icon(sufixIcon,size: 20.sp,color: grey500) : null,
        hintText: label,
        hintStyle: GoogleFonts.urbanist(fontSize: 14.sp,fontWeight: FontWeight.w500),
        errorStyle: GoogleFonts.urbanist(fontSize: 0,fontWeight: FontWeight.w500),
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
    );
  }

  Widget phoneTextFormField(TextEditingController textEditingController,IconData? prefixIcon,IconData? sufixIcon,String label,bool isPassword, double contentPaddingWidth, double contentPaddingHeight,String? Function(String?)? validator){
    return TextFormField(
      controller: textEditingController,
      cursorColor: blue,
      style: GoogleFonts.urbanist(fontSize: 14.sp,fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: grey50,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingWidth.w,vertical: contentPaddingHeight.h),
        prefixIcon: Container(
          margin: EdgeInsets.only(left: 20.w,right: 8.w),
          child: SvgPicture.asset('images/flag_of_portugal.svg',width: 24.w,height: 18.h)
        ),
        hintText: label,
        hintStyle: GoogleFonts.urbanist(fontSize: 14.sp,fontWeight: FontWeight.w500),
        errorStyle: GoogleFonts.urbanist(fontSize: 0,fontWeight: FontWeight.w500),
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
    );
  }


}