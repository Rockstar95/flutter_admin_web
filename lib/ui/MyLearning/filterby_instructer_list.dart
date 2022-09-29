import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';

import '../common/outline_button.dart';

class FilterByInstructerList extends StatefulWidget {
  final String appbarTitle;
  final String categoryID;

  FilterByInstructerList(this.categoryID, this.appbarTitle);

  @override
  State<FilterByInstructerList> createState() => _FilterByInstructerListState();
}

class _FilterByInstructerListState extends State<FilterByInstructerList> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  List<Map<String, dynamic>> selectedlocalfilterByList = [];

  @override
  void initState() {
    super.initState();

    myLearningBloc.add(GetFilterIntructorListEvent());

    myLearningBloc.selectedfilterByList.forEach((element) {
      if (element["mainCategory"] == widget.categoryID) {
        selectedlocalfilterByList.add(element);
      }
    });
    print("selectedlocalfilterByList ${selectedlocalfilterByList.toString()}");
    print("selectedlocalfilterByList ${selectedlocalfilterByList.length}");
    print("categoryID ${widget.categoryID}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          appBar: AppBar(
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            title: Text(
              widget.appbarTitle,
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
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 350.0,
                      child: BlocConsumer<MyLearningBloc, MyLearningState>(
                        bloc: myLearningBloc,
                        listener: (context, state) {
                          if (state.status == Status.ERROR) {
                            if (state.message == "401") {
                              AppDirectory.sessionTimeOut(context);
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state.status == Status.LOADING) {
                            return Container(
                              child: Center(
                                child: AbsorbPointer(
                                  child: AppConstants().getLoaderWidget(iconSize: 70)
                                ),
                              ),
                            );
                          } else if (state.status == Status.ERROR) {
                            return Container(
                              child: Center(
                                child: Text(
                                  'No Data Found',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: myLearningBloc
                                  .instructerListResponse.table.length,
                              itemBuilder: (context, i) {
                                bool isSelected = false;
                                selectedlocalfilterByList.forEach((element) {
                                  if (element["CategoryID"] ==
                                          myLearningBloc.instructerListResponse
                                              .table[i].userId
                                              .toString() &&
                                      element["mainCategory"] ==
                                          widget.categoryID) {
                                    isSelected = true;
                                  }
                                });
                                final theme = Theme.of(context)
                                    .copyWith(dividerColor: Colors.black26);

                                return Theme(
                                  data: theme,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              bool isAdd = true;
                                              setState(() {
                                                for (int j = 0;
                                                    j <
                                                        selectedlocalfilterByList
                                                            .length;
                                                    j++) {
                                                  print(
                                                      "a ${selectedlocalfilterByList[j]["CategoryID"]}");
                                                  print(
                                                      "b ${myLearningBloc.instructerListResponse.table[i].userId.toString()}");
                                                  if (selectedlocalfilterByList[j]
                                                          ["CategoryID"] ==
                                                      myLearningBloc
                                                          .instructerListResponse
                                                          .table[i]
                                                          .userId
                                                          .toString()) {
                                                    print(
                                                        "object Matched Removed");
                                                    selectedlocalfilterByList
                                                        .removeAt(j);
                                                    isAdd = false;
                                                    break;
                                                  }
                                                }
                                                if (isAdd) {
                                                  print(
                                                      "object Not - Matched Added");
                                                  Map<String, dynamic> map =
                                                      new Map();
                                                  map["CategoryID"] =
                                                      myLearningBloc
                                                          .instructerListResponse
                                                          .table[i]
                                                          .userId
                                                          .toString();
                                                  map["mainCategory"] =
                                                      widget.categoryID;
                                                  map["categoryDisplayName"] =
                                                      widget.appbarTitle;
                                                  selectedlocalfilterByList
                                                      .add(map);
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                isSelected
                                                    ? Icon(
                                                        Icons.check_box,
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    myLearningBloc
                                                                .instructerListResponse
                                                                .table[i]
                                                                .userName ==
                                                            null
                                                        ? ""
                                                        : myLearningBloc
                                                            .instructerListResponse
                                                            .table[i]
                                                            .userName,
                                                    style: new TextStyle(
                                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                //Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
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
                    myLearningBloc.selectedfilterByList.removeWhere(
                        (item) => item["mainCategory"] == widget.categoryID);
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
                    myLearningBloc.selectedfilterByList.removeWhere(
                        (item) => item["mainCategory"] == widget.categoryID);

                    selectedlocalfilterByList.forEach((element) {
                      myLearningBloc.add(SelectCategoriesEvent(
                          seletedCategoryID: element["CategoryID"].toString(),
                          mainCategory: widget.categoryID,
                          categoryDisplayName: widget.appbarTitle));
                    });
                    Navigator.pop(context);
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
