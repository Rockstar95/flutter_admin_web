import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  Widget? web = Container();

  ResponsiveWidget({Key? key, required this.mobile, required this.tab, this.web})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobile;
      }
      if (constraints.maxWidth < 900) {
        return tab;
      }
      else {
        return web ?? Container();
      }
    });
  }
}
