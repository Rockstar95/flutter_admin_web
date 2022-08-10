import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';

import '../common/outline_button.dart';

class SortScreen extends StatefulWidget {
  final bool isGroupby;
  final Function refresh;

  const SortScreen({
    required this.isGroupby,
    required this.refresh,
  });

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  String radioItem = '';
  String radioItemSelected = '';
  int id = 0;

  // Group Value for Radio Button.

  @override
  void initState() {
    super.initState();

    if (widget.isGroupby) {
      setState(() {
        if (myLearningBloc.selectedGroupby == "") {
          id = 1000;
        } else {
          myLearningBloc.groupList.forEach((element) {
            if (myLearningBloc.selectedGroupby == element.optionIdValue) {
              id = element.categoryID;
            }
          });
        }
      });
    } else {
      setState(() {
        if (myLearningBloc.selectedSort == "") {
          id = myLearningBloc.sortList[0].categoryID;
        } else {
          myLearningBloc.sortList.forEach((element) {
            if (myLearningBloc.selectedSort == element.optionIdValue) {
              id = element.categoryID;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    print("Selected Sort------ ${myLearningBloc.selectedSort}");
    print("Selected GroupBY------ ${myLearningBloc.selectedGroupby}");

    return Container(
      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          appBar: AppBar(
            backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            title: Text(
              widget.isGroupby
                  ? appBloc.localstr.filterLblGroupbytitlelabel
                  : appBloc.localstr.filterLblSortbytitlelabel,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
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
              Expanded(
                  child: Container(
                height: 350.0,
                child: widget.isGroupby
                    ? Column(
                        children: myLearningBloc.groupList
                            .map((data) => RadioListTile(
                                  activeColor: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  title: Text(
                                    "${data.optionDisplayText}",
                                    style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                  groupValue: id,
                                  value: data.categoryID,
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = data.optionDisplayText;
                                      radioItemSelected = data.optionIdValue;
                                      id = data.categoryID;
                                    });
                                  },
                                ))
                            .toList(),
                      )
                    : Column(
                        children: myLearningBloc.sortList
                            .map((data) => RadioListTile(
                                  activeColor: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  title: Text(
                                    "${data.optionDisplayText}",
                                    style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                  groupValue: id,
                                  value: data.categoryID,
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = data.optionDisplayText;
                                      radioItemSelected = data.optionIdValue;
                                      id = data.categoryID;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
              )),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
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
                      if (widget.isGroupby) {
                        myLearningBloc.selectedGroupby = "";
                        myLearningBloc.selectedGroupbyName = "";
                      } else {
                        myLearningBloc.selectedSort = "MC.Name asc";
                        myLearningBloc.selectedSortName = "";
                      }
                      widget.refresh();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 13,),
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
                      if (widget.isGroupby) {
                        myLearningBloc.selectedGroupby = radioItemSelected;
                        myLearningBloc.selectedGroupbyName = radioItem;
                      } else {
                        myLearningBloc.selectedSort = radioItemSelected;
                        myLearningBloc.selectedSortName = radioItem;
                      }
                      widget.refresh();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
