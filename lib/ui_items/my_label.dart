
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';

class MyLabel extends ConsumerWidget {

  static const NORMAL = FontWeight.w400;
  static const MEDIUM = FontWeight.w500;
  static const SEMI_BOLD = FontWeight.w600;
  static const BOLD = FontWeight.w700;

  final MyLabelType type;
  final String label;
  final FontWeight? fontWeight; /// 400 – Normal ## 500 – Medium ## 600 – Semi Bold (Demi Bold) ## 700 – Bold.
  final int? fontSize;
  final Color? color;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const MyLabel({super.key, required this.type, required this.label,this.fontWeight,this.fontSize,this.color,this.height,this.textAlign,this.overflow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    switch (type) {
      case MyLabelType.H1:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 48,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.H2:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 40,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.H3:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 32,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.H4:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 24,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.H5:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 20,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.H6:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 18,color ?? dark1,height ?? 1.2,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.BODY_XLARGE:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 18,color ?? dark1,height ?? 1.4,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.BODY_LARGE:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 16,color ?? dark1,height ?? 1.4,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.BODY_MEDIUM:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 14,color ?? dark1,height ?? 1.4,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.BODY_SMALL:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 12,color ?? dark1,height ?? 1.0,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      case MyLabelType.BODY_XSMALL:
        return generalText(label,fontWeight ?? NORMAL,fontSize ?? 10,color ?? dark1,height ?? 1.0,textAlign ?? TextAlign.start,overflow ?? TextOverflow.clip);
      default:
        return Container();
    }
  }

  Widget generalText(String label,FontWeight fontWeight,int fontSize,Color color,double height,TextAlign textAlign,TextOverflow overflow){
    return Text(
      label,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
      overflow: overflow,
    );
  }
}