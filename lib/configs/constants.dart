import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../ui/common/app_colors.dart';

const String DOWNLOAD_COURSE_ISOLATE_NAME = "downloader_course_isolate";
const String MY_DOWNLOADS_HIVE_COLLECTION_NAME = "my-downloads";
const String MY_REMOVE_FROM_DOWNLOADS_HIVE_COLLECTION_NAME = "my-remove-from-downloads";

class AppConstants {
  static const List<int> downloadableContentIds = [8, 9, 11, 14, 20, 21, 36, 52];


  ShapeBorder bottomSheetShapeBorder() => RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)) );
  BorderRadiusGeometry borderRadiusGeometry() => BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20));
  Container bottomSheetContainer({Widget? child}) => Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
          color:AppColors.getAppBGColor(),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:child);

  Widget getLoaderWidget({double iconSize = 50}){
    return SpinKitCircle(
      color: AppColors.getLoadingColor(),
      size: iconSize.h,
    );
  }
}
