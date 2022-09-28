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
import 'package:flutter_admin_web/framework/repository/profile/model/create_education_request.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/education_titles_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/remove_experience_request.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';
import '../../utils/my_print.dart';

class EducationAdd extends StatefulWidget {
  final ProfileBloc profileBloc;
  final Usereducationdatum? data;

  EducationAdd({Key? key, required this.profileBloc, this.data});

  @override
  _EducationAddState createState() => _EducationAddState();
}

class _EducationAddState extends State<EducationAdd> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late FToast flutterToast;

  var isCheck = false;

  ScrollController scrollController = ScrollController();

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  TextEditingController schoolController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  FocusNode schoolFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  FocusNode levelFocusNode = FocusNode();
  FocusNode fieldFocusNode = FocusNode();
  FocusNode aboutFocusNode = FocusNode();

  String selectedValue = "";

  bool isValidate = false;
  final _formKey = GlobalKey<FormState>();

  int titleId = -1;
  int titlePos = -1;
  int selectindex = -1;

  String verifyDegreeBorderView = "", aboutDescriptionBorder = "" ;

  String? _selectedLocation; // Optio
  String? _selectedendDate; // Optio

  List<EducationTitleList> educationalTitleList = [];
  // final FixedExtentScrollController _controller = FixedExtentScrollController();
  var _duration = [
    "1957",
    "1958",
    "1959",
    "1960",
    "1961",
    "1962",
    "1963",
    "1964",
    "1965",
    "1966",
    "1967",
    "1968",
    "1969",
    "1970",
    "1971",
    "1972",
    "1973",
    "1974",
    "1975",
    "1976",
    "1977",
    "1978",
    "1979",
    "1980",
    "1981",
    "1982",
    "1983",
    "1984",
    "1985",
    "1986",
    "1987",
    "1988",
    "1989",
    "1990",
    "1991",
    "1992",
    "1993",
    "1994",
    "1995",
    "1996",
    "1997",
    "1998",
    "1999",
    "2000",
    "2001",
    "2002",
    "2003",
    "2004",
    "2005",
    "2006",
    "2007",
    "2008",
    "2009",
    "2010",
    "2011",
    "2012",
    "2013",
    "2014",
    "2015",
    "2016",
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
  ];

  @override
  void initState() {
    super.initState();
    flutterToast = FToast();

    if (widget.data != null) {
      setState(() {
        schoolController.text = widget.data!.school;
        countryController.text = widget.data!.country;
        _selectedendDate =
            widget.data!.fromyear.isNotEmpty ? widget.data!.fromyear : "2018";
        _selectedLocation =
            widget.data!.toyear.isNotEmpty ? widget.data!.toyear : "2022";
        aboutController.text = widget.data!.description;
        fieldController.text = widget.data!.degree;
        titleId = widget.data!.titleid;
        selectindex = widget.data!.titleid - 1;
        titlePos = widget.data!.titleid > 0 ? widget.data!.titleid - 1 : 0;
        startDate.text = _selectedendDate!;
        endDate.text = _selectedLocation!;
      });

      print('selectedyear $titleId  $titlePos');
    }
    else {
      startDate.text = _selectedendDate ?? "";
      endDate.text = _selectedLocation ?? "";

      levelController.text = "";
      titleId = -1;
      titlePos = -1;
      selectindex = -1;

    }

    widget.profileBloc.add(GetEducationTitle());
  }

  @override
  Widget build(BuildContext context) {
    flutterToast.init(context);
    basicDeviceHeightWidth(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    print("Selected From Date:$_selectedLocation");
    print("Selected To Date:$_selectedendDate");
    print("Date List:$_duration");
    print("Date List Contains:${_duration.contains(_selectedendDate)}");

    return BlocConsumer<ProfileBloc, ProfileState>(
        bloc: widget.profileBloc,
        listener: (_, state) {
          print("----status----:${state.status}");

          if (state is GetProfileInfoState) {
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
          }
          else if (state is GetEducationTitleState) {
            if (state.status == Status.COMPLETED) {
              educationalTitleList = state.educationTitleList;
              print("----educationalTitleList----:${educationalTitleList.isNotEmpty}");
              MyPrint.printOnConsole("levelController before:${levelController.text}");
              MyPrint.printOnConsole("titleId before:${titleId}");
              MyPrint.printOnConsole("selectindex before:${selectindex}");

              if (educationalTitleList.isNotEmpty) {
                if (titlePos == -1) {
                  //levelController.text = state.educationTitleList[0].name;
                  //titleId = state.educationTitleList[0].id;
                  //titleId = 1;
                  //selectindex = 0;
                }
                else {
                  print("----educationalTitleList----:${educationalTitleList.isNotEmpty}");

                  levelController.text = state.educationTitleList[titlePos].name;
                  //levelController.text = "";
                  titleId = state.educationTitleList[titlePos].id;
                  selectindex = titlePos;
                }
              }
              else {
                levelController.text = "";
                titleId = -1;
                titlePos = -1;
                selectindex = -1;
              }

              MyPrint.printOnConsole("levelController after:${levelController.text}");
              MyPrint.printOnConsole("titleId after:${titleId}");
              MyPrint.printOnConsole("selectindex after:${selectindex}");
            }
            else if (state.status == Status.ERROR && state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            }
            print('educationtitle $educationalTitleList $titleId');
          }
          else if (state is CreateEducationState || state is UpdateEducationState || state is RemoveEducationState) {
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
          verifyDegreeBorderView = fieldController.text;
          aboutDescriptionBorder = aboutController.text;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.data != null ? 'Edit Education' : 'Create New Education',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
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
                            icon: Icon(Icons.delete,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
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
                                              color: InsColor(appBloc)
                                                  .appTextColor),
                                        ),
                                        content: Text(
                                          appBloc.localstr
                                              .profileAlertsubtitleDeleteeducation,
                                          style: TextStyle(
                                              color: InsColor(appBloc)
                                                  .appTextColor),
                                        ),
                                        backgroundColor:
                                            InsColor(appBloc).appBGColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5)),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text(appBloc.localstr
                                                .profileButtonEducationcancelbutton),
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
                                                  .data!.displayno
                                                  .toString();

                                              widget.profileBloc.add(
                                                  RemoveEducation(
                                                      removeEducationRequest:
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
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
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
                                  commonTextFormField(
                                    hintText: "Ex: Stanford university",
                                    controller: schoolController,
                                    headerText: appBloc.localstr.profileLabelEducationschooluniversitylabel,
                                    fn: schoolFocusNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(countryFocusNode);
                                    },
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                  ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    // RichText(
                                    //   textAlign: TextAlign.start,
                                    //   text: TextSpan(
                                    //       text: appBloc.localstr
                                    //           .profileLabelEducationschooluniversitylabel,
                                    //       style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                    //       children: <TextSpan>[
                                    //         TextSpan(
                                    //             text: ' *',
                                    //             style: TextStyle(
                                    //                 color: Colors.red))
                                    //       ]),
                                    // ),
                                    // TextFormField(
                                    //   validator: validateSchool,
                                    //   controller: schoolController,
                                    //   focusNode: schoolFocusNode,
                                    //   onEditingComplete: () {
                                    //     FocusScope.of(context)
                                    //         .requestFocus(countryFocusNode);
                                    //   },
                                    //   textInputAction: TextInputAction.next,
                                    //   autofocus: false,
                                    //   textCapitalization:
                                    //       TextCapitalization.words,
                                    //   keyboardType: TextInputType.text,
                                    //   decoration: InputDecoration(
                                    //     border: OutlineInputBorder()
                                    //     // UnderlineInputBorder(
                                    //     //   borderSide: BorderSide(),
                                    //     // ),
                                    //   ),
                                    //   // describes the field number
                                    //   style: TextStyle(
                                    //       // style for the fields
                                    //       fontSize: 14.h,
                                    //       color: Color(int.parse(
                                    //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    // ),
                                    // SizedBox(
                                    //   height: 40.h,
                                    // ),
                                    commonTextFormField(
                                      hintText: "Ex: USA",
                                      controller: countryController,
                                      headerText: appBloc.localstr.profileLabelEducationcountrylabel,
                                      fn: countryFocusNode,
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      textInputAction: TextInputAction.done,
                                      textCapitalization: TextCapitalization.words,
                                      // keyboardType: TextInputType.text,
                                    ),
                                    // RichText(
                                    //   textAlign: TextAlign.start,
                                    //   text: TextSpan(
                                    //       text: appBloc.localstr
                                    //           .profileLabelEducationcountrylabel,
                                    //       style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                    //       children: <TextSpan>[
                                    //         TextSpan(
                                    //             text: ' *',
                                    //             style: TextStyle(
                                    //                 color: Colors.red))
                                    //       ]),
                                    // ),
                                    // TextFormField(
                                    //   validator: validateSchool,
                                    //   controller: countryController,
                                    //   focusNode: countryFocusNode,
                                    //   onEditingComplete: () {
                                    //     FocusScope.of(context).unfocus();
                                    //   },
                                    //   textInputAction: TextInputAction.done,
                                    //   autofocus: false,
                                    //   keyboardType: TextInputType.text,
                                    //   decoration: InputDecoration(
                                    //     focusedBorder: UnderlineInputBorder(
                                    //       borderSide: BorderSide(),
                                    //     ),
                                    //   ),
                                    //   // describes the field number
                                    //   style: TextStyle(
                                    //       // style for the fields
                                    //       fontSize: 14.h,
                                    //       color: Color(int.parse(
                                    //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    // ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: appBloc.localstr
                                              .profileLabelEducationtitlelabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.apply(
                                                  color: InsColor(appBloc)
                                                      .appTextColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                    ),
                                    SizedBox(height: 5,),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                new AlertDialog(
                                                  content:
                                                      setupAlertDialoadContainer(
                                                          titlePos),

                                                  // content: ScrollPicker(
                                                  //     items: educationalTitleList,
                                                  //     initialValue: titlePos,
                                                  //     onChanged: (value) =>
                                                  //         setState(() =>
                                                  //             levelController
                                                  //                     .text =
                                                  //                 value),
                                                  //     onSelectedPos: (id) =>
                                                  //         titleId = id
                                                  //
                                                  // ),

                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(15)),

                                                  // actions: <Widget>[
                                                  //   new FlatButton(
                                                  //     child: new Text(appBloc
                                                  //         .localstr
                                                  //         .profileButtonEducationcancelbutton),
                                                  //     textColor: Colors.red,
                                                  //     onPressed: () {
                                                  //       Navigator.of(context)
                                                  //           .pop();
                                                  //       FocusScope.of(context)
                                                  //           .unfocus();
                                                  //     },
                                                  //   ),
                                                  //   new FlatButton(
                                                  //     child: Text(appBloc
                                                  //         .localstr
                                                  //         .profileButtonEducationsavebutton),
                                                  //     textColor: Colors.blue,
                                                  //     onPressed: () {
                                                  //
                                                  //     },
                                                  //   ),
                                                  // ],
                                                ));
                                      },
                                      child: IgnorePointer(
                                        child: TextFormField(
                                          validator: validateLevel,
                                          enabled: false,
                                          controller: levelController,
                                          focusNode: levelFocusNode,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          textCapitalization: TextCapitalization.words,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: "Title",
                                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: levelController.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: levelController.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: levelController.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                          ),
                                          // describes the field number
                                          style: TextStyle(
                                              // style for the fields
                                              fontSize: 14.h,
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: appBloc.localstr
                                              .profileLabelEducationdegreelabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.apply(
                                                  color: InsColor(appBloc)
                                                      .appTextColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      validator: validateFieldOfStudy,
                                      controller: fieldController,
                                      focusNode: fieldFocusNode,
                                      textInputAction: TextInputAction.done,
                                      autofocus: false,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Ex: Computer science",
                                        hintStyle: TextStyle(color: Colors.black38),
                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: verifyDegreeBorderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: verifyDegreeBorderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),

                                          // border: OutlineInputBorder(),
                                        // focusedBorder: OutlineInputBorder()
                                      ),
                                      onChanged: (val){
                                        verifyDegreeBorderView = val;
                                        setState((){});
                                      },
                                      // describes the field number
                                      style: TextStyle(
                                          // style for the fields
                                          fontSize: 14.h,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
//                              Row(
//                                children: <Widget>[
//                                  SizedBox(
//                                    width: 20,
//                                    height: 20,
//                                    child: Checkbox(
//                                        value: isCheck,
//                                        checkColor:
//                                            Colors.white, // color of tick Mark
//                                        activeColor: Colors.lightGreen,
//                                        onChanged: (bool value) {
//                                          setState(() {
//                                            isCheck = value;
//                                            endDate.clear();
//                                          });
//                                        }),
//                                  ),
//                                  SizedBox(
//                                    width: 10.h,
//                                  ),
//                                  Text('I am still student')
//                                ],
//                              ),
//                              SizedBox(
//                                height: 20.h,
//                              ),
                                    Container(
                                      // margin: EdgeInsets.only(left: 8.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                                text: appBloc.localstr.profileLabelEducationfromlabel,
                                                style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: ' *',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.red))
                                                ]),
                                          ),
                                          SizedBox(height: 5.h,),
                                          InputDecorator(

                                            decoration: InputDecoration(
                                                hintText: 'Ex:2022',
                                                disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color:  startDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: startDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                                ),

                                                border:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        5.0))),
                                            child: Container(
                                              height: 25.h,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  dropdownColor: Color(
                                                      int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                  hint: Text('Year'),
                                                  value: _selectedendDate,
                                                  // isDense: true,
                                                  underline: Container(),

                                                  onChanged: (String? newValue) {
                                                    print("New Value:$newValue");
                                                    setState(() {
                                                      _selectedendDate = newValue ?? "2022";
                                                      startDate.text = newValue ?? "2022";
                                                      // _selectedLocation = "2022";
                                                    });
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  items: _duration.reversed.map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: Color(
                                                                int.parse(
                                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Container(
                                      // margin: EdgeInsets.only(left: 8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                                text: appBloc.localstr.profileLabelEducationtolabel,
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
                                            height: 5.h,
                                          ),
                                          InputDecorator(
                                            decoration: InputDecoration(
                                                hintText: 'Ex:2022',
                                                border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5.0)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:  endDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: endDate.text.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)
                                              ),),
                                            child:
                                            Container(
                                              height: 25.h,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  dropdownColor: Color(
                                                      int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                                  hint: Text('Year'),
                                                  value: _selectedLocation,
                                                  // isDense: true,
                                                  onChanged: (String? newValue) {
                                                    print(
                                                        "New Value:$newValue");
                                                    if (int.parse(newValue ?? "0") <=
                                                        int.parse(_selectedendDate!)) {
                                                      flutterToast.showToast(
                                                        child: CommonToast(
                                                            displaymsg: appBloc
                                                                .localstr
                                                                .profileAlertsubtitleEducationdatefieldvaluevalidation),
                                                        gravity:
                                                        ToastGravity
                                                            .BOTTOM,
                                                        toastDuration:
                                                        Duration(
                                                            seconds: 2),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        _selectedLocation = newValue ?? "2022";
                                                        endDate.text = newValue ?? "2022";
                                                      });
                                                    }

                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  items: _duration.reversed
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: Color(
                                                                int.parse(
                                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
//                                     Column(
//                                       children: <Widget>[
//
// //                                  !isCheck
// //                                      ?
//
// //                                      : Container()
//                                       ],
//                                     ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Text(
                                      appBloc.localstr
                                          .profileLabelEducationdescriptionlabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          ?.apply(
                                              color: InsColor(appBloc)
                                                  .appTextColor),
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
                                          border: Border.all(
                                              color: aboutDescriptionBorder.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
                                      child: TextFormField(
                                        controller: aboutController,
                                        focusNode: aboutFocusNode,
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        onChanged: (val){
                                          aboutDescriptionBorder = val;
                                          setState((){});
                                        },
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'Enter decription here..',
                                          hintStyle: TextStyle(color: Colors.black38),
                                        ),
                                        // describes the field number
                                        style: TextStyle(
                                            // style for the fields
                                            fontSize: 14.h,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50.h,
                                        child: MaterialButton(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                          disabledColor: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          child: Text(
                                              widget.data != null
                                                ? appBloc.localstr.profileButtonEducationsavebutton
                                                : "Add",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  ?.apply(
                                                      color: InsColor(appBloc)
                                                          .appBtnTextColor)),
                                          onPressed:
                                              (schoolController.text.isNotEmpty)
                                                  ? () async {
                                                      validate();
                                                    }
                                                  : null,
                                        )),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  (state is CreateEducationState ||
                          state is GetProfileInfoState ||
                          state is RemoveEducationState ||
                          state is UpdateEducationState ||
                          state is GetEducationTitleState)
                      ? (state.status == Status.LOADING)
                          ? Center(
                              child: AbsorbPointer(
                                  child: AppConstants().getLoaderWidget(iconSize: 70),))
                          : Container()
                      : Container()
                ],
              ));
        });
  }

  Widget commonTextFormField({
    String headerText = "",
    required String hintText,
    required TextEditingController controller,
    required FocusNode fn, Function()? onEditingComplete,
    TextInputAction textInputAction = TextInputAction.next,
    TextCapitalization textCapitalization = TextCapitalization.words,
    TextInputType keyboardType = TextInputType.text
  }){
    String borderView = controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
              text: headerText,
              style: Theme.of(context).textTheme.headline2?.apply(color: InsColor(appBloc).appTextColor),
              children: <TextSpan>[
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red))
              ]),
        ),
        SizedBox(height: 5,),
        TextFormField(
          validator: validateSchool,
          controller: controller,
          focusNode: fn,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          autofocus: false,
          textCapitalization: textCapitalization,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black38),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderView.isEmpty? Color(0xffDADCE0):Color(0xff202124),width: 0.5)),

            // UnderlineInputBorder(
            //   borderSide: BorderSide(),
            // ),
          ),
          onChanged: (val){
            borderView = val;
            setState((){});
          },
          // describes the field number
          style: TextStyle(
            // style for the fields
              fontSize: 14.h,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
        ),
      ],
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }

  void validate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (int.parse(_selectedLocation!) <= int.parse(_selectedendDate!)) {
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
    var diff = int.parse(_selectedLocation!) - int.parse(_selectedendDate!);
    CreateEducationRequest req = CreateEducationRequest();
    req.school = schoolController.text;
    req.country = countryController.text;
    req.title = titleId.toString();
    req.degree = fieldController.text;
    req.fromyear = startDate.text;
    req.toyear = endDate.text;
    req.discription = aboutController.text;
    req.showfromdate = '${startDate.text}-${endDate.text} .$diff yrs';
    req.titleEducation = levelController.text;
    req.oldtitle = titleId.toString();
    req.userId = await sharePrefGetString(sharedPref_userid);

    print('reqdataaa ${createEducationRequestToJson(req)}');

    if (widget.data != null) {
      req.displayNo = widget.data!.displayno.toString();

      widget.profileBloc.add(UpdateEducation(updateEducationRequest: req));
    } else {
      widget.profileBloc.add(CreateEducation(createEducationRequest: req));
    }
  }

  Widget setupAlertDialoadContainer(int initialValue) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      // Change as per your requirement
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.black, // Your color
          platform: TargetPlatform
              .android, // Specify platform as Android so Scrollbar uses the highlightColor
        ),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 3.0,
          controller: scrollController,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: educationalTitleList.length,
            itemBuilder: (BuildContext context, int index) {
              var value = educationalTitleList[index].name;
              return Center(
                child: Container(
                  child: ListTile(
                    title: Text(educationalTitleList[index].name,
                        style: TextStyle(
                            color: selectindex == index
                                ? themeData.accentColor
                                : Colors.black,
                            fontWeight: selectindex == index
                                ? FontWeight.bold
                                : FontWeight.normal)),
                    //tileColor: selectindex == index ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        selectindex = index;
                        titlePos = index;
                        String newValue = educationalTitleList[titlePos].name;
                        if (newValue != selectedValue) {
                          selectedValue = newValue;
                          levelController.text = educationalTitleList[titlePos].name;
                          titleId = educationalTitleList[titlePos].id;
                        }
                      });

                      Navigator.of(context).pop();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? validateSchool(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }

    return null;
  }

  String? validateCountry(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }
    return null;
  }

  String? validateFieldOfStudy(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }
    return null;
  }

  String? validateLevel(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc
          .localstr.profileAlertsubtitleAsteriskmarkedfieldsaremandatory;
    }
    return null;
  }
}
