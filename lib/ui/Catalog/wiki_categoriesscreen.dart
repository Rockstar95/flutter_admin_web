import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/wikiupload_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/wikiupload_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/wiki_categoryresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/wikiupload_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/wikiuploadrepo/wikiupload_repositry_builder.dart';

import '../common/outline_button.dart';

class WikiCategoryScreen extends StatefulWidget {
  final List<WikiCategoryModel> wikiCategorieslistLocal;

  const WikiCategoryScreen({
    required this.wikiCategorieslistLocal,
  });

  @override
  State<WikiCategoryScreen> createState() => _WikiCategoryScreenState();
}

class _WikiCategoryScreenState extends State<WikiCategoryScreen> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late WikiUploadBloc wikiUploadBloc;

  @override
  void initState() {
    super.initState();

    print("isSelected Local ${widget.wikiCategorieslistLocal.length}");

    wikiUploadBloc = WikiUploadBloc(
        wikiUploadRepository: WikiUploadRepositoryBuilder.repository());
    wikiUploadBloc.isFirstLoading = true;
    getWikiCategories();
  }

  @override
  Widget build(BuildContext context) {
    List<WikiCategoryModel> tempList = [];

    return Container(
      color: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          appBar: AppBar(
            backgroundColor: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
            ),
            title: Text(
              'Wiki categories',
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            leading: InkWell(
                onTap: () => {
                      Navigator.pop(context, tempList),
                    },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                )),
          ),
          body: BlocConsumer<WikiUploadBloc, WikiUploadState>(
              bloc: wikiUploadBloc,
              listener: (context, state) {
                if (state is GetWikiCategoriesState &&
                    state.status == Status.LOADING &&
                    wikiUploadBloc.isFirstLoading == true) {
                  /*return Center(
                    child: AbsorbPointer(
                      child: SpinKitCircle(
                        color: Colors.grey,
                        size: 70.0,
                      ),
                    ),
                  );*/
                }
              },
              builder: (context, state) {
                if (state.status == Status.LOADING) {
                  return Center(
                    child: AbsorbPointer(
                      child: SpinKitCircle(
                        color: Colors.grey,
                        size: 70.0,
                      ),
                    ),
                  );
                }

                widget.wikiCategorieslistLocal.forEach((elementl) {
                  if (elementl.isSelected) {
                    wikiUploadBloc.wikiCategorieslist.forEach((element) {
                      if (elementl.categoryID == element.categoryID) {
                        element.isSelected = true;
                      }
                    });
                  }
                });
                return ListView.builder(
                  itemCount: wikiUploadBloc.wikiCategorieslist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                      ),
                      child: new Container(
                        padding: new EdgeInsets.all(1.0),
                        child: new Column(
                          children: <Widget>[
                            new CheckboxListTile(
                                activeColor: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                value: wikiUploadBloc
                                    .wikiCategorieslist[index].isSelected,
                                title: new Text(
                                  wikiUploadBloc.wikiCategorieslist[index].name,
                                  style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool? val) {
                                  itemChange(val ?? false, index);
                                })
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
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
                    List<WikiCategoryModel> tempWikilist = [];
                    Navigator.pop(context, tempWikilist);
                  },
                ),
              ),
              SizedBox(
                width: 5,
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
                    List<WikiCategoryModel> tempWikilist = [];
                    wikiUploadBloc.wikiCategorieslist.forEach((element) {
                      if (element.isSelected) {
                        print('print selected ids${element.name}');
                        tempWikilist.add(element);
                      }
                    });
                    Navigator.pop(context, tempWikilist);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      wikiUploadBloc.wikiCategorieslist[index].isSelected = val;
      widget.wikiCategorieslistLocal.forEach((elementl) {
        if (elementl.categoryID ==
            wikiUploadBloc.wikiCategorieslist[index].categoryID) {
          elementl.isSelected = val;
        }
      });
    });
  }

  void getWikiCategories() {
    wikiUploadBloc.add(GetWikiCategoriesEvent(
      intUserID: 1,
      intSiteID: 2,
      intComponentID: 2,
      locale: '2',
      strType: 'cat',
    ));
  }
}
