import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/create_experience_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/remove_experience_request.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';

import '../../configs/constants.dart';

class ExperienceAdd extends StatefulWidget {
  final ProfileBloc profileBloc;
  final Userexperiencedatum? data;

  ExperienceAdd({required this.profileBloc, this.data});

  @override
  _ExperienceAddState createState() => _ExperienceAddState();
}

class _ExperienceAddState extends State<ExperienceAdd> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  var isCheck = false;
  late FToast flutterToast;

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode companyFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode startDateFocusNode = FocusNode();
  FocusNode endDateFocusNode = FocusNode();
  FocusNode aboutFocusNode = FocusNode();

  bool isValidate = false;
  final _formKey = GlobalKey<FormState>();
  late ThemeData savedThemes;
  var date1;
  var date2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterToast = FToast();
    setThemeData();
    if (widget.data != null) {
      setState(() {
        titleController.text = widget.data?.title != null
            ? widget.data!.title
            : ''; //widget.data.title;
        checkTitleTextIsEmpty = titleController.text;
        companyController.text = widget.data?.companyname != null
            ? widget.data!.companyname
            : ''; //widget.data.companyname;
        checkCompanyTextIsEmpty =  companyController.text;
        locationController.text = widget.data?.location != null
            ? widget.data!.location
            : ''; //widget.data.location;
        locationTextIsEmpty = locationController.text;
        startDate.text = widget.data?.fromdate != null
            ? widget.data!.fromdate
            : ''; //widget.data.fromdate;
        endDate.text = widget.data?.todate != null ? widget.data!.todate : '';
        aboutController.text =
            widget.data?.description != 'null' ? widget.data!.description : '';
        checkDescriptionTextIsEmpty = aboutController.text;

        isCheck = widget.data?.tilldate ?? false;

        print('mtexperience_info:${widget.data?.fromdate}');
        print('mtexperience_info:${widget.data?.todate}');

        DateTime fromDate = new DateFormat("MMM yyyy")
            .parse(widget.data?.fromdate.trim() ?? "");
        DateTime toDate =
            new DateFormat("MMM yyyy").parse(widget.data?.todate.trim() ?? "");

        date1 = DateTime(fromDate.year, fromDate.month);
        date2 = DateTime(toDate.year, toDate.month);
      });
    } else {
      final df = new DateFormat('MMM yyyy');
      setState(() {
        // startDate.text = df.format(new DateTime(2020, 1)).toString();
        // endDate.text = df.format(DateTime(2020, 12)).toString();

        date1 = DateTime(2020, 1);
        date2 = DateTime(2020, 12);
      });
    }
  }

  setThemeData() async {
    savedThemes = await sharePrefGetString(savedTheme) == 'true'
        ? ThemeData.dark()
        : ThemeData.light();
  }

  String checkTitleTextIsEmpty ="", checkCompanyTextIsEmpty = "", checkDescriptionTextIsEmpty = "", locationTextIsEmpty = "";

  @override
  Widget build(BuildContext context) {
    flutterToast.init(context);

    basicDeviceHeightWidth(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocConsumer<ProfileBloc, ProfileState>(
        bloc: widget.profileBloc,
        listener: (_, state) {
          if (state is GetProfileInfoState) {
            print('state_status ${state.status}');
            switch (state.status) {
              case Status.COMPLETED:
                return Navigator.of(context).pop();
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
                break;
            }
          } else if (state is CreateExperienceState ||
              state is UpdateExperienceState ||
              state is RemoveExperienceState) {
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
        builder: (_, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.data != null ? 'Edit Experience' : 'Add Experience',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
              elevation: 0,
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.clear,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
              ),
              actions: widget.data != null
                  ? <Widget>[
                      IconButton(
                          icon: Icon(Icons.delete, color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    new AlertDialog(
                                      title: Text(
                                        appBloc.localstr
                                            .profileAlerttitleStringconfirmation,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                      content: Text(
                                        appBloc.localstr
                                            .profileAlertsubtitleDeleteexperience,
                                        style: TextStyle(
                                            color:
                                                InsColor(appBloc).appTextColor),
                                      ),
                                      backgroundColor:
                                          InsColor(appBloc).appBGColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(appBloc.localstr.profileButtonExperiencecancelbutton),
                                          textColor: Colors.grey,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(appBloc.localstr
                                              .profileAlertbuttonDeletebutton),
                                          textColor: Colors.blue,
                                          onPressed: () async {
                                            Navigator.of(context).pop();

                                            RemoveExperienceRequest req =
                                                RemoveExperienceRequest();
                                            req.userId =
                                                await sharePrefGetString(
                                                    sharedPref_userid);
                                            req.displayNo = widget
                                                    .data?.displayno
                                                    .toString() ??
                                                "";

                                            widget.profileBloc.add(
                                                RemoveExperience(
                                                    removeExperienceRequest:
                                                        req));
                                          },
                                        ),
                                      ],
                                    ));
                          })
                    ]
                  : [],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.h),
                      child: Column(
                        children: <Widget>[
                          Form(
                              key: _formKey,
                              autovalidateMode: isValidate
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: appBloc.localstr
                                            .profileLabelExperiencetitlelabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.apply(
                                                color: InsColor(appBloc)
                                                    .appTextColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  ),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    validator: validateTitle,
                                    focusNode: titleFocusNode,
                                    autofocus: false,
                                    controller: titleController,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Job Title",
                                      hintStyle: TextStyle(color: Colors.black38),

                                      // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff202124))),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: checkTitleTextIsEmpty  .isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: checkTitleTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),

                                    ),
                                    onChanged: (val){
                                      checkTitleTextIsEmpty = val;
                                      setState((){});
                                    },
                                    // describes the field number
                                    style: TextStyle(
                                        // style for the fields
                                        fontSize: 14.h,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(companyFocusNode);
                                    },
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: appBloc.localstr
                                            .profileLabelExperiencecompanylabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.apply(
                                                color: InsColor(appBloc)
                                                    .appTextColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  ),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    validator: validateCompany,
                                    focusNode: companyFocusNode,
                                    autofocus: false,
                                    controller: companyController,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Company name",
                                      hintStyle: TextStyle(color: Colors.black38),
                                      enabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: checkCompanyTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                     ),
                                      focusedBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: checkCompanyTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                     ),
                                    ),
                                    onChanged: (val){
                                      checkCompanyTextIsEmpty = val;
                                      setState((){});
                                    },
                                    // describes the field number
                                    style: TextStyle(
                                        // style for the fields
                                        fontSize: 14.h,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(locationFocusNode);
                                    },
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: appBloc.localstr
                                            .profileLabelExperiencelocationlabel,
                                        style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  ),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    validator: validateLocation,
                                    autofocus: false,
                                    focusNode: locationFocusNode,
                                    controller: locationController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Location",
                                      hintStyle: TextStyle(color: Colors.black38),
                                      enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: locationTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                      ),
                                      focusedBorder:OutlineInputBorder(
                                        borderSide: BorderSide(color: locationTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                      ),
                                    ),
                                    onChanged: (val){
                                      locationTextIsEmpty = val;
                                      setState((){});
                                    },

                                    // describes the field number
                                    style: TextStyle(
                                        // style for the fields
                                        fontSize: 14.h,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    onEditingComplete: () =>
                                        FocusScope.of(context).unfocus(),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                            value: isCheck,
                                            checkColor: Colors
                                                .white, // color of tick Mark
                                            activeColor: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isCheck = value ?? false;
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Text(
                                        appBloc.localstr
                                            .profileLabelExperienceiscurrentlyworkingtilldatelabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            ?.apply(
                                                color: InsColor(appBloc)
                                                    .appTextColor),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          // margin: EdgeInsets.only(left: 8.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    text: appBloc.localstr
                                                        .profileLabelExperiencefromlabel,
                                                    style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: ' *',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red))
                                                    ]),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  // showMonthPicker(
                                                  //   context: context,
                                                  //   initialDate:
                                                  //       new DateTime.now(),
                                                  //   firstDate:
                                                  //       new DateTime(1957),
                                                  //   lastDate: DateTime.now()
                                                  //       .add(Duration(
                                                  //           days: 1)),
                                                  //   locale: Locale("en"),
                                                  // ).then((date) => {
                                                  //       if (date != null)
                                                  //         {
                                                  //           setState(() {
                                                  //             date1 = date;
                                                  //             final df =
                                                  //                 new DateFormat(
                                                  //                     'MMM yyyy');
                                                  //             date1 = DateTime(
                                                  //                 date.year,
                                                  //                 date.month);
                                                  //             startDate.text = df
                                                  //                 .format(
                                                  //                     date)
                                                  //                 .toString();
                                                  //           }),
                                                  //         }
                                                  //     });

                                                  DateTime date =
                                                      DateTime(1957);
                                                  date = await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            new DateTime.now(),
                                                        firstDate:
                                                            new DateTime(1957),
                                                        lastDate: DateTime.now()
                                                            .add(Duration(
                                                                days: 1)),
                                                        builder: (BuildContext
                                                                context,
                                                            Widget? child) {
                                                          return Theme(
                                                            data: savedThemes,
                                                            child: child ??
                                                                SizedBox(),
                                                          );
                                                        },
                                                      ) ??
                                                      date;

                                                  final df = new DateFormat(
                                                      'MMM yyyy');
                                                  date1 = DateTime(
                                                      date.year, date.month);

                                                  startDate.text = df
                                                      .format(date)
                                                      .toString();
                                                  setState(() {});
                                                },
                                                child: IgnorePointer(
                                                  child: TextFormField(
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                      enabled: false,
                                                      controller: startDate,
                                                      decoration:
                                                          InputDecoration(
                                                            // border: OutlineInputBorder(
                                                              // borderSide: BorderSide(color: Colors.black)
                                                            // ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.black38)
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: startDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                                              ),
                                                              hintText:
                                                                  'Ex: Aug 2022',
                                                              hintStyle: TextStyle(
                                                                  color: Colors.black38),
                                                              suffixIcon: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              ))),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      !isCheck
                                          ? Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 8.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      text: TextSpan(
                                                          text: appBloc.localstr
                                                              .profileLabelExperiencetolabel,
                                                          style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: ' *',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red))
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        DateTime date =
                                                            DateTime(1900);

                                                        date =
                                                            await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      new DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          1957),
                                                                  lastDate: DateTime
                                                                          .now()
                                                                      .add(Duration(
                                                                          days:
                                                                              1)),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      Widget?
                                                                          child) {
                                                                    return Theme(
                                                                      data:
                                                                          savedThemes,
                                                                      //Background color,                                                                      ),
                                                                      child: child ??
                                                                          SizedBox(),
                                                                    );
                                                                  },
                                                                ) ??
                                                                DateTime(1900);

                                                        print(
                                                            'startdate $date');
                                                        final df =
                                                            new DateFormat(
                                                                'MMM yyyy');
                                                        print(df.format(date));

                                                        date2 = DateTime(
                                                            date.year,
                                                            date.month);

                                                        endDate.text = df
                                                            .format(date)
                                                            .toString();

                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        setState(() {});

                                                      },
                                                      child: IgnorePointer(
                                                        child: TextFormField(
                                                            style: TextStyle(
                                                                color: Color(int
                                                                    .parse(
                                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                            enabled: false,
                                                            controller: endDate,
                                                            decoration:
                                                                InputDecoration(
                                                                    disabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(color:  endDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(color: endDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                                                    ),
                                                                    hintText:
                                                                        'Ex: Aug 2022',
                                                                    hintStyle: TextStyle(
                                                                        color: Colors.black38),
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Color(
                                                                          int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                    ))),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Text(
                                    appBloc.localstr
                                        .profileLabelExperiencedescriptionlabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.apply(
                                            color:
                                                InsColor(appBloc).appTextColor),
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
                                        border: Border.all( color:checkDescriptionTextIsEmpty.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                    child: TextFormField(
                                      focusNode: aboutFocusNode,
                                      textAlign: TextAlign.start,
                                      autofocus: false,
                                      controller: aboutController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,

                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Enter description here..',hintStyle:TextStyle(color: Colors.black38),
                                      ),
                                      // describes the field number
                                      style: TextStyle(
                                          // style for the fields
                                          fontSize: 14.h,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      onEditingComplete: () =>
                                          FocusScope.of(context).unfocus(),
                                      onChanged: (val) {
                                        checkDescriptionTextIsEmpty = val;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50.h,
                                      child: MaterialButton(
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                        disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                                        child: Text(
                                            widget.data != null
                                              ? appBloc.localstr.profileButtonExperiencesavebutton
                                              : "Add",
                                            style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appBtnTextColor),
                                        ),
                                        onPressed: (titleController.text.isNotEmpty)
                                          ? () async {
                                              validate();
                                            }
                                          : null,
                                      ),
                                  ),
                                ],
                              ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                (state is CreateExperienceState ||
                        state is GetProfileInfoState ||
                        state is RemoveExperienceState ||
                        state is UpdateExperienceState)
                    ? (state.status == Status.LOADING)
                        ? Center(
                            child: AbsorbPointer(
                                child:AppConstants().getLoaderWidget(iconSize: 70),))
                        : Container()
                    : Container()
              ],
            ),
          );
        });
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }

  void validate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      var difference;
