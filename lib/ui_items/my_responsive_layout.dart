
import 'package:flutter/cupertino.dart';

class MyResponsiveLayout extends StatelessWidget {
  /// Source code: https://github.com/mitchkoko/responsivedashboard/blob/master/lib/responsive/responsive_layout.dart
  final Widget mobileBody;
  final Widget tabletBody;

  const MyResponsiveLayout({super.key, required this.mobileBody, required this.tabletBody,});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileBody;
        } else {
          return tabletBody;
        }
      },
    );
  }
}