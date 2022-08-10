import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/content_filterby.dart';
import 'package:flutter_admin_web/ui/MyLearning/sort_screen.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';

class MyLearningFilter extends StatefulWidget {
  final String componentId;

  MyLearningFilter({required this.componentId});
  @override
  State<MyLearningFilter> createState() => _MyLearningFilterState();
}

class _MyLearningFilterState extends State<MyLearningFilter> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);
  final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
      bloc: changeThemeBloc,
      builder: (context, state) => Container(
        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            appBar: AppBar(
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
              title: Text(
                appBloc.localstr.filterLblFiltertitlelabel,
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
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: BlocConsumer(
                        bloc: myLearningBloc,
                        listener: (context, state) {},
                        builder: (context, state) {
                          return ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myLearningBloc.allFilterModelList.length,
                            itemBuilder: (context, i) {
                              final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);

                              return Theme(
                                data: theme,
                                child: GestureDetector(
                                  onTap: () {
                                    print("Click menu ${myLearningBloc.allFilterModelList[i].categoryName}");
                                    if (myLearningBloc.allFilterModelList[i].categoryName == "Group By") {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => SortScreen(
                                              isGroupby: true, refresh: refresh)));
                                    }
                                    else if (myLearningBloc.allFilterModelList[i].categoryName == "Sort By") {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => SortScreen(
                                              isGroupby: false, refresh: refresh)));
                                    }
                                    else if (myLearningBloc.allFilterModelList[i].categoryName == "Filter By") {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContentFilterByScreen(refresh: refresh, componentId: widget.componentId,)));
                                    }
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
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
                                                Text(
                                                  myLearningBloc.allFilterModelList[i].categoryName,
                                                  style: TextStyle(
                                                    fontSize: 15.h,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  color: InsColor(appBloc).appIconColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          selectedWigets(myLearningBloc.allFilterModelList[i].categoryName)
                                        ],
                                      ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: CommonPrimarySecondaryButton(
                      onPressed: (){
                        myLearningBloc.add(ResetFilterEvent());
                        Navigator.pop(context);
                      },
                      isPrimary: false,
                      text: appBloc.localstr.filterBtnResetbutton,
                    ),
                  ),
                  SizedBox(width: 13,),
                  Expanded(
                    flex: 3,
                    child: CommonPrimarySecondaryButton(
                      onPressed: (){
                        myLearningBloc.add(ApplyFilterEvent());
                        Navigator.pop(context);
                      },
                      isPrimary: true,
                      text: appBloc.localstr.filterBtnApplybutton,
                    ),
                  ),
                  // Expanded(
                  //   child: OutlineButton(
                  //     border: Border.all(
                  //         color: Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                  //     child: Text(appBloc.localstr.filterBtnResetbutton,
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                  //     onPressed: () {
                  //       myLearningBloc.add(ResetFilterEvent());
                  //       /* Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) => ActBase()),
                  //         ModalRoute.withName('/'),
                  //       );*/
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
                  // Expanded(
                  //   child: MaterialButton(
                  //     disabledColor: Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                  //         .withOpacity(0.5),
                  //     color: Color(int.parse(
                  //         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  //     child: Text(appBloc.localstr.filterBtnApplybutton,
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             color: Color(int.parse(
                  //                 "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                  //     onPressed: () {
                  //       myLearningBloc.add(ApplyFilterEvent());
                  //       /* Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) => ActBase()),
                  //         ModalRoute.withName('/'),
                  //       );*/
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  refresh() {
    setState(() {});
  }

  Widget selectedWigets(String name) {
    switch (name) {
      case "Filter By":
        return (myLearningBloc.selectedfilterByList.length == 0 &&
                myLearningBloc.selectedCredits == "" &&
                myLearningBloc.selectedRating == "" &&
                myLearningBloc.selectedDuration == "" &&
                myLearningBloc.selectedPriceRange == "")
            ? Container()
            : Text(
                getSelectedCatgoryString(myLearningBloc.selectedfilterByList),
                style: new TextStyle(
                    fontSize: 13.h,
                    fontStyle: FontStyle.italic,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              );
      case "Group By":
        return myLearningBloc.selectedGroupbyName == ""
            ? Container()
            : Text(myLearningBloc.selectedGroupbyName,
                style: new TextStyle(
                  fontSize: 13.h,
                  fontStyle: FontStyle.italic,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                ));
      case "Sort By":
        return myLearningBloc.selectedSortName == ""
            ? Container()
            : Text(myLearningBloc.selectedSortName,
                style: new TextStyle(
                  fontSize: 13.h,
                  fontStyle: FontStyle.italic,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                ));
      default:
        return SizedBox();
    }
  }

  String getSelectedCatgoryString(List<Map<String, dynamic>> selectedfilterByList) {
    String selectedString = "";
    List<String> selectedcat = [];
    selectedfilterByList.forEach((element) {
      if (!selectedcat.contains(element["categoryDisplayName"])) {
        selectedcat.add(element["categoryDisplayName"]);
      }
    });
    /*print("selectedCredits-----${myLearningBloc.selectedCredits}");
    print("selectedRating-----${myLearningBloc.selectedCredits}");
    print("selectedPriceRange-----${myLearningBloc.selectedCredits}");*/

    if (myLearningBloc.selectedCredits != "") {
      selectedcat.add("Credit");
      //selectedString = "Credit";
    }
    if (myLearningBloc.selectedRating != "") {
      selectedcat.add("Rating");
    }
    if (myLearningBloc.selectedPriceRange != "") {
      selectedcat.add("Price Range");
    }
    if (myLearningBloc.selectedDuration != "") {
      selectedcat.add("Dates");
    }
    selectedString = formatString(selectedcat);

    return selectedString;
  }

  String formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }
}
