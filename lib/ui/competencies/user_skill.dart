import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/bloc/my_competencies_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/event/my_competencies_event.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/pref_category_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/user_skill_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/state/my_competencies_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/fade_animation.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';

import '../../configs/constants.dart';
import '../global_search_screen.dart';

class UserSkill extends StatefulWidget {
  final int jobId;
  final NativeMenuModel nativeMenuModel;
  final PrefCategoryList prefCategoryList;

  const UserSkill({
    required this.jobId,
    required this.prefCategoryList,
    required this.nativeMenuModel,
  });

  @override
  _UserSkillState createState() => _UserSkillState();
}

class _UserSkillState extends State<UserSkill>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyCompetenciesBloc myCompetenciesBloc;
  int isSelectedPos = -1;

  @override
  void initState() {
    super.initState();
    myCompetenciesBloc = MyCompetenciesBloc(
        myCompetenciesRepository: MyCompetenciesRepositoryBuilder.repository());
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          widget.prefCategoryList.prefCategoryTitle,
          style: TextStyle(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
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
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: Stack(
            children: [
              userSkillWidget(context, itemWidth, itemHeight)
            ],
          )),
    );
  }

  Widget userSkillWidget(BuildContext context, double itemWidth, double itemHeight) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    return BlocConsumer<MyCompetenciesBloc, MyCompetenciesState>(
      bloc: myCompetenciesBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == '401') {
            AppDirectory.sessionTimeOut(context);
          }
        }

        if (state.status == Status.COMPLETED) {
          if (state is UserSkillEvaluationState) {
            refresh();
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING &&
            myCompetenciesBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70),
            ),
          );
        }
        else if (myCompetenciesBloc.userSkillListResponse.skillsList.length == 0) {
          return noDataFound(true);
        }
        else {
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          cursorColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                          cardColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        ),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              myCompetenciesBloc.userSkillListResponse.skillsList[index].isExpanded = !isExpanded;
                            });
                          },
                          // dividerColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          dividerColor: Colors.transparent,
                          elevation: 0,
                          children: myCompetenciesBloc.userSkillListResponse.skillsList.map<ExpansionPanel>((SkillsList skillsList) {
                            return ExpansionPanel(
                              backgroundColor: skillsList.isExpanded ? Colors.grey.shade300 : AppColors.getAppBGColor(),
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return FadeAnimation(
                                    0.5,
                                    GestureDetector(
                                        onTap: () => {
                                              setState(() {
                                                skillsList.isExpanded =
                                                    !isExpanded;
                                              })
                                            },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(
                                                        skillsList.skillName,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )));
                              },
                              body: Container(
                                color: AppColors.getAppBGColor(),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Text('Skill', style: TextStyle(color: AppColors.getAppTextColor())),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: LinearProgressIndicator(
                                            value: double.parse(skillsList.weightedAverage) / 10,
                                            backgroundColor: AppColors.getAppButtonBGColor().withOpacity(0.2),
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColors.getAppButtonBGColor(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Row(
                                              children: [
                                                Text(
                                                    'Average: ' +
                                                        skillsList
                                                            .weightedAverage,
                                                    style: TextStyle(
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors.getAppTextColor(),
                                                    )),
                                                Text(
                                                    ' | Gap: ' + skillsList.gap,
                                                    style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: AppColors.getAppTextColor()))
                                              ],
                                            )),
                                            Text(
                                                'Required: ' +
                                                    double.parse(skillsList
                                                            .requiredProficiency
                                                            .toString())
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: AppColors.getAppTextColor())),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, bottom: 10.0),
                                        child: Text('Self',
                                            style: TextStyle(
                                                color: AppColors.getAppTextColor())),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                                          child: Container(
                                            height: 35.0,
                                            child: Row(
                                              children: List.generate(skillsList.requiredProfValues.length, (index) {
                                                return Expanded(
                                                  child: Container(
                                                      //padding: EdgeInsets.all(5.0),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              skillsList
                                                                      .userEvaluation =
                                                                  index + 1;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: const EdgeInsets.only(left: 5.0),
                                                            alignment: Alignment.center,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              color: skillsList
                                                                              .requiredProfValues[
                                                                          index] ==
                                                                      skillsList
                                                                          .userEvaluation
                                                                  ? AppColors.getAppButtonBGColor()
                                                                  : Colors.transparent,
                                                              border: Border.all(
                                                                width: 1,
                                                                color: skillsList
                                                                                .requiredProfValues[
                                                                            index] ==
                                                                        skillsList
                                                                            .userEvaluation
                                                                    ? AppColors.getAppButtonBGColor()
                                                                    : Colors
                                                                        .grey, //                   <--- border width here
                                                              ),
                                                            ),
                                                            child: Container(
                                                                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                                                                child: Text(
                                                                  (skillsList.requiredProfValues[
                                                                          index])
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: skillsList.requiredProfValues[index] ==
                                                                              skillsList
                                                                                  .userEvaluation
                                                                          ? Color(int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))
                                                                          : Colors
                                                                              .grey),
                                                                )),
                                                          )),
                                                    ),
                                                );
                                              }),
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20.0,
                                          ),
                                          child: Container(
                                            width: useMobileLayout
                                                ? double.infinity
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Manager',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                              .withOpacity(
                                                                  0.5))),
                                                ),
                                                Text(
                                                    double.tryParse(skillsList
                                                                .managersEval)
                                                            ?.toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              ],
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: useMobileLayout
                                                ? double.infinity
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Content',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                              .withOpacity(
                                                                  0.5))),
                                                ),
                                                Text(
                                                    skillsList.contentEval
                                                            .isNotEmpty
                                                        ? skillsList.contentEval
                                                        : '0.0',
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              ],
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: useMobileLayout
                                                ? double.infinity
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Average',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                              .withOpacity(
                                                                  0.5))),
                                                ),
                                                Text(skillsList.weightedAverage,
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              ],
                                            ),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: useMobileLayout
                                                ? double.infinity
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CommonPrimarySecondaryButton(
                                                    onPressed: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        (GlobalSearchScreen(
                                                                          menuId:
                                                                              0,
                                                                          isAutomaticSearch:
                                                                              true,
                                                                          fValue:
                                                                              "${skillsList.jobRoleID}-${skillsList.skillID}",
                                                                          fType:
                                                                              'jobroles',
                                                                        ))));
                                                    },
                                                    isPrimary: false,
                                                    text: "View",
                                                    icon: Icons.remove_red_eye,

                                                  ),
                                                ),
                                                const SizedBox(width: 13,),
                                                Expanded(
                                                  child: CommonPrimarySecondaryButton(
                                                    onPressed: (){
                                                      saveUserEvaluation(
                                                          skillsList.jobRoleID,
                                                          widget
                                                              .prefCategoryList
                                                              .prefCategoryID);
                                                    },
                                                    isPrimary: true,
                                                    text: "Save",
                                                    icon: Icons.save,

                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              isExpanded: skillsList.isExpanded,
                            );
                          }).toList(),
                        )),
                  ),
                )
              ],
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
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 24)),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  void saveUserEvaluation(int jobRoleId, int prefCatId) {
    myCompetenciesBloc.add(UserSkillsEvaluationEvent(
        componentID: int.parse(widget.nativeMenuModel.componentId),
        componentInsID: int.parse(widget.nativeMenuModel.repositoryId),
        jobRoleID: jobRoleId,
        prefCategoryID: prefCatId,
        skillSetValue: prepareTheSkillSetValueString()));
  }

  String prepareTheSkillSetValueString() {
    String skillString = "";
    for (int i = 0;
        i < myCompetenciesBloc.userSkillListResponse.skillsList.length;
        i++) {
      skillString = skillString +
          "\$" +
          myCompetenciesBloc.userSkillListResponse.skillsList[i].skillID
              .toString() +
          "&" +
          myCompetenciesBloc.userSkillListResponse.skillsList[i].jobRoleID
              .toString() +
          "&" +
          myCompetenciesBloc.userSkillListResponse.skillsList[i].userEvaluation
              .toString() +
          "&" +
          myCompetenciesBloc
              .userSkillListResponse.skillsList[i].managersEvaluation +
          "&" +
          'Current';
    }
    return skillString;
  }

  void refresh() {
    myCompetenciesBloc.add(UserSkillsEvent(
        componentID: int.parse(widget.nativeMenuModel.componentId),
        componentInstanceID: int.parse(widget.nativeMenuModel.repositoryId),
        prefCatId: widget.prefCategoryList.prefCategoryID,
        jobRoleID: widget.jobId));
  }
}
