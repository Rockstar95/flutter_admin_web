import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/bloc/my_competencies_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/event/my_competencies_event.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/state/my_competencies_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/fade_animation.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../../configs/constants.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';

class AddJobRole extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;
  final List<ParentJobRolesList> parentJobRole;

  AddJobRole({
    required this.parentJobRole,
    required this.nativeMenuModel,
  });

  @override
  _AddJobRoleState createState() => _AddJobRoleState();
}

class _AddJobRoleState extends State<AddJobRole>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyCompetenciesBloc myCompetenciesBloc;

  @override
  void initState() {
    super.initState();

    myCompetenciesBloc = MyCompetenciesBloc(
        myCompetenciesRepository: MyCompetenciesRepositoryBuilder.repository());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    //final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Add Job Role',
          style: TextStyle(
              fontSize: 18,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(true),
          child: Icon(Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
      ),
      body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: Column(
            children: [
              const Divider(
                height: 2,
                color: Colors.black87,
              ),
              Container(
                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: buildMainDropdown(widget.parentJobRole),
              ),
              addJobRoleWidget(widget.parentJobRole)
            ],
          )),
    );
  }

  Widget buildMainDropdown(List<ParentJobRolesList> items) {
    //MyPrint.printOnConsole("myCompetenciesBloc.type:${myCompetenciesBloc.type}");
    //MyPrint.printOnConsole("Job Roles:${items.map((e) => e.jobRoleName).toList()}");
    /*if(items.length < 2) {
      return SizedBox();
    }*/

    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              value: myCompetenciesBloc.type.isEmpty ? null : myCompetenciesBloc.type,
              iconEnabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              hint: Text(
                "Select industry",
                style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
              items: items.map((json) {
                //MyPrint.printOnConsole("Dropdown Value:${json.jobRoleName}");
                return DropdownMenuItem(
                  child: Text(
                    json.jobRoleName,
                    style: TextStyle(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                  value: json.jobRoleName,
                );
              }).toList(),
              onChanged: (newType) {
                setState(() {
                  myCompetenciesBloc.type = newType ?? "";
                });
              },
            ),
          )),
    );
  }

  Widget addJobRoleWidget(List<ParentJobRolesList> parentJobRole) {
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
        if (state.status == Status.LOADING &&
            myCompetenciesBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70),
            ),
          );
        } else if (parentJobRole.isEmpty) {
          return noDataFound(true);
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: parentJobRole.length,
              itemBuilder: (context, index) {
                ParentJobRolesList parentJobRolesList = parentJobRole[index];

                return Container(
                  child: FadeAnimation(
                      0.5,
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                        decoration: BoxDecoration(
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")).withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                parentJobRolesList.jobRoleName,
                                style: TextStyle(
                                  fontSize: 15.h,
                                  fontWeight: FontWeight.w600,
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                              ),
                            ),
                            IconButton(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                icon: Icon(
                                  Icons.more_vert,
                                  color: InsColor(appBloc).appIconColor,
                                ),
                                onPressed: () {
                                  _settingModalBottomSheet(context, parentJobRolesList);
                                })
                          ],
                        ),
                      ),
                  ),
                );
              });
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

  void _settingModalBottomSheet(context, ParentJobRolesList parentJobRole) {
    showModalBottomSheet(
        shape: AppConstants().bottomSheetShapeBorder(),
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<MyCompetenciesBloc, MyCompetenciesState>(
              bloc: myCompetenciesBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                }
              },
              builder: (context, state) {
                return AppConstants().bottomSheetContainer(
                  child: Wrap(
                    children: <Widget>[
                      const BottomSheetDragger(),
                      BottomsheetOptionTile(
                          iconData:Icons.add_circle,
                          text:'Add to my Job Role - Skill',
                        onTap: () => {
                          myCompetenciesBloc.add(AddJobRoleEvent(
                              jobRoleId: parentJobRole.jobRoleId,
                              tagName: 'current'))
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
