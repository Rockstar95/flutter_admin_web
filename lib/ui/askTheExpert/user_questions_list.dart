import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/askTheExpert/add_answer.dart';
import 'package:flutter_admin_web/ui/askTheExpert/add_questions.dart';
import 'package:flutter_admin_web/ui/askTheExpert/edit_questions.dart';
import 'package:flutter_admin_web/ui/askTheExpert/skill_category.dart';
import 'package:flutter_admin_web/ui/askTheExpert/view_answers.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

import '../global_search_screen.dart';

class UserQuestionsList extends StatefulWidget {
  final NativeMenuModel? nativeMenuModel;

  const UserQuestionsList({this.nativeMenuModel});

  @override
  State<UserQuestionsList> createState() => _UserQuestionsListState();
}

class _UserQuestionsListState extends State<UserQuestionsList> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<Tab> tabList = [];
  Map<String, String> filterMenus = {};
  late TabController _tabController;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late ProfileBloc profileBloc;
  late AskTheExpertBloc askTheExpertBloc;
  late FToast flutterToast;
  int pageQuestionNumber = 1;
  int pageNumber = 1;
  int totalPage = 10;
  ScrollController _scArchive = new ScrollController();
  var titleSelectCategory = 'Select Skill';
  List<SkillCateModel> skillCategoriesListLocal = [];
  String filterValue = 'CreatedDate Desc';

  List<String> arrFilter = [
    'Recently Added',
    'Most Answers',
    'Most Views',
    'Title A-Z',
    'Title Z-A'
  ];

  @override
  void initState() {
    super.initState();

    tabList.add(new Tab(
      text: 'All Questions',
    ));
    tabList.add(new Tab(
      text: "My Questions",
    ));
    _tabController = new TabController(length: tabList.length, vsync: this);

    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    askTheExpertBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: "Question & Answer"));

    refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
  }

  @override
  void didUpdateWidget(covariant UserQuestionsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    /*Future.delayed(Duration(seconds: 0)).then((value) {
      updateFilterValue();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      floatingActionButton: customFloatingAction(),
      key: _scaffoldkey,
      body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: tabWidget(context, itemWidth, itemHeight)),
    );
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 3231)),
    );

    print(result);

    if (result != null) {
      askTheExpertBloc.isQuestionSearch = true;
      askTheExpertBloc.searchQuestionString = result.toString();
      setState(() {
        pageQuestionNumber = 1;
      });
      refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
    }
  }

  Widget tabWidget(BuildContext context, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            ),
            child: new TabBar(
                controller: _tabController,
                indicatorColor: Color(int.parse("0xFF1D293F")),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                tabs: tabList),
          ),
          Expanded(
            child: Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              height: double.maxFinite,
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[_homeQuestionList(), myQuestionWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeQuestionList() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        MyPrint.printOnConsole("AskTheExpertBloc called with State:${state.runtimeType} status:${state.status}");
        if (state is UserQuestiondsListState) {
          if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");
            setState(() {
              //  isGetArchiveListEvent = true;
              pageQuestionNumber++;
            });
          } else if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && askTheExpertBloc.isQuestionFirstLoading == true) {
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
          return askTheExpertBloc.questionList.length == 0
              ? Column(
                  children: <Widget>[
                    getSearchTextField(),
                    Expanded(
                      child: noDataFound(true),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
                  },
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey.shade400,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: askTheExpertBloc.questionList.length + 2,
                    itemBuilder: (context, i) {
                      if (i == askTheExpertBloc.questionList.length + 1) {
                        if (state.status == Status.LOADING) {
//                        print("gone in _buildProgressIndicator");
                          return _buildProgressIndicator();
                        } else {
                          return Container();
                        }
                      }
                      else if (i == 0) {
                        return getSearchTextField();
                      }
                      else {
                        return Container(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                          child: allQuestionWidget(
                              askTheExpertBloc.questionList[i - 1],
                              true,
                              context,
                              i),
                        );
                      }
                    },
                    controller: _scArchive,
                  ),
                );
        }
      },
    );
  }

  Widget getSearchTextField() {
    var _controller;
    if (askTheExpertBloc.isQuestionSearch) {
      _controller = TextEditingController(text: askTheExpertBloc.searchQuestionString);
    }
    else {
      _controller = TextEditingController();
    }

    Widget? suffixIcon;
    if(askTheExpertBloc.isQuestionSearch) {
      suffixIcon = IconButton(
        onPressed: () {
          askTheExpertBloc.isQuestionFirstLoading = true;
          askTheExpertBloc.isQuestionSearch = false;
          askTheExpertBloc.searchQuestionString = "";
          setState(() {
            pageQuestionNumber = 1;
          });
          refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
        },
        color: AppColors.getAppTextColor(),
        icon: Icon(
          Icons.close,
        ),
      );
    }
    else {
      if(askTheExpertBloc.isFilterMenu) {
        suffixIcon = IconButton(
          onPressed: () => moveSkillCategory(),
          color: AppColors.getFilterIconColor(),
          icon: Icon(
            Icons.tune,
          ),
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: InsSearchTextField(
                onTapAction: () {
                  if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                    _navigateToGlobalSearchScreen(context);
                  }
                },
                controller: _controller,
                appBloc: appBloc,
                suffixIcon: Container(
                  //color: Colors.red,
                  child: Row(
                    children: [
                      suffixIcon ?? SizedBox(),
                    ],
                  ),
                ),
                onSubmitAction: (value) {
                  if (value.toString().length > 0) {
                    askTheExpertBloc.isQuestionFirstLoading = true;
                    askTheExpertBloc.isQuestionSearch = true;
                    askTheExpertBloc.searchQuestionString = value.toString();
                    setState(() {
                      pageQuestionNumber = 1;
                    });
                    refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                  }
                },
              ),
            ),
            SizedBox(width: 15,),
            getSortButton(),
          ],
        ),
    );
  }

  Widget allQuestionWidget(
      QuestionList questionList, bool isQuestion, BuildContext context,
      [int i = 0]) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: new Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
        child: new Column(
          children: [
            new Row(
              children: [
                (questionList.userQuestionImagePath != "" &&
                        questionList.userQuestionImagePath.length > 0)
                    ? Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: questionList.userQuestionImagePath.isNotEmpty
                                ? NetworkImage(questionList
                                        .userQuestionImagePath
                                        .startsWith("http")
                                    ? questionList.userQuestionImagePath
                                        .replaceAll(" ", "%20")
                                    : '${ApiEndpoints.strSiteUrl + questionList.userQuestionImagePath..replaceAll(" ", "%20")}')
                                : AssetImage(
                                    'assets/user.gif',
                                  ) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(50.0)),
                        ),
                      )
                    : Container(),
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 10.0),
                        child: new Text(questionList.userQuestion,
                            style: Theme.of(context).textTheme.caption?.apply(
                                color: InsColor(appBloc).appTextColor))),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: new Text(
                            DateTime.now()
                                        .difference(askTheExpertBloc.formatter
                                            .parse(questionList.postedDate))
                                        .inDays ==
                                    0
                                ? 'Just now'
                                : DateTime.now()
                                        .difference(askTheExpertBloc.formatter
                                            .parse(questionList.postedDate))
                                        .inDays
                                        .toString() +
                                    ' Days',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.apply(color: InsColor(appBloc).appTextColor)))
                  ],
                )),
                new IconButton(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  icon: Icon(Icons.more_vert,
                      color: InsColor(appBloc).appIconColor),
                  onPressed: () {
                    _settingModalBottomSheet(context, i - 1);
                  },
                ),
              ],
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                  child: Html(
                      data: "" + questionList.userQuestionDescription + "",
                      style: {
                        "body": Style(
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5),
                          fontFamily: 'Roboto',
                          fontSize: FontSize(ScreenUtil().setSp(14)),
                        ),
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: questionCategories(questionList.questionCategories.split(',')),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20.0),
                    child: new Text(
                      'Asked by: ' +
                          questionList.userName +
                          ' | Asked on: ' +
                          questionList.postedDate +
                          ' | Last Active: ' +
                          questionList.postedDate,
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: new Container(
                            alignment: Alignment.center,
                            width: 70.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                                color: Color(int.parse("0xFFECF1F5")),
                                border: Border.all(
                                  color: InsColor(appBloc)
                                      .appTextColor
                                      .withAlpha(0),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAnswers(questionList)))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                                      }
                                    });
                                  },
                                  padding: new EdgeInsets.only(bottom: 1.0),
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  icon: Icon(
                                    Icons.question_answer,
                                    size: 16.0,
                                    color: Color(int.parse("0xFF1D293F")),
                                  ),
                                ),
                                Text(
                                  questionList.answers,
                                  style: TextStyle(
                                    color: Color(int.parse("0xFF1D293F")),
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: new Container(
                            width: 70.0,
                            height: 25.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(int.parse("0xFFECF1F5")),
                                border: Border.all(
                                  color: InsColor(appBloc)
                                      .appTextColor
                                      .withAlpha(0),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: new Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  padding: new EdgeInsets.only(bottom: 1.0),
                                  color: Color(int.parse("0xFF1D293F")),
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    size: 16.0,
                                  ),
                                ),
                                Text(
                                  questionList.views.toString(),
                                  style: TextStyle(
                                      color: Color(int.parse("0xFF1D293F")),
                                      fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget myQuestionWidget() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && askTheExpertBloc.isQuestionFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.black54,
                size: 70.0,
              ),
            ),
          );
        }
        else if (askTheExpertBloc.myQuestionList.length == 0) {
          return noDataFound(true);
        }
        else {
          return RefreshIndicator(
            onRefresh: () async {
              refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
            },
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            child: new Container(
              padding: EdgeInsets.all(10.0),
              child: new ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: askTheExpertBloc.myQuestionList.length,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                  itemBuilder: (context, index) {
                    return new GestureDetector(
                      onTap: () => {
                        // openDiscussionTopic(index),
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        child: new Column(
                          children: [
                            new Row(
                              children: [
                                (askTheExpertBloc.myQuestionList[index]
                                                .userQuestionImagePath !=
                                            "" &&
                                        askTheExpertBloc.myQuestionList[index]
                                                .userQuestionImagePath.length >
                                            0)
                                    ? Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: new DecorationImage(
                                            image: askTheExpertBloc
                                                        .myQuestionList[index]
                                                        .userQuestionImagePath !=
                                                    ""
                                                ? NetworkImage(askTheExpertBloc
                                                        .myQuestionList[index]
                                                        .userQuestionImagePath
                                                        .startsWith("http")
                                                    ? askTheExpertBloc
                                                        .myQuestionList[index]
                                                        .userQuestionImagePath
                                                        .replaceAll(" ", "%20")
                                                    : '${ApiEndpoints.strSiteUrl + askTheExpertBloc.myQuestionList[index].userQuestionImagePath.replaceAll(" ", "%20")}')
                                                : AssetImage(
                                                    'assets/user.gif',
                                                  ) as ImageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                        ),
                                      )
                                    : Container(),
                                new Expanded(
                                    child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 10.0),
                                        child: new Text(
                                            askTheExpertBloc
                                                .myQuestionList[index]
                                                .userQuestion,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.apply(
                                                    color: InsColor(appBloc)
                                                        .appTextColor))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: new Text(
                                            DateTime.now()
                                                        .difference(askTheExpertBloc
                                                            .formatter
                                                            .parse(askTheExpertBloc
                                                                .myQuestionList[
                                                                    index]
                                                                .postedDate))
                                                        .inDays ==
                                                    0
                                                ? 'Just now'
                                                : DateTime.now()
                                                        .difference(askTheExpertBloc
                                                            .formatter
                                                            .parse(askTheExpertBloc
                                                                .myQuestionList[index]
                                                                .postedDate))
                                                        .inDays
                                                        .toString() +
                                                    ' Days',
                                            style: Theme.of(context).textTheme.subtitle2?.apply(color: InsColor(appBloc).appTextColor)))
                                  ],
                                )),
                                new IconButton(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  icon: Icon(Icons.more_vert,
                                      color: InsColor(appBloc).appIconColor),
                                  onPressed: () {
                                    _settingModalBottomSheet(context, index);
                                  },
                                ),
                              ],
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10.0, right: 10.0),
                                  child: Html(
                                      data: "" +
                                          askTheExpertBloc.myQuestionList[index]
                                              .userQuestionDescription +
                                          "",
                                      style: {
                                        "body": Style(
                                          color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              FontSize(ScreenUtil().setSp(14)),
                                        ),
                                      }),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: questionCategories(askTheExpertBloc
                                      .myQuestionList[index].questionCategories
                                      .split(',')),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, left: 20.0),
                                    child: new Text(
                                      'Asked by: ' +
                                          askTheExpertBloc
                                              .myQuestionList[index].userName +
                                          ' | Asked on: ' +
                                          askTheExpertBloc.myQuestionList[index]
                                              .postedDate +
                                          ' | Last Active: ' +
                                          askTheExpertBloc
                                              .myQuestionList[index].postedDate,
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        new Padding(
                                          padding: EdgeInsets.only(right: 0.0),
                                          child: new Container(
                                            alignment: Alignment.center,
                                            width: 70.0,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                                color: Color(
                                                    int.parse("0xFFECF1F5")),
                                                border: Border.all(
                                                  color: InsColor(appBloc)
                                                      .appTextColor
                                                      .withAlpha(0),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewAnswers(
                                                                    askTheExpertBloc
                                                                            .myQuestionList[
                                                                        index])))
                                                        .then((value) {
                                                      if (value ?? true) {
                                                        refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                                                      }
                                                    });
                                                  },
                                                  padding: new EdgeInsets.only(
                                                      bottom: 1.0),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                  icon: Icon(
                                                    Icons.question_answer,
                                                    size: 16.0,
                                                    color: Color(int.parse(
                                                        "0xFF1D293F")),
                                                  ),
                                                ),
                                                Text(
                                                  askTheExpertBloc
                                                      .myQuestionList[index]
                                                      .answers,
                                                  style: TextStyle(
                                                    color: Color(int.parse(
                                                        "0xFF1D293F")),
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: new Container(
                                            width: 70.0,
                                            height: 25.0,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Color(
                                                    int.parse("0xFFECF1F5")),
                                                border: Border.all(
                                                  color: InsColor(appBloc)
                                                      .appTextColor
                                                      .withAlpha(0),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: new Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  padding: new EdgeInsets.only(
                                                      bottom: 1.0),
                                                  color: Color(
                                                      int.parse("0xFF1D293F")),
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  askTheExpertBloc
                                                      .myQuestionList[index]
                                                      .views
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF1D293F")),
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        }
      },
    );
  }

  Widget getSortButton() {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.getAppBGColor(),
        ),
        child: PopupMenuButton(
          color: AppColors.getAppBGColor(),
          child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.filter_list,
                color: AppColors.getFilterIconColor(),
              ),
          ),
          elevation: 3.2,
          onSelected: (String value) {
            appBloc.filterValue = value;
            updateFilterValue();
          },
          itemBuilder: (BuildContext context) {
            return arrFilter.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(color: AppColors.getAppTextColor()),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget customFloatingAction() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
        bloc: askTheExpertBloc,
        listener: (context, state) {
          if (state.status == Status.COMPLETED) {
            // askTheExpertBloc.isAddAnswer =
            //     privilegeAddAnswerIdExists();
          }
        },
        builder: (context, state) {
          return new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.add,
              ),
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              onPressed: () {
                Navigator.of(context)
                    .push(
                        MaterialPageRoute(builder: (context) => AddQuestion()))
                    .then((value) {
                  if (value ?? true) {
                    refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                  }
                });
              });
        });
  }

  Widget noDataFound(bool val) {
    return val
        ? RefreshIndicator(
            onRefresh: () async {
              refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
            },
            color: AppColors.getAppButtonBGColor(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          appBloc.localstr.commoncomponentLabelNodatalabel,
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                ],
              ),
            ),
          )
        : new Container();
  }

  Widget questionCategories(List<String> questionCategories) {
    var _crossAxisSpacing = 8;

    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 3;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 50;
    var _aspectRatio = _width / cellHeight;

    return Wrap(
      children: List.generate(questionCategories.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Visibility(
            visible: questionCategories[index].trim().isEmpty ? false : true,
            child: Container(
              //height: 10.0,
              decoration: BoxDecoration(
                  color: Color(int.parse("0xFFECF1F5")),
                  border: Border.all(
                    color: InsColor(appBloc).appTextColor.withAlpha(0),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(questionCategories[index],
                  style: TextStyle(
                    color: Color(int.parse("0xFF1D293F")),
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        );
      }),
    );

    /*int length = questionCategories.length ~/ 3;

    return Column(
      children: List.generate(length, (index) {
        int startRange = index * 3;
        int endRange = ((index + 1) * 3) < questionCategories.length ? ((index + 1) * 3) : questionCategories.length;
        List<String> row = questionCategories.sublist(startRange, endRange);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(mainAxisSize: MainAxisSize.max,
            children: List.generate(3, (index) {
              if(index < row.length) {
                String category = row[index];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Visibility(
                      visible: category.trim().isEmpty ? false : true,
                      child: new Container(
                        //height: 10.0,
                        decoration: BoxDecoration(
                            color: Color(int.parse("0xFFECF1F5")),
                            border: Border.all(
                              color: InsColor(appBloc).appTextColor.withAlpha(0),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Color(int.parse("0xFF1D293F")),
                              fontSize: 11.0,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              else {
                return Expanded(child: SizedBox());
              }
            }),
          ),
        );
      }),
    );*/

    /*return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 6,
            crossAxisCount: _crossAxisCount,
            childAspectRatio: _aspectRatio,
        ),
        itemCount: questionCategories == null ? 0 : questionCategories.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Visibility(
                visible: questionCategories[index].trim().isEmpty ? false : true,
                child: new Container(
                    //height: 10.0,
                    decoration: BoxDecoration(
                        color: Color(int.parse("0xFFECF1F5")),
                        border: Border.all(
                          color: InsColor(appBloc).appTextColor.withAlpha(0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                      child: Text(
                        questionCategories[index],
                        style: TextStyle(
                            color: Color(int.parse("0xFF1D293F")),
                            fontSize: 11.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                ),
              ),
          );
        },
    );*/
  }

  Map<String, String> getConditionsValue(String strConditions) {
    Map<String, String> filterMenus = {};

    if (strConditions != null && strConditions != "") {
      if (strConditions.contains("#@#")) {
        var conditionsArray = strConditions.split("#@#");
        int conditionCount = conditionsArray.length;
        if (conditionCount > 0) {
          filterMenus = generateHashMap(conditionsArray);
        }
      }
    }

    return filterMenus;
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = new Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  void refresh(String value, int skillID, String filterValue) {
    askTheExpertBloc.add(GetUserQuestionsListEvent(
        componentInsID: 3510,
        componentID: 161,
        sortBy: filterValue,
        intSkillID: skillID,
        pageIndex: 1,
        pageSize: 20,
        searchText: value));
  }

  void updateFilterValue() {
    if (appBloc.filterValue == 'Recently Added') {
      refresh(askTheExpertBloc.searchQuestionString, -1, 'LastActiveDate Desc');
    }
    else if (appBloc.filterValue == 'Most Answers') {
      refresh(askTheExpertBloc.searchQuestionString, -1, 'Answers Desc');
    }
    else if (appBloc.filterValue == 'Most Views') {
      refresh(askTheExpertBloc.searchQuestionString, -1, 'Views Desc');
    }
    else if (appBloc.filterValue == 'Title A-Z') {
      refresh(askTheExpertBloc.searchQuestionString, -1, 'UserQuestion asc');
    }
    else if (appBloc.filterValue == 'Title Z-A') {
      refresh(askTheExpertBloc.searchQuestionString, -1, 'UserQuestion Desc');
    }
  }

  void _settingModalBottomSheet(context, index) {
    showModalBottomSheet(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
              bloc: askTheExpertBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {
                  // askTheExpertBloc.isAddAnswer =
                  //     privilegeAddAnswerIdExists();
                }
              },
              builder: (context, state) {
                return Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: new Wrap(
                    children: <Widget>[
                      Visibility(
                          visible: askTheExpertBloc.strUserID ==
                                  askTheExpertBloc.questionList[index].userID
                                      .toString()
                              ? true
                              : false,
                          child: new ListTile(
                              tileColor: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                              leading: new Icon(
                                Icons.edit,
                                color: InsColor(appBloc).appIconColor,
                              ),
                              title: new Text(
                                'Edit',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditQuestion(
                                                questionList: askTheExpertBloc
                                                    .questionList[index])))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                                      }
                                    })
                                  })),
                      Visibility(
                          visible: askTheExpertBloc.strUserID ==
                                  askTheExpertBloc.questionList[index].userID
                                      .toString()
                              ? true
                              : false,
                          child: new ListTile(
                              leading: new Icon(
                                Icons.delete,
                                color: InsColor(appBloc).appIconColor,
                              ),
                              title: new Text(
                                'Delete',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () => {
                                    // Navigator.of(context).pop(true),
                                    showAlertDialog(context, index)
                                  })),
                      Visibility(
                          visible: askTheExpertBloc
                                  .questionList[index].answerBtnWithLink.isEmpty
                              ? false
                              : true,
                          child: new ListTile(
                              leading: new Icon(
                                Icons.add_circle,
                                color: InsColor(appBloc).appIconColor,
                              ),
                              title: new Text(
                                'Answer',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AddAnswer(
                                                questionList: askTheExpertBloc
                                                    .questionList[index],
                                                isEdit: false)))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
                                      }
                                    })
                                  })),
                      new ListTile(
                        leading: new Icon(
                          IconDataSolid(
                            int.parse('0xf079'),
                          ),
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                        title: new Text(
                          'Share with People',
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareMainScreen(
                                  true,
                                  false,
                                  true,
                                  askTheExpertBloc
                                      .questionList[index].questionID
                                      .toString(),
                                  askTheExpertBloc
                                      .questionList[index].userQuestion)))
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          IconDataSolid(int.parse('0xf1e0')),
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                        title: new Text(
                          'Share with Connection',
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareWithConnections(
                                  false,
                                  true,
                                  askTheExpertBloc
                                      .questionList[index].userQuestion,
                                  askTheExpertBloc
                                      .questionList[index].questionID
                                      .toString())));
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _settingMyQuestBottomSheet(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
              bloc: askTheExpertBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {}
              },
              builder: (context, state) {
                return Container(
                  child: new Wrap(
                    children: <Widget>[
                      Visibility(
                          visible: askTheExpertBloc.strUserID ==
                                  askTheExpertBloc.myQuestionList[index].userID
                                      .toString()
                              ? true
                              : false,
                          child: new ListTile(
                              leading: new Icon(Icons.edit),
                              title: new Text('Edit'),
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditQuestion(
                                                questionList: askTheExpertBloc
                                                    .myQuestionList[index])))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(askTheExpertBloc.searchQuestionString, -1, appBloc.filterValue);
                                      }
                                    })
                                  })),
                      Visibility(
                          visible: askTheExpertBloc.strUserID ==
                                  askTheExpertBloc.myQuestionList[index].userID
                                      .toString()
                              ? true
                              : false,
                          child: new ListTile(
                              leading: new Icon(Icons.delete),
                              title: new Text('Delete'),
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    showAlertDialog(context, index)
                                  })),
                      Visibility(
                          visible: askTheExpertBloc.myQuestionList[index]
                                  .answerBtnWithLink.isEmpty
                              ? false
                              : true,
                          child: new ListTile(
                              leading: new Icon(Icons.add_circle),
                              title: new Text('Answer'),
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AddAnswer(
                                                questionList: askTheExpertBloc
                                                    .myQuestionList[index])))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
                                      }
                                    })
                                  })),
                      new ListTile(
                        leading: new Icon(
                          IconDataSolid(
                            int.parse('0xf079'),
                          ),
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                        title: new Text('Share with People',
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ))),
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareMainScreen(
                                  true,
                                  false,
                                  true,
                                  askTheExpertBloc
                                      .myQuestionList[index].questionID
                                      .toString(),
                                  askTheExpertBloc
                                      .myQuestionList[index].userQuestion)))
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          IconDataSolid(int.parse('0xf1e0')),
                          color: Colors.grey,
                        ),
                        title: new Text('Share with Connection'),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareWithConnections(
                                  false,
                                  true,
                                  askTheExpertBloc
                                      .myQuestionList[index].userQuestion,
                                  askTheExpertBloc
                                      .myQuestionList[index].questionID
                                      .toString())));
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }

  showAlertDialog(BuildContext context, int index) {
    // Create button
    Widget deleteButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(true);
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        //Navigator.of(context).pop(true);
        askTheExpertBloc.add(DeleteQuestionEvent(
          questionID: askTheExpertBloc.questionList[index].questionID,
          userUploadImage:
              askTheExpertBloc.questionList[index].userQuestionImage,
        ));
        askTheExpertBloc.questionList.removeAt(index);
        Navigator.of(_scaffoldkey.currentContext!).pop(true);
        Navigator.of(_scaffoldkey.currentContext!).pop(true);
        refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: InsColor(appBloc).appBGColor,
      title: Text(
        "Confirm",
        style: Theme.of(context)
            .textTheme
            .headline2
            ?.apply(color: InsColor(appBloc).appTextColor),
      ),
      content: Text(
        "Are you sure you want to delete this Question?",
        style: Theme.of(context)
            .textTheme
            .headline2
            ?.apply(color: InsColor(appBloc).appTextColor),
      ),
      actions: [deleteButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void moveSkillCategory() async {
    skillCategoriesListLocal = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SkillCategory(skillCateModel: skillCategoriesListLocal)));
    if (skillCategoriesListLocal.length == 0) {
      refresh(askTheExpertBloc.searchQuestionString, -1, filterValue);
    } else {
      refresh(askTheExpertBloc.searchQuestionString, int.parse(updateSelectedCatId()), appBloc.filterValue);
    }
  }

  String formatString(List x) {
    if (x.length == 0) {
      return 'Select Skill';
    }
    String formatted = '';
    for (var i in x) {
      formatted += '$i,';
    }
    return formatted.replaceRange(formatted.length - 1, formatted.length, '');
  }

  String updateSelectedCatId() {
    List<String> selectedCategoryID = [];

    skillCategoriesListLocal.length > 0
        ? skillCategoriesListLocal.forEach((element) {
            selectedCategoryID.add('${element.skillID}');
          })
        : selectedCategoryID.clear();
    print('selectedCategoryID ${formatString(selectedCategoryID)}');

    return formatString(selectedCategoryID);
  }

/*bool privilegeAddAnswerIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 980) {
        return true;
      }
    }
    return false;
  }*/
}
