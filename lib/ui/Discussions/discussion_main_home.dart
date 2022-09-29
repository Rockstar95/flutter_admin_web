import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_main_home_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_main_home_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_main_home_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Discussions/add_topic.dart';
import 'package:flutter_admin_web/ui/Discussions/create_discussion.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_forum_likes.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_forum_topic.dart';
import 'package:flutter_admin_web/ui/Discussions/edit_create_discussion.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:intl/intl.dart';

import '../../configs/constants.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';
import '../global_search_screen.dart';

class DiscussionMain extends StatefulWidget {
  final bool isFromDiscussionForumPage;
  final String contentId, searchString;
  final bool isFromPush, enableSearching;

  DiscussionMain({
    Key? key,
    this.isFromDiscussionForumPage = true,
    this.contentId = '',
    this.searchString = '',
    this.isFromPush = false,
    this.enableSearching = true,
  }) : super(key: key);

  @override
  _DiscussionMainState createState() => _DiscussionMainState();
}

class _DiscussionMainState extends State<DiscussionMain> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  TabController? _tabController;
  List<Tab> tabList = [];
  int pageForumNumber = 1;
  int pageNumber = 1;
  int totalPage = 10;
  late DiscussionMainHomeBloc discussionMainHomeBloc;
  late ProfileBloc profileBloc;
  ScrollController _scArchive = ScrollController();
  NativeMenuModel? nativeMenuModel;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late FToast flutterToast;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabAllDiscussion,
    // ));
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabMyDiscussion,
    // ));
    print("Discussion Home Init Called");

    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    discussionMainHomeBloc = DiscussionMainHomeBloc(discussionMainHomeRepositry: DiscussionMainHomeRepositoryBuilder.repository());
    discussionMainHomeBloc.SearchForumString = widget.searchString;

    if (!widget.isFromDiscussionForumPage) {
      refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
    }
    else {
      refresh(!widget.isFromDiscussionForumPage, '', discussionMainHomeBloc.SearchForumString);
      tabList.add(Tab(
        text: 'All Discussions',
      ));
      tabList.add(Tab(
        text: "My Discussions",
      ));
      _tabController = TabController(length: tabList.length, vsync: this);
    }

    List<NativeMenuModel> list = appBloc.listNativeModel.where((element) => element.contextmenuId == "4").toList();
    if(list.isNotEmpty) {
      nativeMenuModel = list.first;
    }

    print("Data : " + widget.contentId);

    super.initState();
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => GlobalSearchScreen(menuId: 50014)),
    );

    print(result);

    if (result != null) {
      discussionMainHomeBloc.isFirstLoading = true;
      discussionMainHomeBloc.isForumSearch = true;
      discussionMainHomeBloc.SearchForumString = result.toString();
      setState(() {
        pageForumNumber = 1;
      });
      refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    flutterToast = FToast();
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
        child: Stack(
          children: <Widget>[
            !widget.isFromDiscussionForumPage
                ? _homeQuestionList()
                : tabWidget(context, itemWidth, itemHeight)
          ],
        ),
      ),
    );
  }

  Widget tabWidget(BuildContext context, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
            child: TabBar(
                controller: _tabController,
                indicatorColor: Color(int.parse("0xFF1D293F")),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
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
                children: <Widget>[_homeQuestionList(), _myDiscussionList()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeQuestionList() {
    var _controller;
    if (discussionMainHomeBloc.isForumSearch) {
      _controller =
          TextEditingController(text: discussionMainHomeBloc.SearchForumString);
    }
    else {
      _controller = TextEditingController();
    }
    return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
      bloc: discussionMainHomeBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }
        if (state is DiscussionMainHomeState) {
          if (state.status == Status.COMPLETED) {
            if (widget.contentId.contains('&;')) {
              discussionMainHomeBloc.list.forEach((element) {
                if (element.forumID ==
                    int.parse(widget.contentId.split('&;')[0])) {
                  openDiscussionTopic(element);
                }
              });
            } else if (widget.isFromPush) {
              discussionMainHomeBloc.list.forEach((element) {
                if (element.forumID == int.parse(widget.contentId)) {
                  openDiscussionTopic(element);
                }
              });
            }
          }
        }
        if (state is DeleteDiscussionForumState) {
          if (state.status == Status.COMPLETED) {
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Forum deleted successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
            refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && discussionMainHomeBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        }
        else if (state.status == Status.ERROR) {
          return noDataFound(true);
        }
        else {
          return discussionMainHomeBloc.list.isEmpty
              ? Column(
                  children: <Widget>[
                    Visibility(
                      visible: widget.isFromDiscussionForumPage && widget.enableSearching,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InsSearchTextField(
                            onTapAction: () {
                              if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                                _navigateToGlobalSearchScreen(context);
                              }
                            },
                            controller: _controller,
                            appBloc: appBloc,
                            suffixIcon: discussionMainHomeBloc.isForumSearch
                                ? IconButton(
                                    onPressed: () {
                                      discussionMainHomeBloc.isFirstLoading = true;
                                      discussionMainHomeBloc.isForumSearch = false;
                                      discussionMainHomeBloc.SearchForumString = "";
                                      setState(() {
                                        pageForumNumber = 1;
                                      });
                                      refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                    ),
                                  )
                                : null,
                            onSubmitAction: (value) {
                              if (value.toString().isNotEmpty) {
                                discussionMainHomeBloc.isFirstLoading = true;
                                discussionMainHomeBloc.isForumSearch = true;
                                discussionMainHomeBloc.SearchForumString = value.toString();
                                setState(() {
                                  pageForumNumber = 1;
                                });
                                refresh(!widget.isFromDiscussionForumPage, '', discussionMainHomeBloc.SearchForumString);
                              }
                            },
                          )),
                    ),
                    Container(
                      child: noDataFound(true),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    print("in Home Questions List:${widget.contentId}");
                    refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                  },
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: discussionMainHomeBloc.list.length + 2,
                    itemBuilder: (context, i) {
                      if (i == discussionMainHomeBloc.list.length + 1) {
                        if (state.status == Status.LOADING) {
//                        print("gone in _buildProgressIndicator");
                          return _buildProgressIndicator();
                        } else {
                          return Container();
                        }
                      }
                      else if (i == 0) {
                        return Visibility(
                          visible: widget.isFromDiscussionForumPage && widget.enableSearching,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InsSearchTextField(
                              onTapAction: () {
                                if (appBloc.uiSettingModel.isGlobalSearch ==
                                    'true') {
                                  _navigateToGlobalSearchScreen(context);
                                }
                              },
                              controller: _controller,
                              appBloc: appBloc,
                              suffixIcon: discussionMainHomeBloc.isForumSearch
                                  ? IconButton(
                                      onPressed: () {
                                        discussionMainHomeBloc.isFirstLoading = true;
                                        discussionMainHomeBloc.isForumSearch = false;
                                        discussionMainHomeBloc.SearchForumString = "";
                                        setState(() {
                                          pageForumNumber = 1;
                                        });
                                        refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                      ),
                                    )
                                  : null
                              /*(discussionMainHomeBloc.isFilterMenu)
                                        ? IconButton(
                                      onPressed: () => {
                                        //moveSkillCategory()
                                      },
                                      */ /*icon: Icon(
                                        Icons.tune,
                                      ),*/ /*
                                    )
                                        : null,*/
                              ,
                              onSubmitAction: (value) {
                                if (value.toString().isNotEmpty) {
                                  discussionMainHomeBloc.isFirstLoading = true;
                                  discussionMainHomeBloc.isForumSearch = true;
                                  discussionMainHomeBloc.SearchForumString = value.toString();
                                  setState(() {
                                    pageForumNumber = 1;
                                  });
                                  refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                }
                              },
                            ),
                          ),
                        );
                      }
                      else {
                        return Container(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                            child: Column(
                              children: [
                                _allDiscussionList(
                                    discussionMainHomeBloc.list[i - 1],
                                    true,
                                    context,
                                    i),
                                Divider(
                                  color: Colors.grey.shade600,
                                )
                              ],
                            ));
                      }
                    },
                    controller: _scArchive,
                  ),
                );
        }
      },
    );
  }

  Widget _allDiscussionList(ForumList list, bool bool, BuildContext context, int i) {
    //print("Created Date:${list.createdDate}");
    print("Moderator Name:${list.moderatorName}");
    //print("Moderator Image:${list.dFProfileImage}");

    DateTime createdDate = DateTime.now();

    try {
      print("Created Date:'${list.createdDate}'");
      createdDate = DateFormat("MM/dd/yyyy hh:mm:ss aa").parse(list.createdDate);
    }
    catch(e, s) {
      print("Error in Parsing Date:$e");
      print(s);
    }
    int differenceInDays = DateTime.now().difference(createdDate).inDays;

    return Container(
        color: InsColor(appBloc).appBGColor,
        child: GestureDetector(
          onTap: () => {
            openDiscussionTopic(list),
          },
          child: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
              child: Container(
                color: InsColor(appBloc).appBGColor,
                padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        (list.forumThumbnailPath.isNotEmpty)
                            ? Container(
                                width: 45.0,
                                height: 45.0,
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: list.forumThumbnailPath != ""
                                        ? NetworkImage(list.forumThumbnailPath.startsWith('http')
                                            ? list.forumThumbnailPath
                                            : '${ApiEndpoints.strSiteUrl + list.forumThumbnailPath}')
                                        : AssetImage(
                                            'assets/user.gif',
                                          ) as ImageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50.0)),
                                ),
                              )
                            : Container(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 20, bottom: 5.0),
                                child: Text(
                                  list.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.apply(
                                          color:
                                              InsColor(appBloc).appTextColor),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  list.createdDate != ''
                                      //? DateTime.now().difference(discussionMainHomeBloc.formatter.parse(list.createdDate)).inDays == 0
                                      //print("check for datetime ${DateTime.now().difference(DateFormat("MM/dd/yyyy hh:mm aa").parse(list.createdDate)).inDays}");
                                      // "MM/dd/yyyy hh:mm:ss aa"
                                      ? differenceInDays == 0
                                          ? 'Just now'
                                          //: DateTime.now().difference(discussionMainHomeBloc.formatter.parse(list.createdDate)).inDays.toString() + ' Days'
                                          : differenceInDays.toString() + ' Days'
                                      : '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.apply(
                                          color:
                                              InsColor(appBloc).appTextColor),
                                ))
                          ],
                        )),
                        IconButton(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          icon: Icon(Icons.more_vert,
                              color: InsColor(appBloc).appIconColor),
                          onPressed: () {
                            _settingModalBottomSheet(context, list, i - 1);
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 10.0, right: 10.0),
                            child: Html(
                                shrinkWrap: true,
                                data: list.description,
                                style: {
                                  "body": Style(
                                      color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                          .withOpacity(0.5),
                                      fontSize:
                                          FontSize(ScreenUtil().setSp(14))),
                                })
                            // child: new Text(list.description,
                            //     style: TextStyle(
                            //         fontSize: ScreenUtil().setSp(14),
                            //         color: Color(int.parse(
                            //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            //             .withOpacity(0.5)))
                            ),
                        Padding(
                            padding: EdgeInsets.only(top: 10, left: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: list.dFProfileImage != ""
                                          ? NetworkImage(
                                              list.dFProfileImage.startsWith('http')
                                                  ? list.dFProfileImage
                                                  : '${ApiEndpoints.strSiteUrl + list.dFProfileImage}',
                                            )
                                          : AssetImage(
                                              'assets/user.gif',
                                            ) as ImageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0)),
                                  ),
                                ),
                                Visibility(
                                    visible: list.author == "" ? false : true,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          'Created by: ',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ))),
                                Text(
                                  list.author,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Visibility(
                                  visible:
                                  list.moderatorName == "" ? false : true,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        'Moderator: ',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                  ),
                              ),
                              Expanded(
                                child: Text(
                                  list.moderatorName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 0.0),
                                  child: Container(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            color:
                                                Color(int.parse("0xFF1D293F")),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DiscussionForumLikes(
                                                              forumList:
                                                                  list)));
                                            },
                                            padding: EdgeInsets.only(
                                                bottom: 1.0),
                                            icon: Icon(Icons.thumb_up,
                                                size: 16.0,
                                                color: Color(
                                                    int.parse("0xFF1D293F")))),
                                        Text(
                                          list.totalLikes == null ||
                                                  list.totalLikes.isEmpty
                                              ? '0'
                                              : list.totalLikes.length
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(
                                                  int.parse("0xFF1D293F"))),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Container(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          onPressed: () {
                                            openDiscussionTopic(list);
                                          },
                                          padding:
                                              EdgeInsets.only(bottom: 1.0),
                                          icon: Icon(
                                            Icons.comment,
                                            color:
                                                Color(int.parse("0xFF1D293F")),
                                            size: 16.0,
                                          ),
                                        ),
                                        Text(
                                          list.noOfTopics.toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(
                                                  int.parse("0xFF1D293F"))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: list.createNewTopic ? true : false,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddTopic(
                                                          forumList: list,
                                                        ))).then((value) async {
                                              if (value ?? true) {
                                                refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                              }
                                            });
                                          },
                                          child: Text(
                                            'Add Topic',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                          ),
                                        )))
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  Widget _myDiscussionList() {
    return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
      bloc: discussionMainHomeBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }
        if (state.status == Status.COMPLETED) {
          //refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && discussionMainHomeBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        }
        else if (discussionMainHomeBloc.myDiscussionForumList.isEmpty) {
          return noDataFound(true);
        }
        else {
          return Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: RefreshIndicator(
              onRefresh: () async {
                refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
              },
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey.shade600,
                    );
                  },
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: discussionMainHomeBloc.myDiscussionForumList.length,
                  itemBuilder: (context, index) {
                    ForumList forumList = discussionMainHomeBloc.myDiscussionForumList[index];

                    return GestureDetector(
                      onTap: () => {
                        openDiscussionTopic(forumList),
                      },
                      child: Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                          child: Container(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                            padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 45.0,
                                      height: 45.0,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: forumList.forumThumbnailPath != ""
                                              ? NetworkImage(forumList.forumThumbnailPath.startsWith('http')
                                                  ? forumList.forumThumbnailPath
                                                  : '${ApiEndpoints.strSiteUrl + forumList.forumThumbnailPath}')
                                              : AssetImage(
                                                  'assets/user.gif',
                                                ) as ImageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, bottom: 5.0),
                                              child: Text(
                                                forumList.name,
                                                style: Theme.of(context).textTheme.caption?.apply(color: InsColor(appBloc).appTextColor),
                                              ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: Text(
                                                forumList.createdDate != ''
                                                    ? DateTime.now().difference(discussionMainHomeBloc.formatter.parse(forumList.createdDate)).inDays == 0
                                                        ? 'Just now'
                                                        : DateTime.now().difference(discussionMainHomeBloc.formatter.parse(forumList.createdDate)).inDays.toString() + ' Days'
                                                    : '',
                                                style: Theme.of(context).textTheme.subtitle2?.apply(color: InsColor(appBloc).appTextColor),
                                              ),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      icon: Icon(Icons.more_vert,
                                          color:
                                              InsColor(appBloc).appIconColor),
                                      onPressed: () {
                                        _settingModalBottomSheet(
                                            context,
                                            forumList,
                                            index);
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 10.0, right: 10.0),
                                        child: Text(
                                            forumList.description,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
                                                color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                    .withOpacity(0.5)))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Color(0xffFDCF09),
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundImage: NetworkImage(
                                                    forumList.dFProfileImage.startsWith('http')
                                                        ? forumList.dFProfileImage
                                                        : '${ApiEndpoints.strSiteUrl + discussionMainHomeBloc.myDiscussionForumList[index].dFProfileImage}'),
                                                backgroundColor: Colors.grey.shade100,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                'Moderator: ',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            ),
                                            Text(
                                              forumList.moderatorName,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            )
                                          ],
                                        ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 0.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 70.0,
                                                height: 25.0,
                                                decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        "0xFFECF1F5")),
                                                    border: Border.all(
                                                      color: InsColor(appBloc)
                                                          .appTextColor
                                                          .withAlpha(0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiscussionForumLikes(forumList: forumList)));
                                                      },
                                                      padding: EdgeInsets.only(
                                                              bottom: 1.0),
                                                      icon: Icon(Icons.thumb_up,
                                                          size: 16.0,
                                                          color: Color(int.parse(
                                                              "0xFF1D293F"))),
                                                    ),
                                                    Text(
                                                      forumList.totalLikes.length.toString(),
                                                      style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF1D293F")),
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5.0),
                                              child: Container(
                                                width: 70.0,
                                                height: 25.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        "0xFFECF1F5")),
                                                    border: Border.all(
                                                      color: InsColor(appBloc)
                                                          .appTextColor
                                                          .withAlpha(0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        openDiscussionTopic(forumList);
                                                      },
                                                      padding: EdgeInsets.only(
                                                              bottom: 1.0),
                                                      icon: Icon(
                                                        Icons.comment,
                                                        color: Color(int.parse(
                                                            "0xFF1D293F")),
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      forumList.noOfTopics.toString(),
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF1D293F")),
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(left: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(builder: (context) => AddTopic(forumList:forumList,)))
                                                        .then((value) {
                                                      if (value ?? true) {
                                                        print(
                                                            "Value : " + value);
                                                        refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    'Add Topic',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                                  ),
                                                ))
                                          ],
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          );
        }
      },
    );
  }

  Widget customFloatingAction() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listener: (context, state) {},
      builder: (context, profilestate) {
        print("Profile Consumer Build Called:${profileBloc.userprivilige.length}");

        return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
            bloc: discussionMainHomeBloc,
            listener: (context, state) {
              /*print("Discussion Main Home Status:${state.status}");
              if (state.status == Status.COMPLETED && profilestate.status == Status.COMPLETED) {
                print("Discussion Main Home Status Completed");
                discussionMainHomeBloc.isCreateForum = privilegeCreateForumIdExists();
                discussionMainHomeBloc.isEditForum = privilegeEditForumIdExists();
                discussionMainHomeBloc.isDeleteForum = privilegeDeleteForumIdExists();
              }*/
            },
            builder: (context, state) {
              if (state.status == Status.COMPLETED && profilestate.status == Status.COMPLETED) {
                //print("Discussion Main Home Status Completed");
                discussionMainHomeBloc.isCreateForum = privilegeCreateForumIdExists();
                discussionMainHomeBloc.isEditForum = privilegeEditForumIdExists();
                discussionMainHomeBloc.isDeleteForum = privilegeDeleteForumIdExists();
              }

              //print("IsCreate Forum:${discussionMainHomeBloc.isCreateForum}");
              return Visibility(
                visible: discussionMainHomeBloc.isCreateForum == true,
                child: FloatingActionButton(
                    elevation: 0.0,
                    child: Icon(Icons.add),
                    backgroundColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => CreateDiscussion()))
                          .then((value) {
                        if (value ?? true) {
                          refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                        }
                      });
                    }),
              );
            });
      },
    );
  }

  bool privilegeCreateForumIdExists() {
    //print("privilegeCreateForumIdExists called, length:${profileBloc.userprivilige.length}");
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      //print("PrivilageId:${profileBloc.userprivilige[i].privilegeid}");
      if (profileBloc.userprivilige[i].privilegeid == 434) {
        return true;
      }
    }
    return false;
  }

  void _settingModalBottomSheet(context, ForumList list, int index) {
    showModalBottomSheet(
        shape: AppConstants().bottomSheetShapeBorder(),
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
              bloc: discussionMainHomeBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {
                  discussionMainHomeBloc.isEditForum = privilegeEditForumIdExists();
                  discussionMainHomeBloc.isDeleteForum = privilegeDeleteForumIdExists();
                }
              },
              builder: (context, state) {
                print("IsEdit:${discussionMainHomeBloc.isEditForum}");
                print("My User Id:${appBloc.userid}");
                print("Created User Id:${list.createdUserID}");

                return AppConstants().bottomSheetContainer(
                  child: Wrap(
                    children: <Widget>[
                      BottomSheetDragger(),
                      Visibility(
                          visible: discussionMainHomeBloc.isEditForum && appBloc.userid == list.createdUserID.toString() ? true : false,
                          child: BottomsheetOptionTile(
                              iconData: Icons.edit,
                              text:'Edit',
                              onTap: () => {
                                    Navigator.of(context).pop(true),
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditCreateDiscussion(
                                                    forumList: list)))
                                        .then((value) {
                                      if (value ?? true) {
                                        refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                      }
                                    })
                                  })),
                      Visibility(
                          visible: list.createNewTopic ? true : false,
                          child: BottomsheetOptionTile(
                              iconData:Icons.message,
                              text:'Add Topic',
                            onTap: () => {
                              Navigator.of(context).pop(),
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) =>
                                          AddTopic(forumList: list)))
                                  .then((value) {
                                if (value ?? true) {
                                  refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
                                }
                              })
                            },
                          )),
                      Visibility(
                          visible: list.allowShare ? true : false,
                          child: BottomsheetOptionTile(
                              iconData:IconDataSolid(int.parse('0xf079'),),
                              text:'Share with People',
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShareMainScreen(
                                      true,
                                      true,
                                      false,
                                      list.forumID.toString(),
                                      list.name)))
                            },
                          )),
                      Visibility(
                          visible: list.allowShare ? true : false,
                          child: BottomsheetOptionTile(
                              iconData:IconDataSolid(int.parse('0xf1e0')),
                              text:'Share with Connection',
                            onTap: () {
                              Navigator.pop(context);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShareWithConnections(
                                      true,
                                      false,
                                      list.name,
                                      list.forumID.toString())));
                            },
                          )),
                      Visibility(
                        visible: discussionMainHomeBloc.isDeleteForum && appBloc.userid == list.createdUserID.toString() ? true : false,
                        child: BottomsheetOptionTile(
                          iconData: Icons.delete,
                          text:'Delete',
                          onTap: () => {
                            //Navigator.of(context).pop(),
                            showAlertDialog(context, index),
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  bool privilegeEditForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 457) {
        return true;
      }
    }
    return false;
  }

  bool privilegeDeleteForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 436) {
        return true;
      }
    }
    return false;
  }

  Widget noDataFound(val) {
    return val
        ? RefreshIndicator(
          onRefresh: () async {
            print("Called:${widget.contentId}");
            refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
          },
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
            child: Column(
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
              ),
          ),
        )
        : Container();
  }

  void refresh(bool isTab, String contentId, String value) async {
    print("refresh called with isTab:$isTab, contentId:$contentId, value:$value");

    if(nativeMenuModel != null) {
      await sharePrefSaveString(
          sharedPref_ComponentID, nativeMenuModel!.componentId);
      await sharePrefSaveString(
          sharedPref_RepositoryId, nativeMenuModel!.repositoryId);
    }

    discussionMainHomeBloc.add(GetDiscussionMainHomeDetails(isTab, contentId, value));
  }

  void openDiscussionTopic(
    ForumList discussionForumList,
  ) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiscussionForumTopic(
                forumList: discussionForumList,
                contentID: widget.contentId))).then((value) => {
    if (value ?? true) {
      refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString)
    }
  });
  }

  showAlertDialog(BuildContext context, int index) {
    // Create button
    Widget deleteButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        "Yes, delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
        discussionMainHomeBloc.add(DeleteDiscussionForumEvent(
            forumId: discussionMainHomeBloc.list[index].forumID));
        // discussionMainHomeBloc.myDiscussionForumList.removeAt(index);
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
        "Are you sure you want to delete this forum?",
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

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
