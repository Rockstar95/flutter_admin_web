import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../common/outline_button.dart';

class FilterBySelectedSubCategory extends StatefulWidget {
  final String categoryID;
  final String categoryDisplayName;
  final dynamic subcategoryId;

  const FilterBySelectedSubCategory({
    required this.categoryID,
    required this.categoryDisplayName,
    this.subcategoryId,
  });

  @override
  State<FilterBySelectedSubCategory> createState() =>
      _FilterBySelectedSubCategoryState();
}

class _FilterBySelectedSubCategoryState
    extends State<FilterBySelectedSubCategory> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  List<Map<String, dynamic>> selectedlocalfilterByList = [];
  List<FilterByModel> filterByList = [];

  @override
  void initState() {
    super.initState();
    print("${widget.categoryID}");
    setState(() {
      myLearningBloc.selectedfilterByList.forEach((element) {
        print(
            "mainCategory ${element["mainCategory"]}--- categoryID ${widget.categoryID}");
        if (element["mainCategory"] == widget.categoryID) {
          print('selected');
          selectedlocalfilterByList.add(element);
        }
      });
      if (widget.subcategoryId != null) {
        filterByList.clear();
        myLearningBloc.mainFilterByList.forEach((element) {
          if (element.parentId == widget.subcategoryId) {
            filterByList.add(element);
          }
        });
        print("Sub - ${filterByList.toString()}");
      }
    });
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
              widget.categoryDisplayName,
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
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filterByList.length,
                        itemBuilder: (context, i) {
                          bool isSelected = false;
                          selectedlocalfilterByList.forEach((element) {
                            if (element["CategoryID"] ==
                                    filterByList[i].categoryId.toString() &&
                                element["mainCategory"] == widget.categoryID) {
                              isSelected = true;
                            }
                          });
                          final theme = Theme.of(context)
                              .copyWith(dividerColor: Colors.black26);

                          return Theme(
                            data: theme,
                            child: GestureDetector(
                              onTap: () {
                                bool isAdd = true;
                                setState(() {
                                  for (int j = 0; j < selectedlocalfilterByList.length; j++) {
                                    if (selectedlocalfilterByList[j]["CategoryID"] == filterByList[i].categoryId.toString()) {
                                      print("object Matched Removed");
                                      selectedlocalfilterByList.removeAt(j);
                                      isAdd = false;
                                      break;
                                    }
                                  }
                                  if (isAdd) {
                                    print("object Not - Matched Added");
                                    Map<String, dynamic> map = new Map();
                                    map["CategoryID"] = filterByList[i].categoryId.toString();
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        GestureDetector(
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
                                                if (selectedlocalfilterByList[j]["CategoryID"] == filterByList[i].categoryId.toString()) {
                                                  print("object Matched Removed");
                                                  selectedlocalfilterByList.removeAt(j);
                                                  isAdd = false;
                                                  break;
                                                }
                                              }
                                              if (isAdd) {
                                                print("object Not - Matched Added");
                                                Map<String, dynamic> map = new Map();
                                                map["CategoryID"] = filterByList[i].categoryId.toString();
                                                map["mainCategory"] = widget.categoryID;
                                                map["categoryDisplayName"] = widget.categoryDisplayName;
                                                selectedlocalfilterByList.add(map);
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          filterByList[i].categoryName == null
                                              ? ""
                                              : filterByList[i].categoryName,
                                          style: new TextStyle(
                                              fontSize: 15.h,
                                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ),
                                      ],
                                    ),
                                    filterByList[i].hasChild
                                        ? Icon(
                                            Icons.chevron_right,
                                            color: InsColor(appBloc).appIconColor,
                                          )
                                        : Container()
                                    //Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                  ],
                                ),
                              ),
                            ),
                          );
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
                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                  child: Text(appBloc.localstr.filterBtnResetbutton,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                  onPressed: () {
                    myLearningBloc.selectedfilterByList.removeWhere((item) => item["mainCategory"] == widget.categoryID);

                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: MaterialButton(
                  disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text(appBloc.localstr.filterBtnApplybutton,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
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
    );
  }
}
