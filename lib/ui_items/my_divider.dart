

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_label.dart';

class MyDivider extends ConsumerWidget {

  final MyDividerType type;
  final String? label;

  const MyDivider({super.key, required this.type, this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyDividerType.SIMPLE:
        return generalDivider(null);
      case MyDividerType.TEXT:
        return generalDivider(label);
      default:
        return Container();
    }

  }

  Widget generalDivider(String? label){
    return label != null ? Row(
      children: [
        Expanded(
            child: Divider(
              color: grey200,
              thickness: 1.0,
            )
        ),
        SizedBox(width: 16.w),
        MyLabel(
          type: MyLabelType.BODY_XLARGE,
          fontWeight: MyLabel.SEMI_BOLD,
          label: label,
          color: grey600,
        ),
        SizedBox(width: 16.w),
        Expanded(
            child: Divider(
              color: grey200,
              thickness: 1.0,
            )
        ),
      ],
    ) :
    Row(
      children: [
        Expanded(
          child: Divider(
            color: grey200,
            thickness: 1.0,
          )
        ),
      ],
    );
  }


}