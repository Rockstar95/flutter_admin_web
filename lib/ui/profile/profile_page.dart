import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/people_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/my_connection_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/myConnections/myConnection_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';
import 'package:flutter_admin_web/ui/profile/profile_edit.dart';
import 'package:flutter_admin_web/ui/profile/profile_info.dart';

import '../../configs/constants.dart';
import '../common/outline_button.dart';
import 'education_info.dart';
import 'experience_info.dart';

import '../../configs/constants.dart';


class Profile extends StatefulWidget {
  final bool isFromProfile, isMyProfile;
  final String connectionUserId;
  final PeopleModel? people;

  const Profile(
      {Key? key,
      required this.isFromProfile,
      this.isMyProfile = false,
      this.connectionUserId = "",
      this.people})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late MyConnectionBloc connectionsBloc;
  late ProfileBloc profileBloc;
  String image = "", checkEndpoint = "";
  String imageurl = "";
  String initalVal = '';
  var buffer;

  //int processGetDataSuccessCount = 0;
  bool isProfileInfoGot = false, isProfileHeaderGot = false;

  bool isFirst = true;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    //profileBloc.add(GetPrivacyProfileEvent());
    //processGetDataSuccessCount++;
    profileBloc.add(widget.isFromProfile || widget.isMyProfile
        ? GetProfileInfo()
        : GetConnectionsProfile(userId: widget.connectionUserId));

    if (!widget.isFromProfile && !widget.isMyProfile) {
      //processGetDataSuccessCount++;
      profileBloc.add(GetProfileHeaderEvent(profileUserId: widget.connectionUserId));
    }
    connectionsBloc = MyConnectionBloc(myConnectionRepository: MyConnectionRepositoryBuilder.repository());

    //getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
      basicDeviceHeightWidth(context, MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
    }

    //MyPrint.printOnConsole("processGetDataSuccessCount:${processGetDataSuccessCount}");

    return BlocConsumer<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        listener: (BuildContext context, ProfileState stateVal) {
          print('Profile Bloc Listener Called From Profile Page with Status:${stateVal.status}, State:${stateVal.runtimeType}');

          if (stateVal.status == Status.COMPLETED) {
            if (stateVal is GetProfileHeaderState) {
              isProfileHeaderGot = true;
            } else if (stateVal is GetProfileInfoState) {
              isProfileInfoGot = true;
            }
          }
          else if (stateVal.status == Status.ERROR) {
            if (stateVal is GetProfileHeaderState) {
              isProfileHeaderGot = true;
            } else if (stateVal is GetProfileInfoState) {
              isProfileInfoGot = true;
            }
          }
          else if (stateVal.status == Status.LOADING) {
            if (stateVal is GetProfileHeaderState) {
              isProfileHeaderGot = false;
            } else if (stateVal is GetProfileInfoState) {
              isProfileInfoGot = false;
            }
          }

          switch (stateVal.status) {
            case Status.LOADING:
              break;
            case Status.ERROR:
              print('error_data ${stateVal.data}');
              return (stateVal.message == '401')
                  ? AppDirectory.sessionTimeOut(context)
                  : print('dont do navigation');
            case Status.COMPLETED:
              setState(() {
                if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
                  // imageurl = appBloc.uiSettingModel.AzureRootPath +
                  //     profileBloc
                  //         .profileResponse.userprofiledetails[0].picture;

                  if (widget.isFromProfile || widget.isMyProfile) {
                    var contentPath = profileBloc
                        .profileResponse.userprofiledetails[0].picture;

                    contentPath = contentPath.length > 0
                        ? contentPath.substring(1)
                        : contentPath;
                    imageurl =
                        appBloc.uiSettingModel.azureRootPath + contentPath;

                    imageurl = imageurl.toLowerCase();
                    print("imageurl " + imageurl);
                  }
                  else {
                    imageurl =
                        '${ApiEndpoints.strSiteUrl}${profileBloc.profileResponse.userprofiledetails[0].picture}';
                    //imageurl = widget.people?.memberProfileImage ?? "";

                    //imageurl = imageurl.toLowerCase();
                    print("imageurl " + imageurl);
                  }
                }
                else {
                  imageurl =
                      '${ApiEndpoints.strSiteUrl}${profileBloc.profileResponse.userprofiledetails[0].picture}';
                }

                try {
                  String name = profileBloc.profileResponse.userprofiledetails[0].firstname +
                      " " +
                      profileBloc
                          .profileResponse.userprofiledetails[0].lastname;
                  List<String> nameinfo = name.split(" ");
                  buffer = new StringBuffer();
                  if (nameinfo.length > 1) {
                    for (int i = 0; i < nameinfo.length; i++) {
                      buffer.write(nameinfo[i][0]);
                    }
                  }
                  if (nameinfo.length == 1) {
                    buffer.write(name[0]);
                  } else {}
                } catch (e) {
                  print(e);
                }
                initalVal = buffer.toString();

                // initalVal = profileBloc.profileResponse.userprofiledetails[0].firstname[0];

                if (widget.isFromProfile || widget.isMyProfile) {
                  setImageVal(profileBloc
                      .profileResponse.userprofiledetails[0].picture);
                }
                print('myurldata $imageurl');
              });

              break;
            default:
          }

