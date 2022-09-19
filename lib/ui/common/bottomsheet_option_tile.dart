import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'app_colors.dart';

class BottomsheetOptionTile extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final String? svgImageUrl;
  final Color? iconColor, textColor;
  final void Function()? onTap;


  BottomsheetOptionTile({
    Key? key,
    this.iconData,
    required this.text,
    this.iconColor,
    this.svgImageUrl,
    this.textColor,
    this.onTap,
  }) : assert(
  iconData == null || (svgImageUrl?.isEmpty ?? true),
  "Cannot provider both iconData and svgImageUrl"
  ),
      assert(
  iconData != null || (svgImageUrl?.isNotEmpty ?? false),
  "you have to pass any one of the iconData and svgImageUrl"
  ),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 35,
      contentPadding: EdgeInsets.symmetric(horizontal:20,vertical: 0),
      onTap: () async {
        if(onTap != null) {
          onTap!();
        }
      },
      leading: (svgImageUrl?.isEmpty ?? true) ? Icon(
        iconData,
        color: iconColor ?? AppColors.getAppTextColor(),
      ) : SvgPicture.asset(
        svgImageUrl!,
        width: 25.h,
        height: 25.h,
        color: iconColor,
      ),
      title:

      Container(
        child: Text(
          text,
          style: TextStyle(color: textColor ?? AppColors.getAppTextColor(),),
        ),
      ),
    );
  }
}
