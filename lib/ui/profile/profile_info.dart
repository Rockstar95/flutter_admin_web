import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/profile/profile_edit.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../configs/constants.dart';

class ProfileInfo extends StatefulWidget {
  final ProfileBloc bloc;
  final String profileImg;

  const ProfileInfo({Key? key, required this.bloc, required this.profileImg})
      : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  // File? _image;
  // File? _cameraImage;
  String _imageBase64 = "";
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  late RegExp regExp;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late FToast flutterToast;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  var image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    regExp = RegExp(pattern);

    getProfileInfo();
  }

  void getProfileInfo() async {
    image = await sharePrefGetString(sharedPref_image);

    setState(() {
      if (appBloc.uiSettingModel.isCloudStorageEnabled == 'true') {
        image = appBloc.uiSettingModel.azureRootPath +
            "Content/SiteFiles/374/ProfileImages/" +
            image;
      } else {
        image = ApiEndpoints.strSiteUrl +
            "Content/SiteFiles/374/ProfileImages/" +
            image;
      }
    });

    print('getimage $image');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    basicDeviceHeightWidth(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    flutterToast = FToast();
    flutterToast.init(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is GetProfileInfoState) {
          if (state.status == Status.COMPLETED) {
            setImageVal(
                widget.bloc.profileResponse.userprofiledetails[0].picture);

//            Navigator.of(context).pop();
          } else if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            } else {
              flutterToast.showToast(
                child:
                    CommonToast(displaymsg: 'Something went wrong. Try later'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              );
            }
          }
        } else if (state is UploadImageState || state is UpdateProfileState) {
          switch (state.status) {
            case Status.COMPLETED:
              break;
            case Status.ERROR:
              if (state.message == '401') {
                AppDirectory.sessionTimeOut(context);
              } else {
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg: 'Something went wrong. Try later'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 2),
                );
              }
              break;
            default:
          }
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        appBar: AppBar(
          title: Text(
            'About',
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
            child: Icon(Icons.arrow_back,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.h),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 120.h,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 105.h,
                              child: _imageBytes == null
                                  ? ClipOval(
                                      child: (widget.profileImg == null ||
                                              widget.profileImg.isEmpty)
                                          ? CircleAvatar(
                                              radius: 55.h,
                                              child: Text(
                                                widget
                                                    .bloc
                                                    .profileResponse
                                                    .userprofiledetails[0]
                                                    .firstname[0],
                                                style: TextStyle(
                                                    fontSize: 30.h,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                              backgroundColor: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: MyUtils.getSecureUrl(widget.profileImg != null
                                                      ? widget.profileImg
                                                      : image),
                                              width: 105.h,
                                              height: 105.h,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                radius: 45.h,
                                                child: Text(
                                                  widget
                                                      .bloc
                                                      .profileResponse
                                                      .userprofiledetails[0]
                                                      .firstname[0],
                                                  style: TextStyle(
                                                      fontSize: 30.h,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                                backgroundColor: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                radius: 55.h,
                                                child: Text(
                                                  widget
                                                      .bloc
                                                      .profileResponse
                                                      .userprofiledetails[0]
                                                      .firstname[0],
                                                  style: TextStyle(
                                                      fontSize: 30.h,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                                backgroundColor: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                              ),
                                            ))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        _imageBytes!,
                                        fit: BoxFit.cover,
                                        width: 105.h,
                                        height: 105.h,
                                      )),
                            ),
                            Positioned(
                              bottom: 0.h,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    padding: EdgeInsets.all(5.h),
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) =>
                                                      new AlertDialog(
                                                        title: Text(
                                                          'Choose Image From',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                        ),
                                                        content: Container(
                                                          height: 100.h,
                                                          child: Column(
                                                            children: <Widget>[
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              InkWell(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                        Icons
                                                                            .camera_alt,
                                                                        color: InsColor(appBloc)
                                                                            .appTextColor),
                                                                    SizedBox(
                                                                      width:
                                                                          10.h,
                                                                    ),
                                                                    Text(
                                                                      'Camera',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  _onImageButtonPressed(
                                                                      ImageSource
                                                                          .camera,
                                                                      context:
                                                                          context);
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              Divider(),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              InkWell(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                        Icons
                                                                            .image,
                                                                        color: InsColor(appBloc)
                                                                            .appTextColor),
                                                                    SizedBox(
                                                                      width:
                                                                          10.h,
                                                                    ),
                                                                    Text(
                                                                      'Gallery',
                                                                      style: TextStyle(
                                                                          color:
                                                                              InsColor(appBloc).appTextColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  _onImageButtonPressed(
                                                                      ImageSource
                                                                          .gallery,
                                                                      context:
                                                                          context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        backgroundColor: Color(
                                                            int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .circular(5)),
                                                      ));
                                        },
                                        child: Icon(Icons.camera_alt,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Card(
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
                                      'Profile Info',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.h,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      textAlign: TextAlign.start,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          widget.bloc.add(AssignProfileVal());
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileEdit(
                                                          bloc: widget.bloc,
                                                          profielDataField:
                                                              widget.bloc
                                                                  .editUserData,
                                                          title:
                                                              'Profile Info')));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: InsColor(appBloc).appTextColor,
                                        ))
                                  ],
                                ),
                              ),
                              Divider(),
                              ListView.builder(
                                  itemCount: widget.bloc.userProfileData.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: EdgeInsets.all(8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.bloc.userProfileData[i]
                                                .attributedisplaytext,
                                            style: TextStyle(
                                                fontSize: 16.h,
                                                fontWeight: FontWeight.w600,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                          ),
                                          Text(
                                              widget
                                                          .bloc
                                                          .userProfileData[i]
                                                          .valueName
                                                          .isNotEmpty &&
                                                      widget
                                                              .bloc
                                                              .userProfileData[
                                                                  i]
                                                              .valueName !=
                                                          'null'
                                                  ? widget
                                                      .bloc
                                                      .userProfileData[i]
                                                      .valueName
                                                  : 'NA',
                                              style: TextStyle(
                                                  fontSize: 16.h,
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      (widget.bloc.userContactData != null &&
                              widget.bloc.userContactData.length > 0)
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
                                            'Contact Info',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.h,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            textAlign: TextAlign.start,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                widget.bloc
                                                    .add(AssignProfileVal());
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileEdit(
                                                                bloc:
                                                                    widget.bloc,
                                                                profielDataField:
                                                                    widget.bloc
                                                                        .editContactData,
                                                                isContact: true,
                                                                title:
                                                                    'Contact Info')));
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: InsColor(appBloc)
                                                    .appTextColor,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                        itemCount:
                                            widget.bloc.userContactData.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: EdgeInsets.all(8.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.bloc.userContactData[i]
                                                      .attributedisplaytext,
                                                  style: TextStyle(
                                                      fontSize: 16.h,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                                Text(
                                                    widget
                                                            .bloc
                                                            .userContactData[i]
                                                            .valueName
                                                            .isNotEmpty
                                                        ? widget
                                                            .bloc
                                                            .userContactData[i]
                                                            .valueName
                                                        : 'NA',
                                                    style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                      fontSize: 16.h,
                                                    )),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 20.h,
                      ),
                      (widget.bloc.userBackOfficeData != null &&
                              widget.bloc.userBackOfficeData.length > 0)
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
                                            'Back Office',
                                            style: TextStyle(
                                                fontSize: 18.h,
                                                fontWeight: FontWeight.bold,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            textAlign: TextAlign.start,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                widget.bloc
                                                    .add(AssignProfileVal());
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileEdit(
                                                                bloc:
                                                                    widget.bloc,
                                                                profielDataField:
                                                                    widget.bloc
                                                                        .editBackOfficeData,
                                                                title:
                                                                    'Back Office')));
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: InsColor(appBloc)
                                                    .appTextColor,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                        itemCount: widget
                                            .bloc.userBackOfficeData.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: EdgeInsets.all(8.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget
                                                      .bloc
                                                      .userBackOfficeData[i]
                                                      .attributedisplaytext,
                                                  style: TextStyle(
                                                      fontSize: 16.h,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                                Text(
                                                  widget
                                                          .bloc
                                                          .userBackOfficeData[i]
                                                          .valueName
                                                          .isNotEmpty
                                                      ? widget
                                                          .bloc
                                                          .userBackOfficeData[i]
                                                          .valueName
                                                      : 'NA',
                                                  style: TextStyle(
                                                      fontSize: 16.h,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
            state.status == Status.LOADING
                ? Center(
                    child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70),
                    ),
                  )
                : SizedBox(
                    height: 1,
                  )
          ],
        ),
      ),
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 100);
      Navigator.of(context).pop();
      _imageBytes = await pickedFile?.readAsBytes();
      setState(() {});
      _imageBase64 = base64Encode(_imageBytes?.toList() ?? []);

      widget.bloc.add(UploadImage(
          imageBytes: _imageBase64,
          fileName: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'));

      print('imagrbasee $_imageBase64');
    }
    catch (e) {}
  }

  showToast(String item) async {
    flutterToast.showToast(
      child: CommonToast(displaymsg: item),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void setImageVal(String picture) async {
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
    appBloc.add(ProfileImageUpdate());

    print('pictureval $picture');
//   await sharePref_saveString(sharedPref_image,picture);
  }
}
