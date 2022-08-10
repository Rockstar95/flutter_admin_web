import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/ui/profile/experience_add_edit.dart';

class ProfessionalInfo extends StatefulWidget {
  final String type;
  final String title;
  final String subtitle;
  final String durationtitle;
  final List<Userexperiencedatum> experienceList;
  final ProfileBloc profileBloc;

  const ProfessionalInfo(
      {Key? key,
      this.type = "",
      this.title = "",
      this.subtitle = "",
      this.durationtitle = "",
      this.experienceList = const [],
      required this.profileBloc})
      : super(key: key);

  @override
  _ProfessionalInfoState createState() => _ProfessionalInfoState();
}

class _ProfessionalInfoState extends State<ProfessionalInfo> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  Widget build(BuildContext context) {
    basicDeviceHeightWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: widget.profileBloc,
      listener: (_, s) {},
      builder: (_, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            appBloc.localstr.profileHeaderExperiencetitlelabel,
            style: TextStyle(
                fontSize: 20,
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
              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          actions: [
            getAddExperienceButton(),
          ],
        ),
        body: Container(
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.profileBloc.userExperienceData.length,
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
                                  widget.profileBloc.userExperienceData[pos]
                                      .title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  widget.profileBloc.userExperienceData[pos]
                                      .companyname,
                                  style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  (widget.profileBloc.userExperienceData[pos]
                                          .tilldate)
                                      ? '${widget.profileBloc.userExperienceData[pos].fromdate} - Present'
                                      : '${widget.profileBloc.userExperienceData[pos].fromdate} - ${widget.profileBloc.userExperienceData[pos].todate}',
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
                                      builder: (context) => ExperienceAdd(
                                          profileBloc: widget.profileBloc,
                                          data: widget.profileBloc
                                              .userExperienceData[pos]))),
                              child: Icon(
                                Icons.edit,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ))
                        ],
                      ),
                    );
                  },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getAddExperienceButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExperienceAdd(profileBloc: widget.profileBloc,)));
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
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }
}