//      final date1 = DateTime(2010, 10);
//      final date2 = DateTime(2010, 10);
      if (date1 != null && date2 != null) {
        difference = date2.difference(date1).inDays;
        print('fifferenceval $difference');
      }

      if (startDate.text.isEmpty) {
        flutterToast.showToast(
          child: CommonToast(
              displaymsg: appBloc.localstr
                  .profileAlertsubtitleAsteriskmarkedfieldsaremandatory),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      } else if (endDate.text.isEmpty && !isCheck) {
        flutterToast.showToast(
          child: CommonToast(
              displaymsg: appBloc.localstr
                  .profileAlertsubtitleAsteriskmarkedfieldsaremandatory),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      } else if (difference < 0 && !isCheck) {
        flutterToast.showToast(
          child: CommonToast(
              displaymsg: appBloc.localstr
                  .profileAlertsubtitleEducationdatefieldvaluevalidation),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      } else {
        callCreateApi();
      }
    } else {
      setState(() {
        isValidate = true;
      });
    }
  }

  void callCreateApi() async {
    CreateExperienceRequest createExp = new CreateExperienceRequest();

    createExp.title = titleController.text;
    createExp.company = companyController.text;
    createExp.location = locationController.text;
    createExp.showfromdate = startDate.text;
    createExp.discription = aboutController.text;
    createExp.tilldate = isCheck ? 1 : 0;
//                                                createExp.todate = endDate.text;
    createExp.showftoate = endDate.text;
    createExp.userId = await sharePrefGetString(sharedPref_userid);

    print('userid ${createExp.userId} ${createExp.showftoate}');

    if (widget.data != null) {
      createExp.displayNo = widget.data?.displayno.toString() ?? "";

      widget.profileBloc
          .add(UpdateExperience(updateExperienceRequest: createExp));
    } else {
      widget.profileBloc
          .add(CreateExperience(createExperienceRequest: createExp));
    }
  }

  String? validateTitle(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }

    return null;
  }

  String? validateCompany(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }
    return null;
  }

  String? validateLocation(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }
    return null;
  }
}
