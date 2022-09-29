import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';

class BottomSheetDragger extends StatelessWidget {
  final Color? color;
  const BottomSheetDragger({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 8;

    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: 20, top: 17),
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: height,
            decoration: BoxDecoration(
              color: color ?? AppColors.getAppTextColor().withOpacity(0.4),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}
