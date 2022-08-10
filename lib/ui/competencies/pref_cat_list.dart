import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/bloc/my_competencies_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/event/my_competencies_event.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_skills_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/pref_category_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/state/my_competencies_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/fade_animation.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/competencies/user_skill.dart';

class PrefCatList extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;
  final CompetencyList competencyList;

  const PrefCatList({
    required this.competencyList,
    required this.nativeMenuModel,
  });

  @override
  _PrefCatListState createState() => _PrefCatListState();
}

class _PrefCatListState extends State<PrefCatList> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyCompetenciesBloc myCompetenciesBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myCompetenciesBloc = MyCompetenciesBloc(
        myCompetenciesRepository: MyCompetenciesRepositoryBuilder.repository());
    myCompetenciesBloc.add(PrefCatListEvent(
        componentID: int.parse(widget.nativeMenuModel.componentId),
        componentInstanceID: int.parse(widget.nativeMenuModel.repositoryId),
        jobRoleID: widget.competencyList.jobRoleId));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.competencyList.jobRoleName,
          style: TextStyle(
            fontSize: 20,
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
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
            children: [
              Divider(
                height: 2,
                color: Colors.black87,
              ),
              prefCatWidget(context, itemWidth, itemHeight)
            ],
          )),
    );
  }

  Widget prefCatWidget(BuildContext context, double itemWidth, double itemHeight) {
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
        else if (myCompetenciesBloc.prefCategoryListResponse.prefCategoryList.length == 0) {
          return noDataFound(true);
        }
        else {
          return ListView.builder(
            itemCount: myCompetenciesBloc.prefCategoryListResponse.prefCategoryList.length,
            itemBuilder: (context, index) {
              PrefCategoryList prefCategoryList = myCompetenciesBloc.prefCategoryListResponse.prefCategoryList[index];

              return GestureDetector(
                onTap: () => {
                  openUserSkill(
                      widget.competencyList.jobRoleId,
                      prefCategoryList,
                      widget.nativeMenuModel)
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
                              prefCategoryList.prefCategoryTitle,
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

  void openUserSkill(int jobID, PrefCategoryList prefCatList, NativeMenuModel nativeMenuModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserSkill(
                  jobId: jobID,
                  prefCategoryList: prefCatList,
                  nativeMenuModel: nativeMenuModel,
                )));
  }
}
