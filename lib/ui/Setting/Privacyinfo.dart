import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/bloc/preference_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/event/preference_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/state/preference_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/Userprofileresponse.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';

class Privacyinfo extends StatefulWidget {
  @override
  Privacypage createState() => Privacypage();
}

class Privacypage extends State<Privacyinfo> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late FToast flutterToast;
  late PreferenceBloc preferenceBloc;
  bool isToggledHead = false;
  bool isToggledClick = true;

  List<PrivacyProfileResponse> privacyInfo = [];

  bool userIsPublic = false;
  bool userIsPublicFromApi = false;

  int privacyVal = 0;
  bool privacyBool = false;
  bool firstNameBool = false;
  bool lastNameBool = false;

  @override
  void initState() {
    preferenceBloc = PreferenceBloc(preferenceRepository: PreferenceRepositoryBuilder.repository());

    preferenceBloc.add(GetPrivacyProfileEvent());
    flutterToast = FToast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast.init(context);
    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    if (isToggledClick) {
      isToggledHead = userIsPublicFromApi == null ? false : userIsPublicFromApi;
    }

    return BlocConsumer<PreferenceBloc, PreferenceState>(
        bloc: preferenceBloc,
        listener: (context, stateVal) {
          if (stateVal is GetPrivacyProfileState) {
            switch (stateVal.status) {
              case Status.LOADING:
                break;
              case Status.ERROR:
                print('error_data ${stateVal.data}');
                return (stateVal.message == '401')
                    ? AppDirectory.sessionTimeOut(context)
                    : print('dont do navigation');
              case Status.COMPLETED:
                UserProfileResponse resd = stateVal.privacyresponse;
                privacyInfo = resd.userProfileList.map((e) => PrivacyProfileResponse.fromJson(e.toJson())).toList();
                setState(() {
                  userIsPublicFromApi = resd.userIsPublic;
                });

                String ss = "";
                break;
              case Status.CONTACT:
                break;
            }
          }

          if (stateVal is PostPrivacyProfileState) {
            switch (stateVal.status) {
              case Status.LOADING:
                break;
              case Status.ERROR:
                print('error_data ${stateVal.data}');
                return (stateVal.message == '401')
                    ? AppDirectory.sessionTimeOut(context)
                    : print('dont do navigation');
              case Status.COMPLETED:
                bool privacy = stateVal.displayMessage;
                if (privacy) {
                  flutterToast.showToast(
                    child: CommonToast(displaymsg: 'Successfully saved'),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                }
                String ss = "";
                break;
              default:
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.LOADING) {
            return Container(
              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: Center(
                  child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70))),
            );
          }
          else if (preferenceBloc.userprofileresponse != null) {
            return Container(
              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      appBloc.localstr.privacyprofileinfo.isEmpty
                          ? 'Privacy Profile'
                          : appBloc.localstr.privacyprofileinfo,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ),
                    elevation: 2,
                    backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                    leading: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ),
                  ),
                  body: Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    padding: EdgeInsets.all(10.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                              height: 10,
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Your profile’s public visibility',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.h,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Switch(
                                      value: isToggledHead,
                                      activeColor:
                                          InsColor(appBloc).appBtnBgColor,
                                      onChanged: (value) {
                                        setState(() {
                                          isToggledHead = value;
                                          isToggledClick = false;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                              height: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 9,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemCount: privacyInfo.length,
                            itemBuilder: (context, position) {
                              return Card(
                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                elevation: 30,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        privacyInfo[position].groupName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: privacyInfo[position].profileList.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, pos) {
                                          return Padding(
                                            padding: EdgeInsets.fromLTRB(20.h, 7.h, 20.h, 7.h),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 8,
                                                      child: Text(
                                                        privacyInfo[position].profileList[pos].label,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        children: [
                                                          Switch(
                                                              value: privacyInfo[position].profileList[pos].name == "First̉̉Name" || privacyInfo[position].profileList[pos].name == "LastName"
                                                                  ? true
                                                                  : privacyInfo[position].profileList[pos].enabled == 1,
                                                              activeColor: InsColor(
                                                                      appBloc).appBtnBgColor,
                                                              onChanged: (value) {
                                                                if (["FirstName", "LastName"].contains(privacyInfo[position].profileList[pos].name)) {}
                                                                else {
                                                                  setState(() {
                                                                    if (value) {
                                                                      privacyInfo[position].profileList[pos].enabled = 1;
                                                                    }
                                                                    else {
                                                                      privacyInfo[position].profileList[pos].enabled = 0;
                                                                    }
                                                                  });
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // RaisedButton(
                                //     onPressed: () async {
                                //       String ids = await getinfo(alllist);
                                //       preferenceBloc.add(PostPrivacyProfileEvent(
                                //           ispublic: isToggledhead == true ? 1 : 0,
                                //           attributeids: attrid.join(",")));
                                //     },
                                //     child: Text(
                                //       "Save",
                                //       style: TextStyle(color: Colors.black),
                                //       textAlign: TextAlign.center,
                                //     )),

                                MaterialButton(
                                  disabledColor: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  child: Text(
                                      appBloc.localstr.profileButtonEditprofilesavebutton,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                  onPressed: () async {
                                    String ids = getinfo(privacyInfo);
                                    print("Ids:$ids");
                                    preferenceBloc.add(PostPrivacyProfileEvent(
                                        ispublic: isToggledHead == true ? 1 : 0,
                                        attributeids: ids,
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          else {
            return Container(
              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            );
          }
        });
  }

  String getinfo(List<PrivacyProfileResponse> list) {
    List<String> attrid = [];
    for (int i = 0; i < list.length; i++) {
      List<PrivacyProfileListResponse> infolist = list[i].profileList;
      for (int j = 0; j < infolist.length; j++) {
        if(["FirstName", "LastName"].contains(infolist[j].name)) {
          attrid.add(infolist[j].attributeConfigId.toString());
        }
        else {
          if (infolist[j].enabled == 1) {
            attrid.add(infolist[j].attributeConfigId.toString());
          }
        }
      }
    }

    return attrid.join(",");
  }
}
