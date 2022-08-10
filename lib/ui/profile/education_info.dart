import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/ui/profile/education_add_edit.dart';

class EducationalInfo extends StatefulWidget {
  final String type;
  final String title;
  final String subtitle;
  final String durationtitle;
  final List<Usereducationdatum> educationList;
  final ProfileBloc profilebloc;

  const EducationalInfo(
      {Key? key,
      this.type = "",
      this.title = "",
      this.subtitle = "",
      this.durationtitle = "",
      this.educationList = const [],
      required this.profilebloc})
      : super(key: key);

  @override
  _EducationalInfoState createState() => _EducationalInfoState();
}

class _EducationalInfoState extends State<EducationalInfo> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  Widget build(BuildContext context) {
    basicDeviceHeightWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: widget.profilebloc,
      listener: (_, state) {},
      builder: (_, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            appBloc.localstr.profileHeaderEducationtitlelabel,
            style: TextStyle(
                fontSize: 18,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
          elevation: 2,
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          actions: [
            getAddEducationButton(),
          ],
        ),
        body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: widget.profilebloc.userEducationData.length,
              itemBuilder: (context, pos) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.profilebloc.userEducationData[pos]
                                  .school,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              widget.profilebloc.userEducationData[pos]
                                  .degree,
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              widget.profilebloc.userEducationData[pos]
                                  .totalperiod,
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.h),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EducationAdd(
                                      profileBloc: widget.profilebloc,
                                      data: widget.profilebloc
                                          .userEducationData[pos]))),
                          child: Icon(Icons.edit))
                    ],
                  ),
                );
              },
          ),
        ),
      ),
    );
  }

  Widget getAddEducationButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EducationAdd(profileBloc: widget.profilebloc)));
      },
      child: Container(
        //color: Colors.red,
        margin: EdgeInsets.only(right: 10.h),
        padding: EdgeInsets.all(20.h),
        child: Center(
          child: Icon(
            Icons.add,
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            size: 24.h,
          ),
        ),
      ),
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h));
  }
}
