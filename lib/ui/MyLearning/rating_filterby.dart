import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/sort_model.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';

import '../common/outline_button.dart';

class RatingFilterBy extends StatefulWidget {
  final String categoryDisplayName;

  RatingFilterBy(this.categoryDisplayName);

  @override
  State<RatingFilterBy> createState() => _RatingFilterByState();
}

class _RatingFilterByState extends State<RatingFilterBy> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  List<SortModel> ratingList = [];
  String radioItem = '';
  String radioItemSelected = '';
  int id = 0;

  @override
  void initState() {
    super.initState();

    getRatingFilterList();
    setState(() {
      if (myLearningBloc.selectedRating == "") {
        id = 1000;
      } else {
        ratingList.forEach((element) {
          if (myLearningBloc.selectedRating == element.categoryID.toString()) {
            id = element.categoryID;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: Scaffold(
        backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        appBar: AppBar(
          backgroundColor: InsColor(appBloc).appBGColor,
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
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
              )),
        ),
        body: Column(
          children: <Widget>[
            /*Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('$radioItem', style: TextStyle(fontSize: 23))),*/
            Expanded(
                child: Container(
                    height: 350.0,
                    child: Column(
                      children: ratingList
                          .map((data) => RadioListTile(
                                activeColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                title: Row(
                                  children: <Widget>[
                                    SmoothStarRating(
                                        allowHalfRating: true,
                                        starCount: 5,
                                        rating: double.parse(data.optionIdValue),
                                        size: ScreenUtil().setHeight(30),
                                        // filledIconData: Icons.blur_off,
                                        // halfFilledIconData: Icons.blur_on,
                                        color: Colors.orange,
                                        borderColor: Colors.orange,
                                        spacing: 0.0),
                                    Text(
                                      "${data.optionDisplayText}",
                                      style: TextStyle(
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.w400,
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
                                  });
                                },
                              ))
                          .toList(),
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
                  myLearningBloc.selectedRating = "";
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
                  myLearningBloc.selectedRating = radioItemSelected;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getRatingFilterList() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        SortModel sortModel = new SortModel();

        sortModel.optionDisplayText = "${i + 1.5}  and Up";
        sortModel.optionIdValue = "${i + 1.5}";
        sortModel.categoryID = i;
        sortModel.ratingValue = int.parse(
            double.parse(sortModel.optionIdValue.toString())
                .round()
                .toString());

        ratingList.add(sortModel);
      }
    });
  }
}
