import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/credits_radio_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/event_dates_filterby.dart';
import 'package:flutter_admin_web/ui/MyLearning/filter_by_selected_category.dart';
import 'package:flutter_admin_web/ui/MyLearning/filterby_instructer_list.dart';
import 'package:flutter_admin_web/ui/MyLearning/filterby_pricerange.dart';
import 'package:flutter_admin_web/ui/MyLearning/rating_filterby.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

import '../common/outline_button.dart';
import 'FilterBySelectedLearningprovider.dart';

class ContentFilterByScreen extends StatefulWidget {
  final Function refresh;
  final String componentId ;

  const ContentFilterByScreen({
    required this.refresh,
    required this.componentId,
  });

  @override
  State<ContentFilterByScreen> createState() => _ContentFilterByScreenState();
}

class _ContentFilterByScreenState extends State<ContentFilterByScreen> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    super.initState();
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
              'Filter By',
              style: TextStyle(
                fontSize: 18,
                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: InkWell(
              onTap: () {
                widget.refresh();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 350.0,
                      child: BlocConsumer(
                        bloc: myLearningBloc,
                        listener: (context, state) {},
                        builder: (context, state) {
                          return ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myLearningBloc.contentFilterByModelList.length,
                            itemBuilder: (context, i) {
                              final theme = Theme.of(context).copyWith(dividerColor: Colors.black26);

                              return Theme(
                                data: theme,
                                child: GestureDetector(
                                  onTap: () {
                                    MyPrint.printOnConsole("Category Id:${myLearningBloc.contentFilterByModelList[i].categoryID}");
                                    /*Navigator.of(context).push(MaterialPageRoute(builder: (context) =>FilterBySelectedLearningprovider(
                                      myLearningBloc.contentFilterByModelList[i].categoryID,
                                      myLearningBloc.contentFilterByModelList[i].categoryDisplayName,
                                    )));
                                    return;*/

                                    if (myLearningBloc.contentFilterByModelList[i].categoryID == "creditpoints") {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreditsRadioScreen()));
                                    }
                                    else if (myLearningBloc.contentFilterByModelList[i].categoryID == "inst") {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              FilterByInstructerList(
                                                myLearningBloc.contentFilterByModelList[i].categoryID,
                                                myLearningBloc.contentFilterByModelList[i].categoryDisplayName,
                                              ),
                                      ));
                                    }
                                    else if (myLearningBloc.contentFilterByModelList[i].categoryID == "rate") {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => RatingFilterBy(myLearningBloc.contentFilterByModelList[i].categoryDisplayName),
                                          ));
                                    }
                                    else if (myLearningBloc.contentFilterByModelList[i].categoryID == "eventdates") {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EventDateFilterBy(myLearningBloc.contentFilterByModelList[i].categoryDisplayName),
                                          ));
                                    }
                                    else if (myLearningBloc.contentFilterByModelList[i].categoryID == "price Range") {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => FilterByPriceRange(myLearningBloc.contentFilterByModelList[i].categoryDisplayName,),
                                      ));
                                    }
                                    else if (myLearningBloc.contentFilterByModelList[i].categoryID == "learningprovider") {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              FilterBySelectedLearningprovider(
                                                myLearningBloc.contentFilterByModelList[i].categoryID,
                                                myLearningBloc.contentFilterByModelList[i].categoryDisplayName,
                                              ),
                                      ));
                                    }
                                    else {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              FilterBySelectedCategory(
                                                myLearningBloc.contentFilterByModelList[i].categoryID,
                                                myLearningBloc.contentFilterByModelList[i].categoryDisplayName,
                                                widget.componentId,
                                              ),
                                      ));
                                    }
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
                                        new Text(
                                          myLearningBloc.contentFilterByModelList[i].categoryDisplayName,
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
                              );
                            },
                          );
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
                      widget.refresh();
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
                      widget.refresh();
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