          print('mystatee_LISTERN${stateVal.status} $stateVal');
        },
        builder: (context, state) {
          bool allDataGot = false;
          if (widget.isFromProfile || widget.isMyProfile) {
            allDataGot = isProfileInfoGot;
          }
          else {
            allDataGot = isProfileInfoGot && isProfileHeaderGot;
          }

          if (!allDataGot || state.status == Status.LOADING) {
            return Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: Center(
                  child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70),)),
            );
          } else if (profileBloc.profileResponse != null) {
            Userprofiledetail? userProfileDetail =
                profileBloc.profileResponse.userprofiledetails.isNotEmpty
                    ? profileBloc.profileResponse.userprofiledetails.first
                    : null;
            String firstName =
                userProfileDetail != null ? userProfileDetail.firstname : "";
            String lastName =
                userProfileDetail != null ? userProfileDetail.lastname : "";
            return Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  appBar: widget.isFromProfile
                      ? null
                      : AppBar(
                          title: Text(
                            'Profile',
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                          backgroundColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                          iconTheme: IconThemeData(
                            color: Colors.black,
                          ), //change your color here
                        ),
                  body: Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.h, vertical: 20.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 90.h,
                                  width: 100.h,
                                  child: Stack(
                                    children: <Widget>[
                                      ClipOval(
                                        child: (widget.isFromProfile || widget.isMyProfile)
                                            ? Container(
                                                child: (checkEndpoint == null ||
                                                        checkEndpoint.isEmpty)
                                                    ? CircleAvatar(
                                                        radius: 45.h,
                                                        child: Text(
                                                          initalVal,
                                                          style: TextStyle(
                                                              fontSize: 30.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              // color: AppColors.getAppTextColor()),
                                                              color: Colors.white),
                                                        ),
                                                        backgroundColor: Color(
                                                            int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: MyUtils.getSecureUrl(imageurl != null
                                                                ? imageurl
                                                                : image),
                                                        width: 90.h,
                                                        height: 90.h,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                CircleAvatar(
                                                          radius: 45.h,
                                                          child: Text(
                                                            initalVal,
                                                            style: TextStyle(
                                                                fontSize: 30.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors.white),
                                                          ),
                                                          backgroundColor:
                                                              Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            CircleAvatar(
                                                          radius: 45.h,
                                                          child: Text(
                                                            initalVal,
                                                            style: TextStyle(
                                                                fontSize: 30.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors.white),
                                                          ),
                                                          backgroundColor:
                                                              Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        ),
                                                      ))
                                            : Container(
                                                child: (!imageurl
                                                            .toString()
                                                            .contains('png') &&
                                                        !imageurl
                                                            .toString()
                                                            .contains('jpg'))
                                                    ? CircleAvatar(
                                                        radius: 45.h,
                                                        child: Text(
                                                          initalVal,
                                                          style: TextStyle(
                                                              fontSize: 30.h,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white),
                                                        ),
                                                        backgroundColor: Color(
                                                            int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: MyUtils.getSecureUrl(imageurl != null
                                                                ? imageurl
                                                                : image),
                                                        width: 90.h,
                                                        height: 90.h,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                CircleAvatar(
                                                          radius: 45.h,
                                                          child: Text(
                                                            initalVal,
                                                            style: TextStyle(
                                                                fontSize: 30.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors.white),
                                                          ),
                                                          backgroundColor:
                                                              Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            CircleAvatar(
                                                          radius: 45.h,
                                                          child: Text(
                                                            initalVal,
                                                            style: TextStyle(
                                                                fontSize: 30.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors.white),
                                                          ),
                                                          backgroundColor:
                                                              Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        ),
                                                      )),
                                      ),
//
                                      Positioned(
                                        bottom: 10.h,
                                        left: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 8.h,
                                          width: 8.h,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0.h,
                                        right: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 12.h,
                                          width: 12.h,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0.h,
                                        right: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 16.h,
                                          width: 16.h,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.isFromProfile || widget.isMyProfile,
                                  child: Container(
                                      height: 100.h,
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileInfo(
                                                          profileImg: imageurl,
                                                          bloc: profileBloc))),
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          ))),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              '$firstName $lastName',
                              style: TextStyle(
                                  fontSize: 20.h,
                                  letterSpacing: 0.5,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),

                            /*
                            SizedBox(
                              height: 40.h,
                            ),
                            profileBloc.profileResponse.userprofiledetails[0]
                                        .jobtitle !=
                                    null
                                ? Text(
                                    'JOB TITLE',
                                    style: TextStyle(
                                        fontSize: 18.h,
                                        letterSpacing: 2,
                                        ,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  )
                                : Container(),
                            */
                            SizedBox(
                              height: 5.h,
                            ),
                            (userProfileDetail?.jobtitle) != null
                                ? Text(
                                    '${userProfileDetail!.jobtitle}',
                                    style: TextStyle(
                                        fontSize: 15.h,
                                        letterSpacing: 0.5,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  )
                                : Container(),
                            // SizedBox(
                            //   height: 16.h,
                            // ),
                            BlocConsumer<MyConnectionBloc, MyConnectionState>(
                                bloc: connectionsBloc,
                                listener: (context, state) {
                                  if (state is AddConnectionState &&
                                      state.status == Status.COMPLETED &&
                                      connectionsBloc.isAddLoading == false) {
                                    _showConfirmationDialog(
                                        context, state.message);
                                  }

                                  print('image url ' + imageurl);

                                  setState(() {
                                    imageurl =
                                        '${ApiEndpoints.strSiteUrl}${profileBloc.profileHeader.profilepath}';

                                    print('image url ' + imageurl);
                                  });
                                },
                                builder: (context, state) {
                                  if (state.status == Status.LOADING) {
                                    return Container(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                      child: Center(
                                          child: AbsorbPointer(
                                              child: AppConstants().getLoaderWidget(iconSize: 50),)),
                                    );
                                  }

                                  return (!widget.isFromProfile && !widget.isMyProfile
                                      ? ConnectedUserStatusView(
                                          appBloc: appBloc,
                                          connectionsBloc: connectionsBloc,
                                          profileBloc: profileBloc,
                                          connectedUserId: widget.connectionUserId,
                                          connectedUserName: widget.people?.userDisplayname ?? "User",
                                        )
                                      : Container());
                                }),
                            SizedBox(
                              height: 16.h,
                            ),
                            // Row(
                            //   children: [
                            //     userProfileDetail?.nvarchar6 != null
                            //         ? Text(
                            //             'About',
                            //             style: TextStyle(
                            //                 fontSize: 18.h,
                            //                 letterSpacing: 2,
                            //                 color: Color(int.parse(
                            //                     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            //           )
                            //         : Container(),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 5.h,
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: userProfileDetail?.nvarchar6 != null
                            //           ? Text(
                            //               (userProfileDetail!.nvarchar6) !=
                            //                       'null'
                            //                   ? userProfileDetail.nvarchar6
                            //                   : '-',
                            //               style: TextStyle(
                            //                   fontSize: 14.h,
                            //                   color: Color(int.parse(
                            //                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            //             )
                            //           : Container(),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 8.h,
                            // ),
                            // Row(
                            //   children: <Widget>[
                            //     Icon(
                            //       Icons.email,
                            //       color: Colors.grey,
                            //     ),
                            //     SizedBox(
                            //       width: 5.h,
                            //     ),
                            //     Text(
                            //       '${userProfileDetail?.email ?? ""}',
                            //       style: TextStyle(
                            //           color: Color(int.parse(
                            //               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            //     )
                            //   ],
                            // ),
                            profileInfoCard(),
                            contactInfoCard(),
                            experienceInfoCard(),
                            educationInfoCard()
                            // TOD: Experience
                            // Visibility(
                            //   visible: widget.isFromProfile
                            //       ? true
                            //       : profileBloc.profileResponse
                            //               .userexperiencedata.length >
                            //           0,
                            //   child: Row(
                            //     children: <Widget>[
                            //       SizedBox(
                            //         height: 40.h,
                            //       ),
                            //       Text(
                            //         'Experience',
                            //         style: TextStyle(
                            //           fontSize: 18.h,
                            //           letterSpacing: 2,
                            //           color: Color(int.parse(
                            //               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 10.h,
                            //       ),
                            //       Visibility(
                            //         visible: widget.isFromProfile,
                            //         child: InkWell(
                            //             onTap: () => Navigator.of(context).push(
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         ProfessionalInfo(
                            //                             profileBloc:
                            //                                 profileBloc,
                            //                             experienceList: profileBloc
                            //                                 .profileResponse
                            //                                 .userexperiencedata))),
                            //             child: Icon(
                            //               Icons.edit,
                            //               color: Color(int.parse(
                            //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            //             )),
                            //       ),
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // ProfileStepper(
                            //   appBloc: appBloc,
                            //   expData: profileBloc.userExperienceData,
                            //   color: Colors.orange,
                            // ),

                            //TOD: Education
                            // Visibility(
                            //   visible: widget.isFromProfile
                            //       ? true
                            //       : profileBloc.profileResponse
                            //               .usereducationdata.length >
                            //           0,
                            //   child: Row(
                            //     children: <Widget>[
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //       Text(
                            //         'Education',
                            //         style: TextStyle(
                            //             fontSize: 18.h,
                            //             letterSpacing: 2,
                            //             color: Color(int.parse(
                            //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            //       ),
                            //       SizedBox(
                            //         width: 10.h,
                            //       ),
                            //       Visibility(
                            //         visible: widget.isFromProfile,
                            //         child: InkWell(
                            //             onTap: () => Navigator.of(context).push(
                            //                 MaterialPageRoute(
                            //                     builder:
                            //                         (context) => EducationalInfo(
                            //                             educationList: profileBloc
                            //                                 .profileResponse
                            //                                 .usereducationdata,
                            //                             profilebloc:
                            //                                 profileBloc))),
                            //             child: Icon(
                            //               Icons.edit,
                            //               color: Color(int.parse(
                            //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            //             )),
                            //       ),
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // EducationStepper(
                            //   appBloc: appBloc,
                            //   educationData: profileBloc.userEducationData,
                            //   color: Colors.lightBlue.shade400,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.isNotEmpty ? appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase() : "000000"}")),
            );
          }
        });
  }

  // Widget mainBody(){
  //
  // }

  Widget profileInfoCard(){
    if(!widget.isFromProfile && !widget.isMyProfile && profileBloc.userProfileData.isEmpty) {
      return SizedBox();
    }

    return  Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Personal Information',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.h,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    textAlign: TextAlign.start,
                  ),
                  Visibility(
                    visible: widget.isFromProfile || widget.isMyProfile,
                    child: InkWell(
                        onTap: () {
                          profileBloc.add(AssignProfileVal());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileEdit(
                                          bloc: profileBloc,
                                          profielDataField:
                                          profileBloc
                                              .editUserData,
                                          title:
                                          'Profile Info')));
                        },
                        child: Icon(
                          Icons.edit,
                          color: InsColor(appBloc).appTextColor,
                        )),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListView.builder(
                itemCount: profileBloc.userProfileData.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(8.h),
                    child: commonListTile( profileBloc.userProfileData[i].attributedisplaytext,profileBloc.userProfileData[i].valueName),

                    // Column(
                    //   crossAxisAlignment:
                    //   CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     // Text(
                    //     //   profileBloc.userProfileData[i]
                    //     //       .attributedisplaytext,
                    //     //   style: TextStyle(
                    //     //       fontSize: 14.h,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       color: Color(int.parse(
                    //     //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    //     // ),
                    //     // Text(
                    //     //     profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         .isNotEmpty &&
                    //     //         profileBloc.userProfileData[i]
                    //     //             .valueName !=
                    //     //             'null'
                    //     //         ? profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         : 'NA',
                    //     //     style: TextStyle(
                    //     //         fontSize: 16.h,
                    //     //         fontWeight: FontWeight.w400,
                    //     //         color: Color(int.parse(
                    //     //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    //   ],
                    // ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget contactInfoCard(){
    if(!widget.isFromProfile && !widget.isMyProfile && profileBloc.userContactData.isEmpty) {
      return SizedBox();
    }

    return   (profileBloc.userContactData.length > 0)
        ? Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
              EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Contact Information',
                    style: TextStyle(
                        // fontWeight: FontWeight.w300,
                        fontSize: 18.h,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    textAlign: TextAlign.start,
                  ),
                  Visibility(
                    visible: widget.isFromProfile || widget.isMyProfile,
                    child: InkWell(
                        onTap: () {
                          profileBloc
                              .add(AssignProfileVal());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileEdit(
                                          bloc:
                                          profileBloc,
                                          profielDataField:
                                          profileBloc
                                              .editContactData,
                                          isContact: true,
                                          title:
                                          'Contact Info')));
                        },
                        child: Icon(
                          Icons.edit,
                          color: InsColor(appBloc)
                              .appTextColor,
                        )),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListView.builder(
                itemCount:
                profileBloc.userContactData.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: commonListTile( profileBloc.userContactData[i].attributedisplaytext,profileBloc.userContactData[i].valueName),
                  );
                  //   Padding(
                  //   padding: EdgeInsets.all(8.h),
                  //   child: Column(
                  //     crossAxisAlignment:
                  //     CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         profileBloc.userContactData[i]
                  //             .attributedisplaytext,
                  //         style: TextStyle(
                  //             fontSize: 16.h,
                  //             fontWeight:
                  //             FontWeight.w600,
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                  //       ),
                  //       Text(
                  //           profileBloc.userContactData[i].valueName.isNotEmpty
                  //               ? profileBloc
                  //               .userContactData[i]
                  //               .valueName
                  //               : 'NA',
                  //           style: TextStyle(
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  //             fontSize: 16.h,
                  //           )),
                  //     ],
                  //   ),
                  // );
                }),
          ],
        ),
      ),
    ):Container();
  }

  Widget experienceInfoCard(){
    if(!widget.isFromProfile && !widget.isMyProfile && profileBloc.userExperienceData.isEmpty) {
      return SizedBox();
    }

    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Experience',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.h,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    textAlign: TextAlign.start,
                  ),
                  Visibility(
                    visible: widget.isFromProfile || widget.isMyProfile,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfessionalInfo(
                                                          profileBloc:
                                                              profileBloc,
                                                          experienceList: profileBloc
                                                              .profileResponse
                                                              .userexperiencedata)));
                        },
                        child: Icon(
                          Icons.edit,
                          color: InsColor(appBloc).appTextColor,
                        )),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListView.builder(
                itemCount: profileBloc.userExperienceData.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: 86.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                profileBloc.userExperienceData[i].title,
                                style: TextStyle(
                                    fontSize: 12,
                                    //fontWeight: FontWeight.w300,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                profileBloc.userExperienceData[i].companyname,
                                style: TextStyle(
                                  color: AppColors.getAppTextColor(),
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                (profileBloc.userExperienceData[i].tilldate)
                                    ? '${profileBloc.userExperienceData[i].fromdate} - Present'
                                    : '${profileBloc.userExperienceData[i].fromdate} - ${profileBloc.userExperienceData[i].todate}',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.h),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )

                    // Column(
                    //   crossAxisAlignment:
                    //   CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     // Text(
                    //     //   profileBloc.userProfileData[i]
                    //     //       .attributedisplaytext,
                    //     //   style: TextStyle(
                    //     //       fontSize: 14.h,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       color: Color(int.parse(
                    //     //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    //     // ),
                    //     // Text(
                    //     //     profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         .isNotEmpty &&
                    //     //         profileBloc.userProfileData[i]
                    //     //             .valueName !=
                    //     //             'null'
                    //     //         ? profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         : 'NA',
                    //     //     style: TextStyle(
                    //     //         fontSize: 16.h,
                    //     //         fontWeight: FontWeight.w400,
                    //     //         color: Color(int.parse(
                    //     //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    //   ],
                    // ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget educationInfoCard(){
    if(!widget.isFromProfile && !widget.isMyProfile && profileBloc.userEducationData.isEmpty) {
      return SizedBox();
    }

    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Education',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.h,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    textAlign: TextAlign.start,
                  ),
                  Visibility(
                    visible: widget.isFromProfile || widget.isMyProfile,
                    child: InkWell(
                        onTap: () {
                          profileBloc.add(AssignProfileVal());
                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => EducationalInfo(
                                                          educationList: profileBloc
                                                              .profileResponse
                                                              .usereducationdata,
                                                          profilebloc:
                                                              profileBloc)));
                        },
                        child: Icon(
                          Icons.edit,
                          color: InsColor(appBloc).appTextColor,
                        )),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListView.builder(
                itemCount: profileBloc.userEducationData.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: 86.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  profileBloc.userEducationData[i].school,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}"))),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  profileBloc.userEducationData[i].degree,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}"))),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  profileBloc.userEducationData[i].totalperiod,
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.h),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )

                    // Column(
                    //   crossAxisAlignment:
                    //   CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     // Text(
                    //     //   profileBloc.userProfileData[i]
                    //     //       .attributedisplaytext,
                    //     //   style: TextStyle(
                    //     //       fontSize: 14.h,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       color: Color(int.parse(
                    //     //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    //     // ),
                    //     // Text(
                    //     //     profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         .isNotEmpty &&
                    //     //         profileBloc.userProfileData[i]
                    //     //             .valueName !=
                    //     //             'null'
                    //     //         ? profileBloc.userProfileData[i]
                    //     //         .valueName
                    //     //         : 'NA',
                    //     //     style: TextStyle(
                    //     //         fontSize: 16.h,
                    //     //         fontWeight: FontWeight.w400,
                    //     //         color: Color(int.parse(
                    //     //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    //   ],
                    // ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget commonListTile(String title, String subTitle){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 13.h,
              fontWeight: FontWeight.w400,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        SizedBox(height:5.h,),
        Text(
            subTitle.isNotEmpty && subTitle != 'null'
                ? subTitle
                : 'NA',
            style: TextStyle(
                fontSize: 17.h,
                fontWeight: FontWeight.w500,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
      ],
    );
  }

  _showConfirmationDialog(BuildContext context, String message) async {
    //print("MESSAGE :" + message);
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: InsColor(appBloc).appBGColor,
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: new Text(message,
                        style:
                            TextStyle(color: InsColor(appBloc).appTextColor)),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  basicDeviceHeightWidth(BuildContext context, double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), context: context);
  }

  void getProfileInfo() async {
    image = await sharePrefGetString(sharedPref_image);
    checkEndpoint = await sharePrefGetString(sharedPref_image);
    initalVal = await sharePrefGetString(sharedPref_LoginUserName);
    if (initalVal.isNotEmpty || initalVal != null) {
      initalVal = initalVal[0];
    }

    if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
      image = appBloc.uiSettingModel.azureRootPath +
          "Content/SiteFiles/374/ProfileImages/" +
          image;
    } else {
      image = ApiEndpoints.strSiteUrl +
          "Content/SiteFiles/374/ProfileImages/" +
          image;
    }
    print('getimage $image');
  }

  Future<void> setImageVal(String picture) async {
    String tempImg;

    picture =
        picture.startsWith('/', 0) ? picture.replaceFirst('/', '', 0) : picture;

    if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
      tempImg = appBloc.uiSettingModel.azureRootPath + picture;
      tempImg = tempImg.toLowerCase();
    } else {
      tempImg = '${ApiEndpoints.strSiteUrl}$picture';
    }
    await sharePrefSaveString(sharedPref_tempProfileImage, tempImg);

    checkEndpoint = tempImg;
    print('pictureval $picture');
    setState(() {});
