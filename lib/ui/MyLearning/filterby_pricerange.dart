import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/outline_button.dart';

class FilterByPriceRange extends StatefulWidget {
  final String categoryDisplayName;

  FilterByPriceRange(this.categoryDisplayName);

  @override
  State<FilterByPriceRange> createState() => _FilterByPriceRangeState();
}

class _FilterByPriceRangeState extends State<FilterByPriceRange> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  TextEditingController minValueController = TextEditingController();
  TextEditingController maxValueController = TextEditingController();
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    if (myLearningBloc.selectedPriceRange.toString().length > 0 &&
        myLearningBloc.selectedPriceRange.contains(",")) {
      minValueController = new TextEditingController(
          text: myLearningBloc.selectedPriceRange.split(",")[0]);
      maxValueController = new TextEditingController(
          text: myLearningBloc.selectedPriceRange.split(",")[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

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
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: minValueController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            width: 1.0),
                      ),
                      hintText: 'Min value',
                    ),
                    onChanged: (value) {
                      minValueController =
                          new TextEditingController(text: value.toString());
                    },
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Align(alignment: Alignment.center, child: Text(" | "))),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: maxValueController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            width: 1.0),
                      ),
                      hintText: 'Max value',
                    ),
                    onChanged: (value) {
                      maxValueController =
                          new TextEditingController(text: value.toString());
                    },
                  ),
                ),
              ],
            ),
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
                    myLearningBloc.selectedPriceRange = "";
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
                    //myLearningBloc.selectedRating = radioItemSelected;
                    if (minValueController.text.length == 0) {
                      flutterToast.showToast(
                        child: CommonToast(displaymsg: 'Enter minimum value'),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
                    } else if (maxValueController.text.length == 0) {
                      flutterToast.showToast(
                        child: CommonToast(displaymsg: 'Enter maximum value'),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
                    } else {
                      myLearningBloc.selectedPriceRange =
                          "${minValueController.text},${maxValueController.text}";
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
}
