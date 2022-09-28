import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/filterby_subcategory.dart';

import '../common/outline_button.dart';

class FilterBySelectedCategory extends StatefulWidget {
  final String categoryID;
  final String categoryDisplayName;
  final String componentId;

  const FilterBySelectedCategory(this.categoryID, this.categoryDisplayName,this.componentId);

  @override
  State<FilterBySelectedCategory> createState() =>
      _FilterBySelectedCategoryState();
}

class _FilterBySelectedCategoryState extends State<FilterBySelectedCategory> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  List<Map<String, dynamic>> selectedlocalfilterByList = [];

  @override
  void initState() {
    super.initState();
    selectedlocalfilterByList = [];
    myLearningBloc.add(GetCategoriesTreeEvent(categoryID: widget.categoryID,componentId: widget.componentId));
    myLearningBloc.selectedfilterByList.forEach((element) {
      if (element["mainCategory"] == widget.categoryID) {
        selectedlocalfilterByList.add(element);
      }
    });
    myLearningBloc.selectedfilterByList.forEach((element) {
      if (element["CategoryID"].toString() ==
          myLearningBloc.selectedMainCategoryId) {
        selectedlocalfilterByList.add(element);
      }
    });
    print("selectedlocalfilterByList ${selectedlocalfilterByList.toString()}");
    print("selectedlocalfilterByList ${selectedlocalfilterByList.length}");
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
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
                              itemCount: myLearningBloc.filterByList.length,
                              itemBuilder: (context, i) {
                                bool isSelected = false;
                                selectedlocalfilterByList.forEach((element) {
                                  if (element["CategoryID"] == myLearningBloc.filterByList[i].categoryId.toString() && element["mainCategory"] == widget.categoryID) {
                                    isSelected = true;
                                  }
                                });

                                selectedlocalfilterByList.forEach((element) {
                                  if (element["CategoryID"] == myLearningBloc.filterByList[i].categoryId.toString()) {
                                    isSelected = true;
                                  }
                                });

                                final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);

                                print("hasChild ${myLearningBloc.filterByList[i].hasChild}");

                                return Theme(
                                  data: theme,
                                  child: GestureDetector(
                                    onTap: () {
                                      bool isAdd = true;
                                      setState(() {
                                        for (int j = 0; j < selectedlocalfilterByList.length; j++) {
                                          print("a ${selectedlocalfilterByList[j]["CategoryID"]}");
                                          print("b ${myLearningBloc.filterByList[i].categoryId.toString()}");
                                          if (selectedlocalfilterByList[j]["CategoryID"] == myLearningBloc.filterByList[i].categoryId.toString()) {
                                            print("object Matched Removed");
                                            selectedlocalfilterByList.removeAt(j);
                                            isAdd = false;
                                            break;
                                          }
                                        }
                                        if (isAdd) {
                                          print("object Not - Matched Added");
                                          Map<String, dynamic>
                                          map = new Map();
                                          map["CategoryID"] = myLearningBloc.filterByList[i].categoryId.toString();
                                          map["mainCategory"] = widget.categoryID;
                                          map["categoryDisplayName"] = widget.categoryDisplayName;
                                          selectedlocalfilterByList.add(map);
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                        border: Border.all(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")).withOpacity(0.15)),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: GestureDetector(
                                              child: isSelected
                                                  ? Icon(
                                                      Icons.check_box,
                                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    )
                                                  : Icon(
                                                      Icons.check_box_outline_blank,
                                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    ),
                                              onTap: () {
                                                bool isAdd = true;
                                                setState(() {
                                                  for (int j = 0; j < selectedlocalfilterByList.length; j++) {
                                                    print("a ${selectedlocalfilterByList[j]["CategoryID"]}");
                                                    print("b ${myLearningBloc.filterByList[i].categoryId.toString()}");
                                                    if (selectedlocalfilterByList[j]["CategoryID"] == myLearningBloc.filterByList[i].categoryId.toString()) {
                                                      print("object Matched Removed");
                                                      selectedlocalfilterByList.removeAt(j);
                                                      isAdd = false;
                                                      break;
                                                    }
                                                  }
                                                  if (isAdd) {
                                                    print("object Not - Matched Added");
                                                    Map<String, dynamic>
                                                    map = new Map();
                                                    map["CategoryID"] = myLearningBloc.filterByList[i].categoryId.toString();
                                                    map["mainCategory"] = widget.categoryID;
                                                    map["categoryDisplayName"] = widget.categoryDisplayName;
                                                    selectedlocalfilterByList.add(map);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (myLearningBloc.filterByList[i].hasChild) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => FilterBySelectedSubCategory(
                                                        categoryID: "sub${widget.categoryID}",
                                                        categoryDisplayName: myLearningBloc.filterByList[i].categoryName,
                                                        subcategoryId: myLearningBloc.filterByList[i].categoryId,
                                                      ),
                                                    ));
                                                }
                                                else {
                                                  bool isAdd = true;
                                                  setState(() {
                                                    for (int j = 0; j < selectedlocalfilterByList.length; j++) {
                                                      print("a ${selectedlocalfilterByList[j]["CategoryID"]}");
                                                      print("b ${myLearningBloc.filterByList[i].categoryId.toString()}");
                                                      if (selectedlocalfilterByList[j]["CategoryID"] == myLearningBloc.filterByList[i].categoryId.toString()) {
                                                        print("object Matched Removed");
                                                        selectedlocalfilterByList.removeAt(j);
                                                        isAdd = false;
                                                        break;
                                                      }
                                                    }
                                                    if (isAdd) {
                                                      print("object Not - Matched Added");
                                                      Map<String, dynamic>
                                                      map = new Map();
                                                      map["CategoryID"] = myLearningBloc.filterByList[i].categoryId.toString();
                                                      map["mainCategory"] = widget.categoryID;
                                                      map["categoryDisplayName"] = widget.categoryDisplayName;
                                                      selectedlocalfilterByList.add(map);
                                                    }
                                                  });
                                                }
                                              },
                                              child: Text(
                                                myLearningBloc.filterByList[i].categoryName == null
                                                    ? ""
                                                    : myLearningBloc.filterByList[i].categoryName,
                                                style: new TextStyle(
                                                  fontSize: 15.h,
                                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          myLearningBloc.filterByList[i].hasChild
                                              ? Expanded(
                                                  flex: 1,
                                                  child: Icon(
                                                    Icons.chevron_right,
                                                    color: InsColor(appBloc).appIconColor,
                                                  ),
                                                )
                                              : Expanded(
                                                  flex: 1,
                                                  child: Container())
                                          //Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                        ],
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Row(
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
                      myLearningBloc.selectedfilterByList.removeWhere(
                          (item) => item["mainCategory"] == widget.categoryID);

                      selectedlocalfilterByList.forEach((element) {
                        myLearningBloc.add(SelectCategoriesEvent(
                            seletedCategoryID: element["CategoryID"].toString(),
                            mainCategory: widget.categoryID,
                            categoryDisplayName: widget.categoryDisplayName));
                      });
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
