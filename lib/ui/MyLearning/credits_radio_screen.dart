import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';

import '../common/outline_button.dart';

class CreditsRadioScreen extends StatefulWidget {
  @override
  _CreditsRadioScreenState createState() => _CreditsRadioScreenState();
}

class _CreditsRadioScreenState extends State<CreditsRadioScreen> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  String radioItem = '';
  int id = 0;

  @override
  void initState() {
    super.initState();
    myLearningBloc.add(GetFilterDurationEvent());
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
              appBloc.localstr.filterLblCredits,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                )),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 350.0,
                      child: BlocConsumer<MyLearningBloc, MyLearningState>(
                        bloc: myLearningBloc,
                        listener: (context, state) {},
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
                              itemCount: myLearningBloc.filterByCreditList.length,
                              itemBuilder: (context, i) {
                                final theme = Theme.of(context)
                                    .copyWith(dividerColor: Colors.black26);

                                return Theme(
                                  data: theme,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: RadioListTile(
                                      activeColor: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                      title: Text(
                                          "${myLearningBloc.filterByCreditList[i].displayvalue}"),
                                      groupValue: id,
                                      value: i,
                                      onChanged: (val) {
                                        setState(() {
                                          radioItem = myLearningBloc
                                              .filterByCreditList[i].displayvalue;
                                          id = i;
                                          myLearningBloc.selectedCredits =
                                              "${myLearningBloc.filterByCreditList[i].minvalue},${myLearningBloc.filterByCreditList[i].maxvalue}";
                                        });
                                      },
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
