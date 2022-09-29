import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:flutter_admin_web/framework/repository/profile/model/fetchCounries.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../configs/constants.dart';
import '../common/app_colors.dart';
import '../common/bottomsheet_option_tile.dart';

List<String> genderlist = ['Male', 'Female'];

class ProfileEdit extends StatefulWidget {
  final List<ProfileEditList> profielDataField;
  final ProfileBloc bloc;
  final bool? isContact;
  final String title;

  const ProfileEdit(
      {Key? key,
      required this.profielDataField,
      required this.bloc,
      this.isContact,
      this.title = ""})
      : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // File? _image;
  // File? _cameraImage;
  String _imageBase64 = "";
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickImageError;
  late RegExp regExp;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late FToast flutterToast;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  var image;

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

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = await _picker.pickImage(
          source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 100);
      Navigator.of(context).pop();
      setState(() {
        _imageFile = pickedFile;
      });
      List<int> imageBytes = await _imageFile?.readAsBytes() ?? [];
      _imageBase64 = base64Encode(imageBytes);

      widget.bloc.add(UploadImage(
          imageBytes: _imageBase64,
          fileName: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'));

      print('imagrbasee $_imageBase64');
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  bool validate(List<ProfileEditList> profileconfigdata, RegExp regExp) {
    bool isValidate = false;

    for (var element in profileconfigdata) {
      if ((element.valueName == null || element.valueName.isEmpty)) {
        print(
            'profileconfig ${element.attributedisplaytext} ${element.valueName} ${element.isrequired}');
        if (element.isrequired) {
          print('ifrequired');
          isValidate = false;
          showToast(appBloc
              .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory);
          break;
        } else {
          print('elserequired');
          isValidate = true;
        }
      } else {
        isValidate = true;
      }
//
    }

    print('dataisvalidated $isValidate');
    return isValidate;
  }

  showToast(String item) async {
    flutterToast.showToast(
      child: CommonToast(displaymsg: item),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void setImageVal(String picture, String displayname) async {
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
    await sharePrefSaveString(sharedPref_image, picture);
    await sharePrefSaveString(sharedPref_LoginUserName, displayname);

    appBloc.add(ProfileImageUpdate());

    print('pictureval $picture');
//   await sharePref_saveString(sharedPref_image,picture);
  }

  @override
  void initState() {
    super.initState();
    regExp = new RegExp(pattern);

    if (widget.isContact != null) {
      widget.bloc.add(FetchCountries());
    }
  }

  @override
  void dispose() {
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
                widget.bloc.profileResponse.userprofiledetails[0].picture,
                widget.bloc.profileResponse.userprofiledetails[0].firstname +
                    " " +
                    widget.bloc.profileResponse.userprofiledetails[0].lastname);

            Navigator.of(context).pop();
          }
          else if (state.status == Status.ERROR) {
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
        }
        else if (state is UploadImageState || state is UpdateProfileState) {
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
        else if (state is FetchCountriesState) {
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
      builder: (context, state) => Container(
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              child: MaterialButton(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text(
                    appBloc.localstr.profileButtonEditprofilesavebutton,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                  onPressed: () {
                    String profileVal = "";
                    if (validate(widget.profielDataField, regExp)) {
                      for (int i = 0; i < widget.profielDataField.length; i++) {
                        String fieldval =
                            ''' '${widget.profielDataField[i].valueName}' ''';

                        profileVal = profileVal +
                            '${widget.profielDataField[i].datafieldname.toLowerCase()}=${fieldval.trim()},';

                        print(
                            'fieldvalll  $fieldval, Profile Val:$profileVal');
                      }

                      print('myprofilevall  $profileVal');

                      setState(() {
                        widget.bloc.add(UpdateProfile(
                            data: profileVal.substring(
                                0, profileVal.length - 1)));
                      });
                    }
                  }),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            title: Text(
              widget.title,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            elevation: 2,
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.h, vertical: 20.h),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.h,
                          ),
                          (widget.profielDataField.length != 0)
                              ? ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.profielDataField.length,
                                  itemBuilder: (context, index) => getWidget(
                                      index,
                                      widget.profielDataField,
                                      widget.bloc),
//                  itemScrollController: itemScrollController,
//                  itemPositionsListener:
//                  itemPositionsListener,
                                )
                              : Container(),
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
        ),
      ),
    );
  }

  Widget getWidget(
      int i, List<ProfileEditList> profileConfigData, ProfileBloc profileBloc) {
    Widget fieldWidget = Container();

    ProfileEditList item = profileConfigData[i];
    String _character = "";

    // controller
    int uiControlTypeId = item.uicontroltypeid;

    // comparing Attribut
    int attributeConfigId = item.attributeconfigid;
    int maxlength = item.maxlength;
    print('profiledatafieldVla $uiControlTypeId');

    // this is for labelField , EditTextHint ,
    String displayText = item.attributedisplaytext;
    if (uiControlTypeId == 3 || uiControlTypeId == 18) {
      print("......i am from bloc..val.....${item.valueName}");
      bool isRequired = item.isrequired;

      print('item.table5-- ${item.table5?.toJson()}');


      fieldWidget = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                          isRequired ? displayText + " *" : displayText,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  widget.bloc.countryList.isNotEmpty
                      ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color:item.table5?.choiceid == 2085 ? AppColors.getDisableBorderColor() : AppColors.getEnabledBorderColor(),width: 0.5),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton<Table5>(
                            dropdownColor: AppColors.getAppBGColor(),
                            value: item.table5,
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                                // height: 2,
                                // color: Color(int.parse(
                                //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                            onChanged: (Table5? data) {
//                      item.selectedSpinerObj = data;
                              setState(() {
                                item.valueName = data?.choicevalue ?? "";
                                item.table5 = data;
                                widget.profielDataField[i] = item;
                              });

//                      widget.bloc.add(UpdateListFromUiEvent(
//                          profiledatafieldname: profileConfigData));
                            },
                            items: widget.bloc.countryList
                                .map<DropdownMenuItem<Table5>>((Table5 value) {
                              return DropdownMenuItem<Table5>(
                                value: value,
                                child: Text(
                                  value.choicetext,
                                  style: TextStyle(
                                      color: AppColors.getAppTextColor()),
                                ),
                              );
                            }).toList(),
                          ),
                      )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      TextInputType keyboardType;
      TextEditingController controller = TextEditingController();
      bool isEditable = true;
      bool isRequired = false;
      isRequired = item.isrequired;
      isEditable = item.iseditable;
      controller.text = item.valueName;
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));

      if (attributeConfigId == 15) {
        keyboardType = TextInputType.emailAddress;
      } else {
        keyboardType = TextInputType.text;
      }

      if (uiControlTypeId == 19 || uiControlTypeId == 8) {
        isEditable = false;
      }

      if (uiControlTypeId == 19) {
        _character = item.valueName;
      }

      if (uiControlTypeId != 7) {
        {
          if (uiControlTypeId == 19) {
            String? _selectedText;

            print('itemvaluename ${item.valueName}');
            if (item.valueName.isNotEmpty &&
                (item.valueName.toLowerCase().contains('male'))) {
              _selectedText =
                  item.valueName[0].toUpperCase() + item.valueName.substring(1);
            }

            fieldWidget = Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                                isRequired ? displayText + " *" : displayText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.apply(
                                        color: InsColor(appBloc).appTextColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7,vertical: 3),
                          decoration: BoxDecoration(
                              border: Border.all(color: _selectedText == null? AppColors.getDisableBorderColor() : AppColors.getEnabledBorderColor(),width: 0.5),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: new DropdownButton<String>(
                            dropdownColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                            isExpanded: true,
                            // icon: Icon(
                            //   Icons.arrow_drop_down,
                            //   // color: Colors.grey,
                            // ),
                            underline: Container(
                                // height: 2,
                                // color: Color(int.parse(
                                //     "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                // ),
                            ),
                            hint: Text("Select gender"),
                            value: _selectedText,
                            items: <String>['Male', 'Female'].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                item.valueName = val ?? "";
                                widget.profielDataField[i] = item;
                                _selectedText = val ?? "";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (uiControlTypeId == 8) {
            String date = '';
            if (item.valueName.isNotEmpty && item.valueName.contains('T')) {
              DateTime tempDate =
                  new DateFormat("yyyy-MM-ddThh:mm:ss").parse(item.valueName);

              date = DateFormat("MM-dd-yyyy").format(tempDate);
              controller.text = date;

              print('checkmydateva; $date');
            }
            fieldWidget = Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                                isRequired ? displayText + " *" : displayText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.apply(
                                        color: InsColor(appBloc).appTextColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: () async {
                            DateTime date = DateTime(1957);

                            date = await showDatePicker(
                                  context: context,
                                  initialDate: new DateTime.now(),
                                  firstDate: new DateTime(1957),
                                  lastDate: new DateTime.now(),
                                  builder: (BuildContext context,
                                      Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}")),
                                        //Head background
                                        accentColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appLoginTextolor.substring(1, 7).toUpperCase()}")),
                                        //selection color
                                        dialogBackgroundColor: Color(
                                            int.parse(
                                                "0xFF${appBloc.uiSettingModel.appLoginBGColor.substring(1, 7).toUpperCase()}")), //Background color
                                      ),
                                      child: child ?? SizedBox(),
                                    );
                                  },
                                ) ??
                                date;

                            final df = new DateFormat('MM/dd/yyyy');
                            controller.text = df.format(date).toString();
                            item.valueName = controller.text;
                            widget.profielDataField[i] = item;
                            setState(() {});
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                                  maxLength: maxlength,
                              keyboardType: keyboardType,
                              enabled: isEditable,
                              obscureText:
                                  attributeConfigId == 6 ? true : false,
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.black)
                                // ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:  controller.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: controller.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                  ),
                                  hintText: displayText,
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                          .withOpacity(0.5))),
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
//
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (uiControlTypeId == 2) {
            String checkEmptyView = controller.text;
            fieldWidget = Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appBloc.localstr.profileLabelEducationdescriptionlabel,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.apply(color: InsColor(appBloc).appTextColor),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    height: 200.h,

                    padding: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color:  checkEmptyView.isEmpty ? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(maxlength),
                      ],
                      controller: controller,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (val) {
                        print("val.....$val");
                        item.valueName = val;
                        checkEmptyView = val;
                        setState((){});
                        widget.profielDataField[i] = item;
                      },
                      onFieldSubmitted: (val) {
                        item.valueName = val;
                        widget.profielDataField[i] = item;
                      },
//                        maxLength: maxlength,
                      enabled: isEditable,
                      obscureText: attributeConfigId == 6 ? true : false,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      autofocus: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(hintText: '')  ,
                      // describes the field number
                      style: TextStyle(
                          // style for the fields
                          fontSize: 14.h,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ),
                ],
              ),
            );
          } else {
            String borderView = controller.text;
            fieldWidget = Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: displayText,
                                  style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: Colors.red))
                                  ]),
                            ),
                            // Flexible(
                            //   child: Text(
                            //     //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                            //     isRequired ? displayText + " *" : displayText,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline2
                            //         ?.apply(
                            //             color: InsColor(appBloc).appTextColor),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                controller: controller,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                maxLength: maxlength,
                                keyboardType: keyboardType,
                                enabled: isEditable,
                                obscureText:
                                    attributeConfigId == 6 ? true : false,
                                decoration: InputDecoration(
                                    hintText: displayText,
                                    // border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff202124))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color:  Color(0xffDADCE0))),


                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                            .withOpacity(0.5))),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                                onSubmitted: (val) {
                                  item.valueName = val;
                                  widget.profielDataField[i] = item;
                                },
                                onChanged: (val) {
                                  borderView = val;
                                  setState((){});
//                            TextSelection previousSelection =
//                                controller.selection;
//                            controller.text = val;
//                            controller.selection = previousSelection;

                                  print("val.....$val");
                                  item.valueName = val;
                                  widget.profielDataField[i] = item;
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }
      }
    }

    return fieldWidget;
  }
}
