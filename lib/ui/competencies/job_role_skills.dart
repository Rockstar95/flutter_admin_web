import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/bloc/my_competencies_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/event/my_competencies_event.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_skills_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/state/my_competencies_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/fade_animation.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/competencies/add_job_role.dart';
import 'package:flutter_admin_web/ui/competencies/pref_cat_list.dart';

class JobRoleSkills extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;

  const JobRoleSkills({required this.nativeMenuModel});

  @override
  _JobRoleSkillsState createState() => _JobRoleSkillsState();
}

class _JobRoleSkillsState extends State<JobRoleSkills> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyCompetenciesBloc myCompetenciesBloc;

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
      floatingActionButton: customFloatingAction(),
      key: _scaffoldkey,
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      body: jobRoleSkillWidget(context, itemWidth, itemHeight),
    );
  }

  Widget jobRoleSkillWidget(BuildContext context, double itemWidth, double itemHeight) {
    return BlocConsumer<MyCompetenciesBloc, MyCompetenciesState>(
      bloc: myCompetenciesBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == '401') {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && myCompetenciesBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
              ),
            ),
          );
        }
        else if (myCompetenciesBloc.jobRoleSkillsResponse.competencyList.length == 0) {
          return noDataFound(true);
        }
        else {
          return ListView.builder(
            itemCount: myCompetenciesBloc.jobRoleSkillsResponse.competencyList.length,
            itemBuilder: (context, index) {
              CompetencyList competencyList = myCompetenciesBloc.jobRoleSkillsResponse.competencyList[index];

              return GestureDetector(
                onTap: () => {
                  openPrefCatList(
                    competencyList,
                    widget.nativeMenuModel,
                  )
                },
                child: Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: FadeAnimation(
                      0.5,
                      Container(
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
                            new Text(
                              competencyList.jobRoleName,
                              style: new TextStyle(
                                fontSize: 15.h,
                                fontWeight: FontWeight.w400,
                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: InsColor(appBloc).appIconColor,
                            )
                          ],
                        ),
                      ),
                  ),
                ),
              );
            },
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
        : new Container();
  }

  void openPrefCatList(CompetencyList competencyList, NativeMenuModel nativeMenuModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrefCatList(
                  competencyList: competencyList,
                  nativeMenuModel: nativeMenuModel,
                )));
  }

  Widget customFloatingAction() {
    return BlocConsumer<MyCompetenciesBloc, MyCompetenciesState>(
        bloc: myCompetenciesBloc,
        listener: (context, state) {
          if (state.status == Status.LOADING &&
              myCompetenciesBloc.jobRoleResponse.parentJobRolesList.length ==
                  0) {
            /*return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.0,
                ),
              ),
            );*/
          }
          if (state.status == Status.COMPLETED) {}
        },
        builder: (context, state) {
          return myCompetenciesBloc.jobRoleResponse != null
              ? Visibility(
                  visible:
                      myCompetenciesBloc.jobRoleResponse.parentJobRolesList !=
                              null
                          ? true
                          : false,
                  child: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddJobRole(
                                      parentJobRole: myCompetenciesBloc
                                          .jobRoleResponse.parentJobRolesList,
                                      nativeMenuModel: widget.nativeMenuModel,
                                    ))).then((value) => {
                              if (value) {refresh()}
                            });
                      }),
                )
              : Container();
        });
  }

  void refresh() {
    myCompetenciesBloc.add(JobRoleSkillsEvent(
        componentID: int.parse(widget.nativeMenuModel.componentId),
        componentInstanceID: int.parse(widget.nativeMenuModel.repositoryId),
        jobRoleID: 0));

    myCompetenciesBloc.add(GetJobRoleEvent(
        componentID: int.parse(widget.nativeMenuModel.componentId),
        componentInsID: int.parse(widget.nativeMenuModel.repositoryId),
        isParent: true));
  }
}
