import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_main_home_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_main_home_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Discussions/add_comment.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_forum_comment_list.dart';
import 'package:flutter_admin_web/ui/Discussions/edit_topic.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/common/Viewimagenew.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';

import '../common/bottomsheet_drager.dart';
import 'add_topic.dart';
import 'discussion_forum_likes.dart';

class DiscussionForumTopic extends StatefulWidget {
  final ForumList forumList;
  final String contentID;

  DiscussionForumTopic({
    Key? key,
    required this.forumList,
    required this.contentID,
  }) : super(key: key);

  @override
  _DiscussionForumTopicState createState() => _DiscussionForumTopicState();
}

class _DiscussionForumTopicState extends State<DiscussionForumTopic> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  late DiscussionTopicBloc discussionTopicBloc;
  late DiscussionMainHomeBloc discussionMainHomeBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late FToast flutterToast;
  bool isNewOnTop = true;
  final seen = Set<TotalLikes>();
  String forumCount = "";

  @override
  void initState() {
    super.initState();
    // final unique = widget.forumList.totalLikes.where((str) => seen.add(str)).toList();

    discussionTopicBloc = new DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());
    discussionMainHomeBloc = DiscussionMainHomeBloc(
        discussionMainHomeRepositry:
            DiscussionMainHomeRepositoryBuilder.repository());

    refresh();

    forumCount = widget.forumList.totalLikes != null
        ? widget.forumList.totalLikes.length.toString()
        : '0';

    Future.delayed(const Duration(milliseconds: 2000), () {
      print("Asdsdd  : " + widget.contentID);
      if (widget.contentID.contains('&;')) {
        discussionTopicBloc.list.forEach((element) {
          if (element.contentID == widget.contentID.split('&;')[1]) {
            if (widget.contentID.split('&;').length > 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DiscussionForumCommentList(
                          forumList: widget.forumList,
                          topicList: element,
                          contentID: widget.contentID))).then((value) => {
                    // if (value) {widget.contentID = ''}
                  });
            }
          }
        });
      }
    });
  }

  String removeAllHtmlTags(String htmlText) {
    String parsedString = "";

    var document = parse(htmlText);

    parsedString = parse(document.body?.text ?? "").documentElement?.text ?? "";

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      // floatingActionButton: CustomFloatingAction(),
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.forumList.name,
          style: TextStyle(
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
          children: <Widget>[
            Divider(
              height: 2,
              color: InsColor(appBloc).appTextColor,
            ),
            new Column(
              children: [
                new Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      refresh();
                    },
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: new Column(
                        children: [
                          mainTopicWidget(),
                          new Divider(
                            height: 2,
                            color: InsColor(appBloc).appTextColor,
                          ),
                          lastUpdatedBy(),
                          // moderateBy(),
                          new Divider(
                            height: 2,
                            color: InsColor(appBloc).appTextColor,
                          ),
                          topicListWidget()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget mainTopicWidget() {
    return new Column(
      children: [
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: new Column(
              children: [
                new Row(
                  children: [
                    new Container(
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image: widget.forumList.forumThumbnailPath != ""
                              ? NetworkImage(widget.forumList.forumThumbnailPath
                                      .startsWith('http')
                                  ? widget.forumList.forumThumbnailPath
                                  : '${ApiEndpoints.strSiteUrl + widget.forumList.forumThumbnailPath}')
                              : AssetImage(
                                  'assets/user.gif',
                                ) as ImageProvider,
                          fit: BoxFit.fill,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                      ),
                    ),
                    new Expanded(
                        child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: new Text(
                              widget.forumList.name,
                              style: Theme.of(context).textTheme.caption?.apply(
                                  color: InsColor(appBloc).appTextColor),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: new Text(
                              // DateTime
                              //     .now()
                              //     .difference(
                              //     discussionMainHomeBloc
                              //         .formatter.parse(
                              widget.forumList.createdDate == ""
                                  ? ''
                                  : (widget.forumList.createdDate),
                              // .inDays
                              // .toString() + ' Days',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ))
                      ],
                    )),
                    /*IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    _settingModalBottomSheet(context, widget.forumList);
                  },

                ),*/
                  ],
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                      child: Html(
                          shrinkWrap: true,
                          data: widget.forumList.description,
                          style: {
                            "body": Style(
                                color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                    .withOpacity(0.5),
                                fontSize: FontSize(ScreenUtil().setSp(14))),
                          }),
                      // child: new Text(widget.forumList?.description ?? '',
                      //     style: TextStyle(
                      //         fontSize: ScreenUtil().setSp(14),
                      //         color: Color(int.parse(
                      //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                      //             .withOpacity(0.5))),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10, left: 10.0),
                    //   child: new Container(
                    //     width: 20.0,
                    //     height: 20.0,
                    //     padding: EdgeInsets.all(20.0),
                    //     decoration: new BoxDecoration(
                    //       color: const Color(0xff7c94b6),
                    //       image: new DecorationImage(
                    //         image: widget.forumList.dFProfileImage.isNotEmpty
                    //             ? NetworkImage(widget.forumList.dFProfileImage
                    //                     .startsWith('http')
                    //                 ? widget.forumList.dFProfileImage
                    //                 : '${ApiEndpoints.strSiteUrl + widget.forumList.dFProfileImage}')
                    //             : AssetImage(
                    //                 'assets/user.gif',
                    //               ),
                    //         fit: BoxFit.fill,
                    //       ),
                    //       borderRadius:
                    //           new BorderRadius.all(new Radius.circular(30.0)),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
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
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DiscussionForumLikes(
                                                      forumList:
                                                          widget.forumList)));
                                    },
                                    padding: new EdgeInsets.only(bottom: 1.0),
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: Color(int.parse("0xFF1D293F")),
                                      size: 16.0,
                                    ),
                                  ),
                                  Text(
                                    forumCount,
                                    style: TextStyle(
                                        color: Color(int.parse("0xFF1D293F")),
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: new Container(
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
                                  child: new Row(children: [
                                    IconButton(
                                      onPressed: () {},
                                      padding: new EdgeInsets.only(bottom: 1.0),
                                      icon: Icon(
                                        Icons.comment,
                                        color: Color(int.parse("0xFF1D293F")),
                                        size: 16.0,
                                      ),
                                    ),
                                    Text(
                                      widget.forumList.noOfTopics.toString(),
                                      style: TextStyle(
                                          color: Color(int.parse("0xFF1D293F")),
                                          fontSize: 10),
                                    ),
                                  ])),
                            ),
                            Visibility(
                                visible: widget.forumList.createNewTopic,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => AddTopic(
                                                      forumList:
                                                          widget.forumList,
                                                    )))
                                            .then((value) {
                                          if (value ?? true) {
                                            refresh();
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
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
        pinTopicListWidget()
      ],
    );
  }

  Widget lastUpdatedBy() {
    DateTime createdDate = DateTime.now();
    try {
      print("Created Date:'${widget.forumList.createdDate}'");
      createdDate = DateFormat("MM/dd/yyyy hh:mm:ss aa").parse(widget.forumList.createdDate);
    }
    catch(e, s) {
      print("Error in Parsing Date:$e");
      print(s);
    }

    return new Padding(
      padding:
          EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0, right: 20.0),
      child: new Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: new Column(
          children: [
            new Row(
              children: [
                new Text(
                  'Last Updated by',
                  style: TextStyle(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      fontWeight: FontWeight.bold),
                ),
                new Spacer(),
                new Icon(
                  Icons.arrow_drop_up,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                )
              ],
            ),
            new Row(
              children: [
                new Container(
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: widget.forumList.dFProfileImage != ""
                          ? NetworkImage(widget.forumList.dFProfileImage
                                  .startsWith('http')
                              ? widget.forumList.dFProfileImage
                              : '${ApiEndpoints.strSiteUrl + widget.forumList.dFProfileImage}')
                          : AssetImage(
                              'assets/user.gif',
                            ) as ImageProvider,
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                  ),
                ),
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: new Text(
                          widget.forumList.updatedAuthor,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: new Text(
                          widget.forumList.createdDate.isEmpty
                              ? ''
                              : DateTime.now().difference(createdDate).inDays.toString() + ' Days',
                          style: new TextStyle(
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 10.0),
                        ))
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget moderateBy() {
    return new Padding(
      padding: EdgeInsets.all(10.0),
      child: new Container(
        height: 200.0,
        child: new Column(children: [
          new Row(
            children: [
              new Text('Last Updated by'),
              new Spacer(),
              new Icon(
                Icons.arrow_drop_up,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              )
            ],
          ),
          new Expanded(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return new Container(
                      margin: EdgeInsets.all(8.0),
                      child: new Row(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                  'https://picsum.photos/250?image=9')),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                            ),
                            child: new Text(
                              'Aman Gangwar',
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Spacer(),
                          new Icon(Icons.remove_circle_outlined),
                        ],
                      ),
                    );
                  }))
        ]),
      ),
    );
  }

  Widget topicListWidget() {
    return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
      bloc: discussionTopicBloc,
      listener: (context, state) async {
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }

        if (state.status == Status.COMPLETED) {
          if (state is LikeDislikeState) {
            refresh();

            discussionMainHomeBloc.isFirstLoading = true;
            discussionMainHomeBloc
                .add(GetDiscussionMainHomeDetails(false, '', ''));

            while (discussionMainHomeBloc.isFirstLoading) {
              await Future.delayed(Duration(milliseconds: 10));
            }

            List<ForumList> list = discussionMainHomeBloc.list
                .where((element) => element.forumID == widget.forumList.forumID)
                .toList();
            if (list.isNotEmpty) {
              setState(() {
                forumCount = list.first.totalLikes.length.toString();
              });
            }
          }
          else if (state is GetDiscussionTopicState) {
            widget.forumList.noOfTopics = discussionTopicBloc.list.length;
            setState(() {});
          }
          else if (state is DeleteForumTopicState) {
            widget.forumList.noOfTopics = discussionTopicBloc.list.length;

            discussionMainHomeBloc.isFirstLoading = true;
            discussionMainHomeBloc
                .add(GetDiscussionMainHomeDetails(false, '', ''));

            while (discussionMainHomeBloc.isFirstLoading) {
              await Future.delayed(Duration(milliseconds: 10));
            }

            List<ForumList> list = discussionMainHomeBloc.list
                .where((element) => element.forumID == widget.forumList.forumID)
                .toList();
            if (list.isNotEmpty) {
              setState(() {
                forumCount = list.first.totalLikes.length.toString();
              });
            }

            setState(() {});
          }
          else if (state is PinTopicState) {
            refresh();

            //print("IsPinned:${state.isPinned}");

            flutterToast.showToast(
                child: CommonToast(
                    displaymsg: '${state.isPinned ? "Pinned" : "Unpinned"} topic successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
          }
          if (state is DeleteForumTopicState) {
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Topic deleted successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
          }

          discussionTopicBloc.pinTopicList.clear();
          discussionTopicBloc.pinTopicList = discussionTopicBloc.list
              .where((item) => item.isPin == true)
              .toList();
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && discussionTopicBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.black54,
                size: 70.0,
              ),
            ),
          );
        }
        else if (discussionTopicBloc.list.length == 0) {
          return noDataFound(true);
        }
        else {
          return new Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: new Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: new Column(
                children: [
                  new Card(
                    child: new Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isNewOnTop = true;
                              discussionTopicBloc.list.sort((a, b) {
                                return a.createdDate.compareTo(b.createdDate);
                              });
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Oldest on Top',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isNewOnTop
                                          ? Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                          : Color(int.parse("0xFF1D293F"))))),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isNewOnTop = false;
                                discussionTopicBloc.list.sort((b, a) {
                                  return a.createdDate.compareTo(b.createdDate);
                                });
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Newest on Top',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: !isNewOnTop
                                          ? Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                          : Color(int.parse("0xFF1D293F")),
                                    )))),
                      ],
                    ),
                  ),
                  new Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 10.0),
                          child: new Text(
                            'Topics',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          )),
                      new Spacer(),
                      // new Icon(Icons.filter_list)
                    ],
                  ),
                  Stack(
                    children: [
                      new ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: discussionTopicBloc.list.length,
                          itemBuilder: (context, index) {
                            // String attachmentPathUrl = '';
                            // if (discussionTopicBloc.pinTopicList != null &&
                            //     discussionTopicBloc.pinTopicList.length > 0) {
                            //   attachmentPathUrl = discussionTopicBloc
                            //           .pinTopicList[index].uploadFileName
                            //           .startsWith('http')
                            //       ? discussionTopicBloc
                            //           .pinTopicList[index].uploadFileName
                            //       : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.pinTopicList[index].uploadFileName}';
                            // }

                            // attachmentPathUrl =
                            //     attachmentPathUrl.replaceAll(' ', '%20');

                            return Visibility(
                              visible:
                                  discussionTopicBloc.list[index].isPin == true
                                      ? false
                                      : true,
                              child: InkWell(
                                onTap: () {},
                                child: new Container(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                  padding: EdgeInsets.all(15.0),
                                  child: new Column(
                                    children: [
                                      new Row(
                                        children: [
                                          new Container(
                                            width: 50.0,
                                            height: 50.0,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: new BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: new DecorationImage(
                                                image: discussionTopicBloc
                                                            .list[index]
                                                            .topicUserProfile !=
                                                        ""
                                                    ? NetworkImage(discussionTopicBloc
                                                            .list[index]
                                                            .topicUserProfile
                                                            .startsWith('http')
                                                        ? discussionTopicBloc
                                                            .list[index]
                                                            .topicUserProfile
                                                        : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.list[index].topicUserProfile}')
                                                    : AssetImage(
                                                        'assets/user.gif',
                                                      ) as ImageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  new Radius.circular(50.0)),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 20.0,
                                                ),
                                                child: new Text(
                                                  discussionTopicBloc
                                                      .list[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.apply(
                                                          color: InsColor(
                                                                  appBloc)
                                                              .appTextColor),
                                                )),
                                          ),
                                          new IconButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: InsColor(appBloc)
                                                  .appIconColor,
                                            ),
                                            onPressed: () {
                                              _settingTopinBottomSheet(
                                                  context,
                                                  widget.forumList,
                                                  discussionTopicBloc
                                                      .list[index],
                                                  index);
                                            },
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: new Text(
                                                removeAllHtmlTags(
                                                    discussionTopicBloc
                                                            .list[index]
                                                            .longDescription
                                                            .isNotEmpty
                                                        ? discussionTopicBloc
                                                            .list[index]
                                                            .longDescription
                                                        : ''),
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5)),
                                              )),
                                          discussionTopicBloc.list[index]
                                                      .uploadFileName !=
                                                  ""
                                              ? InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.0, left: 10.0),
                                                    child: new Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: const Color(
                                                            0xff7c94b6),
                                                        image:
                                                            new DecorationImage(
                                                          image: discussionTopicBloc
                                                                      .list[
                                                                          index]
                                                                      .uploadFileName !=
                                                                  ""
                                                              ? NetworkImage(discussionTopicBloc
                                                                      .list[
                                                                          index]
                                                                      .uploadFileName
                                                                      .startsWith(
                                                                          'http')
                                                                  ? discussionTopicBloc
                                                                      .list[
                                                                          index]
                                                                      .uploadFileName
                                                                  : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.list[index].uploadFileName}')
                                                              : AssetImage(
                                                                  '',
                                                                ) as ImageProvider,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .all(new Radius
                                                                    .circular(
                                                                30.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    //sreekanth commented

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewImageNew(
                                                                    discussionTopicBloc
                                                                        .list[
                                                                            index]
                                                                        .uploadFileName)));
                                                  },
                                                )
                                              : Container(),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, left: 5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                      visible: widget
                                                          .forumList.likePosts,
                                                      child: new Container(
                                                        width: 70.0,
                                                        height: 25.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(int
                                                                    .parse(
                                                                        "0xFFECF1F5")),
                                                                border:
                                                                    Border.all(
                                                                  color: InsColor(
                                                                          appBloc)
                                                                      .appTextColor
                                                                      .withAlpha(
                                                                          0),
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        child: new Row(
                                                          children: [
                                                            IconButton(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              onPressed: () {
                                                                // discussionTopicBloc.isFirstLoading = true;
                                                                discussionTopicBloc
                                                                        .list[
                                                                            index]
                                                                        .likeState
                                                                    ? discussionTopicBloc
                                                                        .add(
                                                                            LikeDisLikeEvent(
                                                                        strObjectID: discussionTopicBloc
                                                                            .list[index]
                                                                            .contentID,
                                                                        intTypeID:
                                                                            1,
                                                                        blnIsLiked:
                                                                            false,
                                                                      ))
                                                                    : discussionTopicBloc
                                                                        .add(
                                                                            LikeDisLikeEvent(
                                                                        strObjectID: discussionTopicBloc
                                                                            .list[index]
                                                                            .contentID,
                                                                        intTypeID:
                                                                            1,
                                                                        blnIsLiked:
                                                                            true,
                                                                      ));
                                                              },
                                                              padding:
                                                                  new EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          1.0),
                                                              icon: Icon(
                                                                Icons.thumb_up,
                                                                size: 16.0,
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xFF1D293F")),
                                                              ),
                                                            ),
                                                            Text(
                                                              discussionTopicBloc
                                                                              .list[
                                                                                  index]
                                                                              .likes ==
                                                                          null ||
                                                                      discussionTopicBloc
                                                                              .list[
                                                                                  index]
                                                                              .likes ==
                                                                          0
                                                                  ? '0'
                                                                  : discussionTopicBloc
                                                                      .list[
                                                                          index]
                                                                      .likes
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      int.parse(
                                                                          "0xFF1D293F")),
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  new Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: new Container(
                                                        width: 70.0,
                                                        height: 25.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(int
                                                                    .parse(
                                                                        "0xFFECF1F5")),
                                                                border:
                                                                    Border.all(
                                                                  color: InsColor(
                                                                          appBloc)
                                                                      .appTextColor
                                                                      .withAlpha(
                                                                          0),
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        child: new Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              DiscussionForumCommentList(forumList: widget.forumList, topicList: discussionTopicBloc.list[index]))).then(
                                                                      (value) =>
                                                                          {
                                                                            if (value ??
                                                                                true)
                                                                              {
                                                                                refresh()
                                                                              }
                                                                          });
                                                                },
                                                                padding:
                                                                    new EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            1.0),
                                                                icon: Icon(
                                                                  Icons.comment,
                                                                  size: 16.0,
                                                                  color: Color(
                                                                      int.parse(
                                                                          "0xFF1D293F")),
                                                                ),
                                                              ),
                                                              Text(
                                                                discussionTopicBloc
                                                                    .list[index]
                                                                    .noOfReplies
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        int.parse(
                                                                            "0xFF1D293F")),
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ])),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0),
                                                      child:
                                                          new GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) => AddComment(
                                                                      forumList:
                                                                          widget
                                                                              .forumList,
                                                                      topicList:
                                                                          discussionTopicBloc
                                                                              .list[index])))
                                                              .then((value) {
                                                            if (value ?? true) {
                                                              refresh();
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add Comment',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                                        ),
                                                      ))
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      (state.status == Status.LOADING)
                          ? Center(
                              child: AbsorbPointer(
                                child: SpinKitCircle(
                                  color: Colors.black54,
                                  size: 70.h,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget pinTopicListWidget() {
    return new Column(
      children: [
        Visibility(
            visible:
                discussionTopicBloc.pinTopicList.length == 0 ? false : true,
            child: new Divider(
              height: 2,
              color: Colors.black87,
            )),
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new Container(
            color: discussionTopicBloc.pinTopicList.length == 0
                ? Colors.white38
                : Colors.black12,
            child: new Column(
              children: [
                new ListView.builder(
                    shrinkWrap: true,
                    itemCount: discussionTopicBloc.pinTopicList.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                          visible: discussionTopicBloc.pinTopicList.length == 0
                              ? false
                              : true,
                          child: new Container(
                              margin: EdgeInsets.all(8.0),
                              child: new Column(
                                children: [
                                  new Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Color(0xffFDCF09),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                discussionTopicBloc
                                                        .pinTopicList[index]
                                                        .topicUserProfile
                                                        .startsWith('http')
                                                    ? discussionTopicBloc
                                                        .pinTopicList[index]
                                                        .topicUserProfile
                                                    : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.pinTopicList[index].topicUserProfile}'),
                                            backgroundColor:
                                                Colors.grey.shade100,
                                          )),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 20.0,
                                          ),
                                          child: new Text(
                                            discussionTopicBloc
                                                .pinTopicList[index].name,
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      new IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: InsColor(appBloc).appIconColor,
                                        ),
                                        onPressed: () {
                                          _settingUnPinTopinBottomSheet(
                                              context,
                                              widget.forumList,
                                              discussionTopicBloc
                                                  .pinTopicList[index],
                                              index);
                                        },
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 10.0, right: 10.0),
                                        child: new Text(
                                          discussionTopicBloc
                                              .pinTopicList[index]
                                              .longDescription,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(14),
                                              color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10.0),
                                        child: discussionTopicBloc
                                                .pinTopicList[index]
                                                .uploadFileName
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewImageNew(
                                                                  discussionTopicBloc
                                                                      .pinTopicList[
                                                                          index]
                                                                      .uploadFileName)));
                                                },
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      Color(0xffFDCF09),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: NetworkImage(
                                                        discussionTopicBloc
                                                                .pinTopicList[
                                                                    index]
                                                                .uploadFileName
                                                                .startsWith(
                                                                    'http')
                                                            ? discussionTopicBloc
                                                                .pinTopicList[
                                                                    index]
                                                                .uploadFileName
                                                            : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.pinTopicList[index].uploadFileName}'),
                                                    backgroundColor:
                                                        Colors.grey.shade100,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                  visible: widget
                                                      .forumList.likePosts,
                                                  child: new Container(
                                                    width: 70.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            "0xFFECF1F5")),
                                                        border: Border.all(
                                                          color:
                                                              InsColor(appBloc)
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
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  bottom: 1.0),
                                                          icon: Icon(
                                                            Icons.thumb_up,
                                                            size: 16.0,
                                                            color: Color(int.parse(
                                                                "0xFF1D293F")),
                                                          ),
                                                          onPressed: () {
                                                            discussionTopicBloc
                                                                    .pinTopicList[
                                                                        index]
                                                                    .likeState
                                                                ? discussionTopicBloc
                                                                    .add(
                                                                        LikeDisLikeEvent(
                                                                    strObjectID: discussionTopicBloc
                                                                        .pinTopicList[
                                                                            index]
                                                                        .contentID,
                                                                    intTypeID:
                                                                        1,
                                                                    blnIsLiked:
                                                                        false,
                                                                  ))
                                                                : discussionTopicBloc
                                                                    .add(
                                                                        LikeDisLikeEvent(
                                                                    strObjectID: discussionTopicBloc
                                                                        .pinTopicList[
                                                                            index]
                                                                        .contentID,
                                                                    intTypeID:
                                                                        1,
                                                                    blnIsLiked:
                                                                        true,
                                                                  ));
                                                          },
                                                        ),
                                                        Text(
                                                          discussionTopicBloc
                                                                          .pinTopicList[
                                                                              index]
                                                                          .likes ==
                                                                      null ||
                                                                  discussionTopicBloc
                                                                          .pinTopicList[
                                                                              index]
                                                                          .likes ==
                                                                      0
                                                              ? '0'
                                                              : discussionTopicBloc
                                                                  .pinTopicList[
                                                                      index]
                                                                  .likes
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF1D293F")),
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              new Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: new Container(
                                                    width: 70.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            "0xFFECF1F5")),
                                                        border: Border.all(
                                                          color:
                                                              InsColor(appBloc)
                                                                  .appTextColor
                                                                  .withAlpha(0),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: new Row(children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => DiscussionForumCommentList(
                                                                      forumList:
                                                                          widget
                                                                              .forumList,
                                                                      topicList:
                                                                          discussionTopicBloc
                                                                              .pinTopicList[index]))).then(
                                                              (value) => {
                                                                    if (value ??
                                                                        true)
                                                                      {
                                                                        refresh()
                                                                      }
                                                                  });
                                                        },
                                                        padding:
                                                            new EdgeInsets.only(
                                                                bottom: 1.0),
                                                        icon: Icon(
                                                          Icons.comment,
                                                          size: 16.0,
                                                          color: Color(int.parse(
                                                              "0xFF1D293F")),
                                                        ),
                                                      ),
                                                      Text(
                                                        discussionTopicBloc
                                                            .pinTopicList[index]
                                                            .noOfReplies
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(int.parse(
                                                                "0xFF1D293F")),
                                                            fontSize: 10),
                                                      ),
                                                    ])),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: new GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) => AddComment(
                                                                  forumList: widget
                                                                      .forumList,
                                                                  topicList: discussionTopicBloc
                                                                          .pinTopicList[
                                                                      index])))
                                                          .then((value) {
                                                        refresh();
                                                      });
                                                    },
                                                    child: Text(
                                                      'Add Comment',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                                    ),
                                                  ))
                                            ],
                                          ))
                                    ],
                                  )
                                ],
                              )));
                    })
              ],
            ),
          ),
        )
      ],
    );
  }

  void _settingTopinBottomSheet(context, ForumList forumList, TopicList topicList, int index) {
    print("mY User id:${appBloc.userid}");
    print("Created User id:${topicList.createdUserID}");

    showModalBottomSheet(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: InsColor(appBloc).appBGColor,
            child: new Wrap(
              children: <Widget>[
                BottomSheetDragger(),
                Visibility(
                  visible: topicList.createdUserID.toString() == appBloc.userid,
                  child: ListTile(
                      leading: new Icon(
                        Icons.edit,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                      title: new Row(
                        children: [
                          new Text(
                            'Edit',
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                          new Spacer(),
                          new Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          )
                        ],
                      ),
                      onTap: () => {
                            Navigator.of(context).pop(true),
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => EditTopic(
                                          forumList: forumList,
                                          topicList: topicList,
                                        )))
                                .then((value) {
                              if (value ?? true) {
                                refresh();
                              }
                            })
                          }),
                ),
                Visibility(
                    visible: widget.forumList.allowPin ? true : false,
                    child: new ListTile(
                      leading: new Icon(
                        Icons.push_pin,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                      title: new Row(
                        children: [
                          new Text(
                            'Pin',
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                          new Spacer(),
                          new Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          )
                        ],
                      ),
                      onTap: () => {
                        Navigator.of(context).pop(true),
                        if (index < discussionTopicBloc.pinTopicList.length)
                          {
                            discussionTopicBloc.list.removeAt(index),
                          },
                        discussionTopicBloc.add(PinTopicEvent(
                            forumID: forumList.forumID,
                            strContentID: topicList.contentID,
                            isPin: true)),
                      },
                    )),
                ListTile(
                  leading: new Icon(
                    Icons.message,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                  title: new Row(
                    children: [
                      new Text(
                        'Add Comment',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                      ),
                      new Spacer(),
                      new Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      )
                    ],
                  ),
                  onTap: () => {
                    Navigator.of(context).pop(true),
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddComment(
                                forumList: forumList, topicList: topicList)))
                        .then((value) {
                      if (value) {
                        refresh();
                      }
                    })
                  },
                ),
                Visibility(
                    visible: widget.forumList.allowShare ? true : false,
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
                                forumList.forumID.toString(),
                                topicList.contentID)))
                      },
                    )),
                Visibility(
                    visible: widget.forumList.allowShare ? true : false,
                    child: new ListTile(
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
                                topicList.contentID,
                                forumList.forumID.toString())));
                      },
                    )),
                Visibility(
                  visible: topicList.createdUserID.toString() == appBloc.userid,
                  child: ListTile(
                    leading: new Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: new Row(
                      children: [
                        new Text(
                          'Delete',
                          style: new TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    onTap: () => {
                      // AlertDialog
                      Navigator.of(context).pop(true),
                      showAlertDialog(context, forumList, topicList, index,
                          discussionTopicBloc.list)
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _settingUnPinTopinBottomSheet(context, ForumList forumList, TopicList topicList, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
            bloc: discussionTopicBloc,
            listener: (context, state) {
              if (state.status == Status.COMPLETED) {}
            },
            builder: (context, state) {
              if (state.status == Status.LOADING && discussionTopicBloc.isFirstLoading == true) {
                return Center(
                  child: AbsorbPointer(
                    child: SpinKitCircle(
                      color: Colors.black54,
                      size: 70.0,
                    ),
                  ),
                );
              }
              else {
                return Container(
                  color: InsColor(appBloc).appBGColor,
                  child: new Wrap(
                    children: <Widget>[
                      BottomSheetDragger(),
                      Visibility(
                        visible: topicList.createdUserID.toString() == appBloc.userid,
                        child: new ListTile(
                            leading: new Icon(
                              Icons.edit,
                              color: InsColor(appBloc).appIconColor,
                            ),
                            title: new Row(
                              children: [
                                new Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: InsColor(appBloc).appTextColor),
                                ),
                                new Spacer(),
                                new Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: InsColor(appBloc).appIconColor,
                                ),
                              ],
                            ),
                            onTap: () => {
                                  Navigator.of(context).pop(true),
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => EditTopic(
                                                forumList: forumList,
                                                topicList: topicList,
                                              )))
                                      .then((value) {
                                    if (value) {
                                      refresh();
                                    }
                                  })
                                }),
                      ),
                      ListTile(
                        leading: Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: new Icon(
                            Icons.push_pin,
                            color: InsColor(appBloc).appIconColor,
                          ),
                        ),
                        title: new Row(
                          children: [
                            new Text(
                              'UnPin',
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                            ),
                            new Spacer(),
                            new Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: InsColor(appBloc).appIconColor,
                            )
                          ],
                        ),
                        onTap: () => {
                          Navigator.of(context).pop(true),
                          discussionTopicBloc.add(PinTopicEvent(
                              forumID: forumList.forumID,
                              strContentID: topicList.contentID,
                              isPin: false)),
                          // if(discussionTopicBloc.pinTopicList.length!=0){
                          //   discussionTopicBloc.list.removeAt(index)
                          // }
                        },
                      ),
                      ListTile(
                        leading: new Icon(
                          Icons.message,
                          color: InsColor(appBloc).appIconColor,
                        ),
                        title: new Row(
                          children: [
                            new Text(
                              'Add Comment',
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                            ),
                            new Spacer(),
                            new Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: InsColor(appBloc).appIconColor,
                            )
                          ],
                        ),
                        onTap: () => {
                          Navigator.of(context).pop(true),
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AddComment(
                                      forumList: forumList,
                                      topicList: topicList)))
                              .then((value) {
                            if (value) {
                              refresh();
                            }
                          })
                        },
                      ),
                      ListTile(
                        leading: new Icon(
                            IconDataSolid(
                              int.parse('0xf079'),
                            ),
                            color: InsColor(appBloc).appIconColor),
                        title: new Text(
                          'Share with People',
                          style:
                              TextStyle(color: InsColor(appBloc).appTextColor),
                        ),
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareMainScreen(
                                  true,
                                  true,
                                  false,
                                  forumList.forumID.toString(),
                                  topicList.contentID)))
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          IconDataSolid(int.parse('0xf1e0')),
                          color: InsColor(appBloc).appIconColor,
                        ),
                        title: new Text(
                          'Share with Connection',
                          style:
                              TextStyle(color: InsColor(appBloc).appTextColor),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareWithConnections(
                                  true,
                                  false,
                                  topicList.contentID,
                                  forumList.forumID.toString())));
                        },
                      ),
                      Visibility(
                        visible: topicList.createdUserID.toString() == appBloc.userid,
                        child: ListTile(
                          leading: new Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          title: new Row(
                            children: [
                              new Text(
                                'Delete',
                                style: new TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: () => {
                            // AlertDialog
                            Navigator.of(context).pop(true),
                            showAlertDialog(
                                _scaffoldkey.currentContext!,
                                forumList,
                                topicList,
                                index,
                                discussionTopicBloc.pinTopicList)
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        });
  }

  void _settingModalBottomSheet(context, ForumList forumList) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                BottomSheetDragger(),
                new ListTile(
                    leading: new Icon(Icons.edit),
                    title: new Row(
                      children: [
                        new Text('Edit'),
                        new Spacer(),
                        new Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.message),
                  title: new Row(
                    children: [
                      new Text('Add Topic'),
                      new Spacer(),
                      new Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddTopic(
                              forumList: ForumList.fromJson({}),
                            )))
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.share),
                  title: new Row(
                    children: [
                      new Text('Share'),
                      new Spacer(),
                      new Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                  onTap: () => {},
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: new Row(
                    children: [
                      new Text(
                        'Delete',
                        style: new TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
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

  Widget customFloatingAction() {
    return new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add_circle),
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => CreateDiscussion()));
        });
  }

  showAlertDialog(BuildContext context, ForumList forumList,
      TopicList topicList, int index, List<TopicList> list) {
    // Create button
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    Widget deleteButton = FlatButton(
      child: Text(
        "Yes, delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
        discussionTopicBloc.add(DeleteForumTopicEvent(
            topicID: topicList.contentID,
            forumID: forumList.forumID,
            forumName: forumList.name));
        discussionTopicBloc.list.removeAt(index);
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
        "Are you sure you want to delete this topic?",
        style: Theme.of(context)
            .textTheme
            .headline2
            ?.apply(color: InsColor(appBloc).appTextColor),
      ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: _scaffoldkey.currentContext!,
      builder: (BuildContext builderContext) {
        return alert;
      },
    );
  }

  void refresh() {
    discussionTopicBloc.add(GetDiscussionTopicDetails(forumId: widget.forumList.forumID));
  }

  void countRefresh(int index) {
    discussionTopicBloc.add(LikeCountEvent(
      strObjectID: discussionTopicBloc.list[index].contentID,
      intTypeID: 1,
    ));
  }
}
