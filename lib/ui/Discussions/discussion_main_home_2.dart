import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/controllers/discussion_forum_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/providers/discussion_forum_provider.dart';
import 'package:flutter_admin_web/ui/Discussions/add_topic.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_forum_likes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/app_colors.dart';

class DiscussionMain2 extends StatefulWidget {
  final bool isFromDiscussionForumPage;
  final String contentId, searchString;
  final bool isFromPush, enableSearching, isFetchOnInit;

  DiscussionMain2({
    Key? key,
    this.isFromDiscussionForumPage = true,
    this.contentId = '',
    this.searchString = '',
    this.isFromPush = false,
    this.enableSearching = true,
    this.isFetchOnInit = false,
  }) : super(key: key);

  @override
  _DiscussionMain2State createState() => _DiscussionMain2State();
}

class _DiscussionMain2State extends State<DiscussionMain2> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();

  TabController? _tabController;
  List<Tab> tabList = [];
  int pageForumNumber = 1;
  int pageNumber = 1;
  int totalPage = 10;
  late ProfileBloc profileBloc;
  ScrollController _scArchive = new ScrollController();
  NativeMenuModel? nativeMenuModel;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late FToast flutterToast;

  @override
  bool get wantKeepAlive => true;

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
    /*showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
              bloc: discussionMainHomeBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {
                  discussionMainHomeBloc.isEditForum =
                      privilegeEditForumIdExists();
                  discussionMainHomeBloc.isDeleteForum =
                      privilegeDeleteForumIdExists();
                }
              },
              builder: (context, state) {
                print("IsEdit:${discussionMainHomeBloc.isEditForum}");
                print("My User Id:${appBloc.userid}");
                print("Created User Id:${list.createdUserID}");

                return Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: new Wrap(
                    children: <Widget>[
                      Visibility(
                          visible: discussionMainHomeBloc.isEditForum && appBloc.userid == list.createdUserID.toString() ? true : false,
                          child: new ListTile(
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
                          child: new ListTile(
                            leading: new Icon(
                              Icons.message,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                            title: new Text(
                              'Add Topic',
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
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
                          child: new ListTile(
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
                                      true,
                                      false,
                                      list.forumID.toString(),
                                      list.name)))
                            },
                          )),
                      Visibility(
                          visible: list.allowShare ? true : false,
                          child: ListTile(
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
                                      true,
                                      false,
                                      list.name,
                                      list.forumID.toString())));
                            },
                          )),
                      Visibility(
                        visible: discussionMainHomeBloc.isDeleteForum && appBloc.userid == list.createdUserID.toString() ? true : false,
                        child: new ListTile(
                          leading: new Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          title: new Text(
                            'Delete',
                            style: new TextStyle(color: Colors.red),
                          ),
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
        });*/
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

  void refresh({bool isRefresh = true, bool withoutNotify = false}) async {
    print("refresh called with isRefresh:$isRefresh, withoutNotify:$withoutNotify");

    String strComponentID = "", strRepositoryId = "";

    if(nativeMenuModel != null) {
      strComponentID = nativeMenuModel!.componentId;
      strRepositoryId = nativeMenuModel!.repositoryId;
    }

    DiscussionForumController().getAllDiscussionForums(
      isRefresh: isRefresh,
      withoutNotify: withoutNotify,
      isEventTab: !widget.isFromDiscussionForumPage,
      contentId: widget.contentId,
      strRepositoryId: strComponentID,
      strComponentID: strRepositoryId,
    );
  }

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

    if (!widget.isFromDiscussionForumPage) {
      refresh(isRefresh: true, withoutNotify: true);
    }
    else {
      if(widget.isFetchOnInit) {
        refresh(isRefresh: true, withoutNotify: true);
      }
      tabList.add(new Tab(
        text: 'All Discussions',
      ));
      tabList.add(new Tab(
        text: "My Discussions",
      ));
      _tabController = new TabController(length: tabList.length, vsync: this);
    }

    List<NativeMenuModel> list = appBloc.listNativeModel.where((element) => element.contextmenuId == "4").toList();
    if(list.isNotEmpty) {
      nativeMenuModel = list.first;
    }

    print("Data : " + widget.contentId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Consumer<DiscussionForumProvider>(
      builder: (BuildContext context, DiscussionForumProvider discussionForumProvider, Widget? child) {
        return Scaffold(
          //floatingActionButton: customFloatingAction(),
          key: _scaffoldkey,
          body: Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Stack(
              children: <Widget>[
                !widget.isFromDiscussionForumPage
                    ? _homeQuestionList(discussionForumProvider)
                    : tabWidget(discussionForumProvider, itemWidth, itemHeight)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget tabWidget(DiscussionForumProvider discussionForumProvider, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
            child: new TabBar(
                controller: _tabController,
                indicatorColor: Color(int.parse("0xFF1D293F")),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                tabs: tabList,
            ),
          ),
          Expanded(
            child: Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              height: double.maxFinite,
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[_homeQuestionList(discussionForumProvider), _myDiscussionList(discussionForumProvider)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeQuestionList(DiscussionForumProvider discussionForumProvider) {
    if (discussionForumProvider.isFirstTimeLoadingDiscussions) {
      return _buildProgressIndicator();
    }
    else if (discussionForumProvider.list.isEmpty) {
      return RefreshIndicator(
          color: AppColors.getAppButtonBGColor(),
          onRefresh: () async {
            refresh(isRefresh: true, withoutNotify: false);
          },
          child: getNoDiscussionsWidget()
      );
    }
    else {
      return RefreshIndicator(
        onRefresh: () async {
          refresh(isRefresh: true, withoutNotify: false);
        },
        color: AppColors.getAppButtonBGColor(),
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: AlwaysScrollableScrollPhysics(),
          //padding: EdgeInsets.symmetric(horizontal: 18.h),
          itemCount: discussionForumProvider.list.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if((discussionForumProvider.list.isEmpty && index == 0) || index == discussionForumProvider.list.length) {
              //return Shimmer
              if(discussionForumProvider.isDiscussionsLoading) {
                return _buildProgressIndicator();
              }
              else return SizedBox.shrink();
            }

            if(index > discussionForumProvider.list.length - discussionForumProvider.refreshLimit) {
              if(discussionForumProvider.hasMoreDiscussions && !discussionForumProvider.isDiscussionsLoading) {
                refresh(isRefresh: false, withoutNotify: true);
              }
            }

            ForumList forumList = discussionForumProvider.list[index];

            return Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: Column(
                children: [
                  discussionCard(forumList, true, context, index,),
                  Divider(color: Colors.grey.shade600,)
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Widget _myDiscussionList(DiscussionForumProvider discussionForumProvider) {
    if (discussionForumProvider.isFirstTimeLoadingDiscussions) {
      return _buildProgressIndicator();
    }
    else if (discussionForumProvider.myDiscussionForumList.isEmpty) {
      return RefreshIndicator(
          color: AppColors.getAppButtonBGColor(),
          onRefresh: () async {
            refresh(isRefresh: true, withoutNotify: false);
          },
          child: getNoDiscussionsWidget()
      );
    }
    else {
      return RefreshIndicator(
        onRefresh: () async {
          refresh(isRefresh: true, withoutNotify: false);
        },
        color: AppColors.getAppButtonBGColor(),
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: AlwaysScrollableScrollPhysics(),
          //padding: EdgeInsets.symmetric(horizontal: 18.h),
          itemCount: discussionForumProvider.myDiscussionForumList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if((discussionForumProvider.myDiscussionForumList.isEmpty && index == 0) || index == discussionForumProvider.myDiscussionForumList.length) {
              //return Shimmer
              if(discussionForumProvider.isDiscussionsLoading) {
                return _buildProgressIndicator();
              }
              else return SizedBox.shrink();
            }

            if(index > discussionForumProvider.myDiscussionForumList.length - discussionForumProvider.refreshLimit) {
              if(discussionForumProvider.hasMoreDiscussions && !discussionForumProvider.isDiscussionsLoading) {
                refresh(isRefresh: false, withoutNotify: true);
              }
            }

            ForumList forumList = discussionForumProvider.myDiscussionForumList[index];

            DateFormat dateFormat = DateFormat('MM/dd/yyyy HH:mm:ss');

            return new GestureDetector(
              onTap: () => {
                //openDiscussionTopic(forumList),
              },
              child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                  child: new Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                    child: new Column(
                      children: [
                        new Row(
                          children: [
                            new Container(
                              width: 45.0,
                              height: 45.0,
                              padding: EdgeInsets.all(20.0),
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: forumList.forumThumbnailPath != ""
                                      ? NetworkImage(forumList.forumThumbnailPath.startsWith('http')
                                      ? forumList.forumThumbnailPath
                                      : '${ApiEndpoints.strSiteUrl + forumList.forumThumbnailPath}')
                                      : AssetImage(
                                    'assets/user.gif',
                                  ) as ImageProvider,
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(50.0)),
                              ),
                            ),
                            new Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, bottom: 5.0),
                                    child: new Text(
                                      forumList.name,
                                      style: Theme.of(context).textTheme.caption?.apply(color: InsColor(appBloc).appTextColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: new Text(
                                      forumList.createdDate != ''
                                          ? DateTime.now().difference(dateFormat.parse(forumList.createdDate)).inDays == 0
                                          ? 'Just now'
                                          : DateTime.now().difference(dateFormat.parse(forumList.createdDate)).inDays.toString() + ' Days'
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
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 10.0, right: 10.0),
                                child: new Text(
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
                              child: new Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(0xffFDCF09),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          forumList.dFProfileImage.startsWith('http')
                                              ? forumList.dFProfileImage
                                              : '${ApiEndpoints.strSiteUrl + forumList.dFProfileImage}'),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Moderator: ',
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ),
                                  Text(
                                    forumList.moderatorName,
                                    style: new TextStyle(
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
                                    new Padding(
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: new Container(
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
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiscussionForumLikes(forumList: forumList)));
                                              },
                                              padding: new EdgeInsets.only(
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
                                    new Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: new Container(
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
                                        child: new Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                //openDiscussionTopic(forumList);
                                              },
                                              padding: new EdgeInsets.only(
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
                                        child: new GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) => AddTopic(forumList:forumList,)))
                                                .then((value) {
                                              if (value ?? true) {
                                                print(
                                                    "Value : " + value);
                                                //refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
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
                  ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget discussionCard(ForumList list, bool bool, BuildContext context, int i) {
    //print("Created Date:${list.createdDate}");
    //print("Moderator Name:${list.moderatorName}");

    DateTime createdDate = DateTime.now();

    try {
      //print("Created Date:'${list.createdDate}'");
      createdDate = DateFormat("MM/dd/yyyy hh:mm:ss aa").parse(list.createdDate);
    }
    catch(e, s) {
      print("Error in Parsing Date:$e");
      print(s);
    }
    int differenceInDays = DateTime.now().difference(createdDate).inDays;

    return new Container(
        color: InsColor(appBloc).appBGColor,
        child: new GestureDetector(
          onTap: () => {
            //openDiscussionTopic(list),
          },
          child: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
              child: new Container(
                color: InsColor(appBloc).appBGColor,
                padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
                child: new Column(
                  children: [
                    new Row(
                      children: [
                        (list.forumThumbnailPath.length > 0)
                            ? Container(
                                width: 45.0,
                                height: 45.0,
                                padding: EdgeInsets.all(20.0),
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: list.forumThumbnailPath != ""
                                        ? NetworkImage(list.forumThumbnailPath.startsWith('http')
                                            ? list.forumThumbnailPath
                                            : '${ApiEndpoints.strSiteUrl + list.forumThumbnailPath}')
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
                                padding: EdgeInsets.only(left: 20, bottom: 5.0),
                                child: new Text(
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
                                child: new Text(
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
                    new Column(
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
                            child: new Row(
                              children: [
                                new Container(
                                  width: 20.0,
                                  height: 20.0,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey,
                                    image: new DecorationImage(
                                      image: list.dFProfileImage != ""
                                          ? NetworkImage(
                                              list.dFProfileImage
                                                      .startsWith('http')
                                                  ? list.dFProfileImage
                                                  : '${ApiEndpoints.strSiteUrl + list.dFProfileImage}',
                                            )
                                          : AssetImage(
                                              'assets/user.gif',
                                            ) as ImageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(30.0)),
                                  ),
                                ),
                                Visibility(
                                    visible: list.author == "" ? false : true,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          'Created by: ',
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ))),
                                Text(
                                  list.author,
                                  style: new TextStyle(
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
                                        style: new TextStyle(
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
                                  style: new TextStyle(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: new Row(
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
                                            padding: new EdgeInsets.only(
                                                bottom: 1.0),
                                            icon: Icon(Icons.thumb_up,
                                                size: 16.0,
                                                color: Color(
                                                    int.parse("0xFF1D293F")))),
                                        Text(
                                          list.totalLikes == null ||
                                                  list.totalLikes.length == 0
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: new Row(
                                      children: [
                                        IconButton(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          onPressed: () {
                                            //openDiscussionTopic(list);
                                          },
                                          padding:
                                              new EdgeInsets.only(bottom: 1.0),
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
                                        child: new GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddTopic(
                                                          forumList: list,
                                                        ))).then((value) async {
                                              if (value ?? true) {
                                                //refresh(!widget.isFromDiscussionForumPage, widget.contentId, discussionMainHomeBloc.SearchForumString);
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

  Widget getNoDiscussionsWidget(){
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Container(
                height: 230.h,
                child: Image.asset('assets/common/no_venues.png')),*/
            SizedBox(
              height: 25.h,
            ),
            Text("No Discussions", style: TextStyle(color: AppColors.getAppTextColor()),),
          ],
        )
      ],
    );
  }

  Widget noDataFound(val) {
    return val
        ? RefreshIndicator(
          onRefresh: () async {
            print("Called:${widget.contentId}");
            refresh(isRefresh: true, withoutNotify: false);
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
        : new Container();
  }

  Widget _buildProgressIndicator() {
    return SpinKitCircle(color: AppColors.getAppButtonBGColor(),);
  }
}