//   await sharePref_saveString(sharedPref_image,picture);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<ProfileBloc>('profileBloc', profileBloc));
  }
}

class ConnectedUserStatusView extends StatelessWidget {
  const ConnectedUserStatusView({
    Key? key,
    required this.appBloc,
    required this.connectionsBloc,
    required this.profileBloc,
    required this.connectedUserId,
    required this.connectedUserName,
  }) : super(key: key);

  final AppBloc appBloc;
  final MyConnectionBloc connectionsBloc;
  final ProfileBloc profileBloc;
  final String connectedUserId;
  final String connectedUserName;

  Color getStatusColor(String state) {
    if (state == "Already Connected") {
      return Colors.green;
    } else if (state == "Request Pending") {
      return Color.fromRGBO(0, 123, 255, 1); //fromARGB(1, 0, 123, 255);
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Status:${profileBloc.profileHeader.connectionState}");

    return Container(
      child: Column(
        children: [
          Visibility(
            visible: profileBloc.profileHeader.connectionState.isNotEmpty && profileBloc.profileHeader.connectionState != 'Already Connected',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Text(profileBloc.profileHeader.connectionState,
                      style: TextStyle(
                        color: getStatusColor(
                            profileBloc.profileHeader.connectionState),
                        fontSize: 13,
                      ))),
            ),
          ),
          //SizedBox(height: 16),
          profileBloc.profileHeader.connectionState.trim() ==
                  "Already Connected"
              ? Container(
                  height: 30,
                  child: OutlineButton(
                    border: Border.all(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                    child: Text(
                        appBloc.localstr
                            .myconnectionsActionsheetRemoveconnectionoption,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            backgroundColor: InsColor(appBloc).appBGColor,
                            contentPadding: const EdgeInsets.all(8.0),
                            content: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        appBloc.localstr
                                            .myconnectionsAlertsubtitleAreyousurewanttoremoveconnection,
                                        style: TextStyle(
                                            color: InsColor(appBloc)
                                                .appTextColor)),
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                  child: Text(appBloc.localstr
                                      .mylearningAlertbuttonCancelbutton),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  }),
                              new FlatButton(
                                  child: Text(appBloc
                                      .localstr.myskillAlerttitleStringconfirm),
                                  onPressed: () {
                                    connectionsBloc.add(AddConnectionEvent(
                                        selectedObjectID:
                                            int.parse(this.connectedUserId),
                                        userName: connectedUserName,
                                        selectAction: 'RemoveConnection'));
                                    Navigator.pop(context);
                                    profileBloc.add(GetProfileHeaderEvent(
                                        profileUserId: connectedUserId));
                                    //Navigator.pop(context);
                                  })
                            ],
                          );
                        },
                      ); //Navigator.pop(context);
                    },
                  ),
                ) //RemoveConnection Action
              : profileBloc.profileHeader.connectionState.trim() ==
                      "Request Pending"
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            child: OutlineButton(
                              border: Border.all(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                              child: Text('Accept',
                                  //appBloc.localstr
                                  //.myconnectionsActionsheetAcceptconnectionoption,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () {
                                connectionsBloc.add(AddConnectionEvent(
                                    selectedObjectID:
                                        int.parse(this.connectedUserId),
                                    userName: connectedUserName,
                                    selectAction: 'Accept'));
                                profileBloc.add(GetProfileHeaderEvent(
                                    profileUserId:
                                        connectedUserId)); //Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 30,
                            child: OutlineButton(
                              border: Border.all(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                              child: Text('Reject',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () {
                                connectionsBloc.add(AddConnectionEvent(
                                    selectedObjectID:
                                        int.parse(this.connectedUserId),
                                    userName: connectedUserName,
                                    selectAction: 'Ignore'));
                                profileBloc.add(GetProfileHeaderEvent(
                                    profileUserId:
                                        connectedUserId)); //Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ) //AcceptConnection Action
                  : profileBloc.profileHeader.connectionState !=
                          "Acceptance Pending"
                      ?

          CommonPrimarySecondaryButton(
            isPrimary: true,
                          text:  appBloc.localstr.myconnectionsActionsheetAddtomyconnectionsoption,
                          // border: Border.all(
                          //     color: Color(int.parse(
                          //         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                          // child: Text(
                          //
                          //     style: TextStyle(
                          //         fontSize: 14,
                          //         color: Color(int.parse(
                          //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                          onPressed: () {
                            connectionsBloc.add(AddConnectionEvent(
                                selectedObjectID:
                                    int.parse(this.connectedUserId),
                                userName: connectedUserName,
                                selectAction:
                                    'AddConnection')); //Navigator.pop(context);
                          },
                        )
                      : Container()
        ],
      ),
    );
    /*return profileBloc?.profileHeader?.connectionState == "Already Connected" ||
            profileBloc?.profileHeader?.connectionState == "Request Pending"
        ? Container(
            child: Column(
              children: [
                Center(
                    child: Text(
                        profileBloc?.profileHeader?.connectionState ?? '',
                        style: TextStyle(color: Colors.orange, fontSize: 13))),
                SizedBox(height: 16),
                profileBloc?.profileHeader?.connectionState ==
                        "Already Connected"
                    ? Container(
                        height: 30,
                        child: OutlineButton(
                          borderSide: BorderSide(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          child: Text(
                              appBloc.localstr
                                  .myconnectionsActionsheetRemoveconnectionoption,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return new AlertDialog(
                                    backgroundColor: Colors.white,
                                    contentPadding: const EdgeInsets.all(8.0),
                                    content: new Row(
                                      children: <Widget>[
                                        new Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(appBloc.localstr
                                                .myconnectionsAlertsubtitleAreyousurewanttoremoveconnection),
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                          child: Text(appBloc.localstr
                                              .mylearningAlertbuttonCancelbutton),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          }),
                                      new FlatButton(
                                          child: Text(appBloc.localstr
                                              .myskillAlerttitleStringconfirm),
                                          onPressed: () {
                                            connectionsBloc.add(
                                                AddConnectionEvent(
                                                    SelectedObjectID:
                                                        profileBloc
                                                            ?.profileResponse
                                                            ?.siteusersinfo
                                                            ?.first
                                                            ?.userid,
                                                    UserName: connectedUserName,
                                                    SelectAction:
                                                        'RemoveConnection'));
                                            Navigator.pop(context);
                                            profileBloc.add(
                                                GetProfileHeaderEvent(
                                                    profileUserId:
                                                        connectedUserId));
                                            //Navigator.pop(context);
                                          })
                                    ],
                                  );
                                }); //Navigator.pop(context);
                          },
                        ),
                      ) //RemoveConnection Action
                    : profileBloc?.profileHeader?.connectionState ==
                            "Request Pending"
                        ? Container(
                            height: 30,
                            child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              child: Text(
                                  appBloc.localstr
                                      .myconnectionsActionsheetAcceptconnectionoption,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () {
                                connectionsBloc.add(AddConnectionEvent(
                                    SelectedObjectID: profileBloc
                                        ?.profileResponse
                                        ?.siteusersinfo
                                        ?.first
                                        ?.userid,
                                    UserName: profileBloc?.profileResponse
                                        ?.siteusersinfo?.first?.displayname,
                                    SelectAction: 'Accept'));
                                profileBloc.add(GetProfileHeaderEvent(
                                    profileUserId:
                                        connectedUserId)); //Navigator.pop(context);
                              },
                            ),
                          ) //AcceptConnection Action
                        : Container()
              ],
            ),
          )
        : OutlineButton(
            borderSide: BorderSide(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
            child: Text("Connect",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
            onPressed: () {
              connectionsBloc.add(AddConnectionEvent(
                  SelectedObjectID: profileBloc
                      ?.profileResponse?.siteusersinfo?.first?.userid,
                  UserName: profileBloc
                      ?.profileResponse?.siteusersinfo?.first?.displayname,
                  SelectAction: 'AddConnection'));
              //Navigator.pop(context);
            },
          );*/
  }
}
