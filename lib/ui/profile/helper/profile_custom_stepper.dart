import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';

class ProfileStepper extends StatelessWidget {
  final Color color;

  final List<Userexperiencedatum> expData;

  final AppBloc appBloc;

  const ProfileStepper(
      {Key? key,
      required this.color,
      required this.expData,
      required this.appBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    basicDeviceHeightWidth(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Container(
      child: expData.length != 0
          ? ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: expData.length,
              itemBuilder: (context, pos) {
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 3.h),
                        alignment: Alignment.topCenter,
                        height: 89.h,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 6.h,
                              height: 6.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: color),
                            ),
                            (pos != (expData.length - 1))
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
//                                margin: EdgeInsets.symmetric(horizontal: 2.h,vertical: 2.h),
                                    alignment: Alignment.center,
                                    height: 60.h,
                                    color: Colors.grey.shade300,
                                    width: 0.5.h,
                                  )
                                : SizedBox(
                                    height: 1,
                                  )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.h,
                      ),
                      Expanded(
                        child: Container(
                          height: 86.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                expData[pos].title,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                expData[pos].companyname,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                (expData[pos].tilldate)
                                    ? '${expData[pos].fromdate} - Present'
                                    : '${expData[pos].fromdate} - ${expData[pos].todate}',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.h),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })
          : Text('-'),
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }
}
