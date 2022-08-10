import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/sort_model.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';

import '../common/outline_button.dart';

class EventDateFilterBy extends StatefulWidget {
  final String categoryDisplayName;

  EventDateFilterBy(this.categoryDisplayName);

  @override
  State<EventDateFilterBy> createState() => _EventDateFilterByState();
}

class _EventDateFilterByState extends State<EventDateFilterBy> {
  List<SortModel> sortModelList = [];

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  String radioItem = '';
  String radioItemSelected = '';
  int id = 0;

  bool isDateVisible = false;

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  var date1;
  var date2;

  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    generateFilterByModelList();
    print("list --- ${myLearningBloc.selectedDuration}");
    if (myLearningBloc.selectedDuration == "") {
      id = 1000;
    } else {
      sortModelList.forEach((element) {
        if (myLearningBloc.selectedDuration ==
            element.optionIdValue.toString()) {
          id = element.categoryID;
        } else if (myLearningBloc.selectedDuration.contains("~")) {
          id = 7;
          startDate = new TextEditingController(
              text: myLearningBloc.selectedDuration.split("~")[0]);
          endDate = new TextEditingController(
              text: myLearningBloc.selectedDuration.split("~")[1]);

          final df = new DateFormat('yyyy-MM-dd');
          date1 = DateTime.parse(
              "${myLearningBloc.selectedDuration.split("~")[0].trim()} 01:00:00");
          date2 = DateTime.parse(
              "${myLearningBloc.selectedDuration.split("~")[1].trim()} 01:00:00");
          setState(() {
            isDateVisible = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    return Container(
      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          appBar: AppBar(
            backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            title: Text(
              widget.categoryDisplayName,
              style: TextStyle(
                fontSize: 18,
                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back,
                    color: Color(
                      int.parse(
                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                    ))),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 350.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: sortModelList
                                  .map((data) => RadioListTile(
                                        title: Row(
                                          children: <Widget>[
                                            Text(
                                              "${data.optionDisplayText}",
                                              style: new TextStyle(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w400,
                                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        groupValue: id,
                                        value: data.categoryID,
                                        onChanged: (val) {
                                          setState(() {
                                            radioItem = data.optionDisplayText;
                                            radioItemSelected =
                                                data.categoryID.toString();
                                            id = data.categoryID;
                                            if (id == 7) {
                                              startDate.text = "";
                                              endDate.text = "";
                                              isDateVisible = true;
                                            } else {
                                              isDateVisible = false;
                                            }
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                            isDateVisible
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InkWell(
                                            onTap: () async {
                                              DateTime date = DateTime(1957);

                                              date = await showDatePicker(
                                                    context: context,
                                                    initialDate: new DateTime.now(),
                                                    firstDate: new DateTime(1957),
                                                    lastDate:
                                                        DateTime(2030, 12, 31),
                                                    builder: (BuildContext context,
                                                        Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.light()
                                                            .copyWith(
                                                          primaryColor:
                                                              Colors.lightGreen,
                                                          //Head background
                                                          accentColor:
                                                              Colors.lightGreen,
                                                          //selection color
                                                          dialogBackgroundColor: Colors
                                                              .white, //Background color
                                                        ),
                                                        child: child ?? SizedBox(),
                                                      );
                                                    },
                                                  ) ??
                                                  DateTime(1957);

                                              final df =
                                                  new DateFormat('yyyy-MM-dd');
                                              date1 = DateTime(
                                                  date.day, date.year, date.month);

                                              startDate.text =
                                                  df.format(date).toString();
                                              startDate = new TextEditingController(
                                                  text: df.format(date).toString());
                                            },
                                            child: IgnorePointer(
                                              child: TextFormField(
                                                  enabled: false,
                                                  controller: startDate,
                                                  decoration: new InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                          width: 1.0),
                                                    ),
                                                    hintText: 'Start Date',
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InkWell(
                                            onTap: () async {
                                              DateTime date = DateTime(1900);

                                              date = await showDatePicker(
                                                    context: context,
                                                    initialDate: new DateTime.now(),
                                                    firstDate: DateTime(1957),
                                                    lastDate:
                                                        DateTime(2030, 12, 31),
                                                    builder: (BuildContext context,
                                                        Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.light()
                                                            .copyWith(
                                                                primaryColor:
                                                                    const Color(
                                                                        0xFF4A5BF6),
                                                                //Head background
                                                                accentColor:
                                                                    const Color(
                                                                        0xFF4A5BF6) //selection color
                                                                //dialogBackgroundColor: Colors.white,//Background color
                                                                ),
                                                        child: child ?? SizedBox(),
                                                      );
                                                    },
                                                  ) ??
                                                  DateTime(1900);

                                              print('startdate $date');
                                              final df =
                                                  new DateFormat('yyyy-MM-dd');
                                              print(df.format(date));

                                              date2 = DateTime(
                                                  date.day, date.year, date.month);

                                              endDate.text =
                                                  df.format(date).toString();
                                              endDate = new TextEditingController(
                                                  text: df.format(date).toString());
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: IgnorePointer(
                                              child: TextFormField(
                                                enabled: false,
                                                controller: endDate,
                                                decoration: new InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        width: 1.0),
                                                  ),
                                                  hintText: 'End Date',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ))),
            ],
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                  border: Border.all(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                  child: Text(appBloc.localstr.filterBtnResetbutton,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                  onPressed: () {
                    //widget.refresh();
                    myLearningBloc.selectedDuration = "";
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: MaterialButton(
                  disabledColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                      .withOpacity(0.5),
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text(appBloc.localstr.filterBtnApplybutton,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                  onPressed: () {
                    if (isDateVisible) {
                      if (date1 != null && date2 != null) {
                        if (date2.isAfter(date1)) {
                          myLearningBloc.selectedDuration =
                              "${startDate.text.toString()} ~ ${endDate.text.toString()}";
                          Navigator.pop(context);
                        } else {
                          flutterToast.showToast(
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                              child: CommonToast(
                                  displaymsg:
                                      'Please select start date greater than end date'));
                        }
                      } else {
                        flutterToast.showToast(
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                            child: CommonToast(displaymsg: 'Please select dates'));
                      }
                    } else {
                      myLearningBloc.selectedDuration = radioItemSelected;
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateFilterByModelList() {
    setState(() {
      SortModel sortModelToday = new SortModel();
      sortModelToday.optionDisplayText =
          appBloc.localstr.filterLblEventdatetoday;
      sortModelToday.optionIdValue = "today";
      sortModelToday.categoryID = 1;
      sortModelList.add(sortModelToday);

      SortModel sortModelTomorrow = new SortModel();
      sortModelTomorrow.optionDisplayText =
          appBloc.localstr.filterLblEventdatetomorrow;
      sortModelTomorrow.optionIdValue = "tomorrow";
      sortModelTomorrow.categoryID = 2;
      sortModelList.add(sortModelTomorrow);

      SortModel sortModelThisWeek = new SortModel();
      sortModelThisWeek.optionDisplayText =
          appBloc.localstr.filterLblEventdatethisweek;
      sortModelThisWeek.optionIdValue = "thisweek";
      sortModelThisWeek.categoryID = 3;
      sortModelList.add(sortModelThisWeek);

      SortModel sortModelNextweek = new SortModel();
      sortModelNextweek.optionDisplayText =
          appBloc.localstr.filterLblEventdatenextweek;
      sortModelNextweek.optionIdValue = "nextweek";
      sortModelNextweek.categoryID = 4;
      sortModelList.add(sortModelNextweek);

      SortModel sortModelThismonth = new SortModel();
      sortModelThismonth.optionDisplayText =
          appBloc.localstr.filterLblEventdatethismonth;
      sortModelThismonth.optionIdValue = "thismonth";
      sortModelThismonth.categoryID = 5;
      sortModelList.add(sortModelThismonth);

      SortModel sortModelNextmonth = new SortModel();
      sortModelNextmonth.optionDisplayText =
          appBloc.localstr.filterLblEventdatenextmonth;
      sortModelNextmonth.optionIdValue = "nextmonth";
      sortModelNextmonth.categoryID = 6;
      sortModelList.add(sortModelNextmonth);

      SortModel sortModelChooseDate = new SortModel();
      sortModelChooseDate.optionDisplayText =
          appBloc.localstr.filterLblEentdatechoosedate;
      sortModelChooseDate.optionIdValue = "choosedate";
      sortModelChooseDate.categoryID = 7;
      sortModelList.add(sortModelChooseDate);
    });
  }
}
