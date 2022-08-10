import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';

import '../common/outline_button.dart';

class SkillCategory extends StatefulWidget {
  final List<SkillCateModel> skillCateModel;

  SkillCategory({
    Key? key,
    required this.skillCateModel,
  }) : super(key: key);

  @override
  State<SkillCategory> createState() => _SkillCategoryState();
}

class _SkillCategoryState extends State<SkillCategory> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedPosition = -1;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;
  List<Map<String, dynamic>> selectedlocalfilterByList = [];
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    print("*** : " + widget.skillCateModel.length.toString());
    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    askTheExpertBloc.add(GetSkillCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Skills',
          style: TextStyle(
              fontSize: 20,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () {
            //  List<SkillCateModel> tempWikilist = new List();
            Navigator.pop(context, widget.skillCateModel);
          },
          child: Icon(Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        actions: <Widget>[
          SizedBox(
            width: 10.h,
          ),
          SizedBox(
            width: 10.h,
          ),
        ],
      ),
      body: Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: Stack(
          children: <Widget>[
            Divider(
              height: 2,
              color: Colors.black87,
            ),
            skillCategoryListWidget()
          ],
        ),
      ),
    );
  }

  Widget skillCategoryListWidget() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && askTheExpertBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
              ),
            ),
          );
        }
        else if (state.status == Status.ERROR) {
          return noDataFound(true);
        }
        else {
          widget.skillCateModel.forEach((elementl) {
            if (elementl.isSelected) {
              askTheExpertBloc.skillCategoryResponse.table.forEach((element) {
                if (elementl.skillID == element.skillID) {
                  element.isSelected = true;
                } else if (elementl.preferrenceTitle ==
                    element.preferrenceTitle) {
                  element.isSelected = true;
                }
              });
            }
          });
          return Scaffold(
            key: scaffoldKey,
            body: new Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: askTheExpertBloc.skillCategoryResponse.table.length,
                  itemBuilder: (context, index) {
                    final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);
                    return Theme(
                        data: theme,
                        child: GestureDetector(
                            onTap: () {
                              itemChange(askTheExpertBloc.skillCategoryResponse.table[index].isSelected, index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
                                      child: askTheExpertBloc.skillCategoryResponse.table[index].isSelected
                                          ? Icon(
                                        Icons.check_box,
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                      )
                                          : Icon(
                                        Icons.check_box_outline_blank,
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                      onTap: () {
                                        itemChange(askTheExpertBloc.skillCategoryResponse.table[index].isSelected, index);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      askTheExpertBloc.skillCategoryResponse.table[index].preferrenceTitle,
                                      style: new TextStyle(
                                          fontSize: 15.h,
                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ),
                                ],
                              ),
                              /*child: new Column(
                                children: <Widget>[
                                  new Theme(
                                      data: ThemeData(unselectedWidgetColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      child: CheckboxListTile(
                                        activeColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                        value: askTheExpertBloc.skillCategoryResponse.table[index].isSelected,
                                        title: new Text(
                                          askTheExpertBloc.skillCategoryResponse.table[index].preferrenceTitle,
                                          style: TextStyle(
                                            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                            fontSize: 12.h,
                                          ),
                                        ),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        onChanged: (bool? val) {
                                          ItemChange(val ?? false, index);
                                        },
                                      ),
                                  )
                                ],
                              ),*/
                            ),
                        ),
                    );
                  }),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
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
                          // List<SkillCateModel> tempSkilllist = new List();
                          widget.skillCateModel.clear();
                          Navigator.pop(context, widget.skillCateModel);
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
                          List<SkillCateModel> tempSkilllist = [];
                          askTheExpertBloc.skillCategoryResponse.table
                              .forEach((element) {
                            if (element.isSelected) {
                              print(
                                  'print selected ids${element.preferrenceTitle}');
                              tempSkilllist.add(element);
                            }
                          });
                          Navigator.pop(context, tempSkilllist);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Text(
                      appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              )
            ],
          )
        : new Container();
  }

  void itemChange(bool val, int index) {
    setState(() {
      askTheExpertBloc.skillCategoryResponse.table[index].isSelected = !val;
      widget.skillCateModel.forEach((elementl) {
        if (elementl.skillID == askTheExpertBloc.skillCategoryResponse.table[index].skillID) {
          elementl.isSelected = val;
        }
      });
    });
  }
}
