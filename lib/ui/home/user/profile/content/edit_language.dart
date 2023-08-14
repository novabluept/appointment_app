
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';

class EditLanguage extends ConsumerStatefulWidget {
  const EditLanguage({Key? key}): super(key: key);

  @override
  EditLanguageState createState() => EditLanguageState();
}

class EditLanguageState extends ConsumerState<EditLanguage> {

  LanguageTypes? _language = LanguageTypes.PT;

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
            label: 'Language',
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
            ListTile(
              title: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.SEMI_BOLD,
                label: 'Portuguese',
                color: grey900,
              ),
              trailing: Radio(
                value: LanguageTypes.PT,
                groupValue: _language,
                activeColor: blue,
                fillColor: MaterialStateProperty.all(blue),
                onChanged: (LanguageTypes? value) {
                  setState(() {
                    _language = value;
                  });
                },
              ),
            ),
            ListTile(
              title: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.SEMI_BOLD,
                label: 'English',
                color: grey900,
              ),
              trailing: Radio(
                value: LanguageTypes.EN,
                groupValue: _language,
                activeColor: blue,
                fillColor: MaterialStateProperty.all(blue),
                onChanged: (LanguageTypes? value) {
                  setState(() {
                    _language = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}