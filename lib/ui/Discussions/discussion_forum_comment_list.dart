import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_main_home_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_main_home_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_main_home_state.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_comment_reply_list.dart';
import 'package:flutter_admin_web/ui/common/Viewimagenew.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';
import 'add_reply.dart';

class DiscussionForumCommentList extends StatefulWidget {
  final ForumList forumList;
  final TopicList topicList;
  final String contentID;

  DiscussionForumCommentList({
    Key? key,
    required this.forumList,
    required this.topicList,
    this.contentID = "",
  }) : super(key: key);

  @override
  _DiscussionForumCommentListState createState() =>
      _DiscussionForumCommentListState();
}

class _DiscussionForumCommentListState extends State<DiscussionForumCommentList> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  Color _iconColor = Colors.black;
  TabController? _tabController;
  List<Tab> tabList = [];

  late DiscussionMainHomeBloc discussionMainHomeBloc;
  late DiscussionTopicBloc discussionTopicBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late FToast flutterToast;

  @override
  void initState() {
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabAllDiscussion,
    // ));
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabMyDiscussion,
    // ));
    discussionMainHomeBloc = DiscussionMainHomeBloc(
        discussionMainHomeRepositry:
            DiscussionMainHomeRepositoryBuilder.repository());
    discussionTopicBloc = DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());
    refresh();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (widget.contentID.contains('&;')) {
        discussionMainHomeBloc.discussionCommentList.forEach((element) {
          if (element.commentid == int.parse(widget.contentID.split('&;')[2])) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiscussionCommentReplyList(
                            commentId:
                                int.parse(widget.contentID.split('&;')[2]))))
                .then((value) => {
                      // if (value) {widget.contentID = ''}
                    });
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Comments',
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
            const Divider(
              height: 2,
              color: Colors.black87,
            ),
            Column(
              children: [
                Expanded(
                  child: mainWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainWidget() {
    return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
      bloc: discussionMainHomeBloc,
      listener: (context, state) {
        if (state is DeleteCommentState) {
          if (state.status == Status.COMPLETED) {
            flutterToast.showToast(
                child:
                    CommonToast(displaymsg: 'Comment Deleted Successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4));
          }
        }

        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
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
        else if (discussionMainHomeBloc.discussionCommentList.isEmpty) {
          return noDataFound(true);
        }
        else {
          return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
            bloc: discussionTopicBloc,
            listener: (context, state) {
              if (state is LikeDislikeState && state.status == Status.COMPLETED) {
                refresh();
              }

              if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                if (state.message == "401") {
                  AppDirectory.sessionTimeOut(context);
                }
              }
            },
            builder: (context, state) {
              return Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                    itemCount: discussionMainHomeBloc.discussionCommentList.length,
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                        ),
                    itemBuilder: (context, index) {
                      print("appBloc.userid:'${appBloc.userid}', discussionMainHomeBloc.discussionCommentList[index].postedby:'${discussionMainHomeBloc.discussionCommentList[index].postedby.toString()}'");
                      print("comparison:'${appBloc.userid == discussionMainHomeBloc.discussionCommentList[index].postedby.toString()}'");

                      return Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: discussionMainHomeBloc
                                                  .discussionCommentList[
                                                      index]
                                                  .commentUserProfile !=
                                              ""
                                          ? NetworkImage(discussionMainHomeBloc
                                                  .discussionCommentList[
                                                      index]
                                                  .commentUserProfile
                                                  .startsWith('http')
                                              ? discussionMainHomeBloc
                                                  .discussionCommentList[
                                                      index]
                                                  .commentUserProfile
                                              : '${ApiEndpoints.strSiteUrl + discussionMainHomeBloc.discussionCommentList[index].commentUserProfile}')
                                          : const AssetImage(
                                              'assets/user.png',
                                            ) as ImageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(50.0)),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Text(
                                            discussionMainHomeBloc
                                                .discussionCommentList[index]
                                                .commentedBy,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 10.0),
                                          child: Html(
                                              shrinkWrap: true,
                                              data: discussionMainHomeBloc
                                                  .discussionCommentList[
                                                      index]
                                                  .message,
                                              style: {
                                                "body": Style(
                                                    color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5),
                                                    fontSize: FontSize(
                                                        ScreenUtil()
                                                            .setSp(16))),
                                              })
                                          // child: new Text(
                                          //   discussionMainHomeBloc
                                          //       .discussionCommentList[index]
                                          //       .message,
                                          //   style: new TextStyle(
                                          //       color: Color(int.parse(
                                          //               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                          //           .withOpacity(0.5),
                                          //       fontSize: 16.0),
                                          // )
                                          ),
                                      discussionMainHomeBloc
                                                  .discussionCommentList[
                                                      index]
                                                  .commentFileUploadPath !=
                                              ""
                                          ? InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, left: 18.0),
                                                child: Container(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  padding:
                                                      const EdgeInsets.all(20.0),
                                                  decoration:
                                                      BoxDecoration(
                                                    color: const Color(
                                                        0xff7c94b6),
                                                    image:
                                                        DecorationImage(
                                                      image: NetworkImage(discussionMainHomeBloc
                                                              .discussionCommentList[
                                                                  index]
                                                              .commentFileUploadPath
                                                              .startsWith(
                                                                  'http')
                                                          ? discussionMainHomeBloc
                                                              .discussionCommentList[
                                                                  index]
                                                              .commentFileUploadPath
                                                          : '${ApiEndpoints.strSiteUrl + discussionMainHomeBloc.discussionCommentList[index].commentFileUploadPath}'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            const Radius
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
                                                                discussionMainHomeBloc
                                                                    .discussionCommentList[
                                                                        index]
                                                                    .commentFileUploadPath))).then(
                                                    (value) {
                                                  if (value ?? true) {
                                                    refresh();
                                                  }
                                                });
                                              },
                                            )
                                          : Container(),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                  visible: widget
                                                          .forumList.likePosts
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    width: 70.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            "0xFFECF1F5")),
                                                        border: Border.all(
                                                          color: InsColor(
                                                                  appBloc)
                                                              .appTextColor
                                                              .withAlpha(0),
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                const Radius
                                                                    .circular(
                                                                        20))),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            discussionMainHomeBloc
                                                                    .discussionCommentList[
                                                                        index]
                                                                    .likeState
                                                                ? discussionTopicBloc
                                                                    .add(
                                                                        LikeDisLikeEvent(
                                                                    strObjectID: discussionMainHomeBloc
                                                                        .discussionCommentList[
                                                                            index]
                                                                        .commentid
                                                                        .toString(),
                                                                    intTypeID:
                                                                        2,
                                                                    blnIsLiked:
                                                                        false,
                                                                  ))
                                                                : discussionTopicBloc
                                                                    .add(
                                                                        LikeDisLikeEvent(
                                                                    strObjectID: discussionMainHomeBloc
                                                                        .discussionCommentList[
                                                                            index]
                                                                        .commentid
                                                                        .toString(),
                                                                    intTypeID:
                                                                        2,
                                                                    blnIsLiked:
                                                                        true,
                                                                  ));
                                                          },
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom:
                                                                      1.0),
                                                          icon: Icon(
                                                            Icons.thumb_up,
                                                            size: 16.0,
                                                            color: discussionMainHomeBloc
                                                                        .discussionCommentList[
                                                                            index]
                                                                        .commentLikes ==
                                                                    0
                                                                ? Color(int.parse(
                                                                    "0xFF1D293F"))
                                                                : Color(int.parse(
                                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                          ),
                                                        ),
                                                        Text(
                                                          discussionMainHomeBloc
                                                              .discussionCommentList[
                                                                  index]
                                                              .commentLikes
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color(
                                                                int.parse(
                                                                    "0xFF1D293F")),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Container(
                                                    width: 70.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            "0xFFECF1F5")),
                                                        border: Border.all(
                                                          color: InsColor(
                                                                  appBloc)
                                                              .appTextColor
                                                              .withAlpha(0),
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                const Radius
                                                                    .circular(
                                                                        20))),
                                                    child: Row(children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => DiscussionCommentReplyList(
                                                                      commentId: discussionMainHomeBloc
                                                                          .discussionCommentList[
                                                                              index]
                                                                          .commentid))).then(
                                                              (value) {
                                                            if (value ??
                                                                true) {
                                                              refresh();
                                                            }
                                                          });
                                                        },
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 1.0),
                                                        icon: Icon(
                                                          Icons.reply,
                                                          color: Color(int.parse(
                                                              "0xFF1D293F")),
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        discussionMainHomeBloc
                                                            .discussionCommentList[
                                                                index]
                                                            .commentRepliesCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                int.parse(
                                                                    "0xFF1D293F")),
                                                            fontSize: 10),
                                                      ),
                                                    ])),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) => AddReply(
                                                                  forumList:
                                                                      widget
                                                                          .forumList,
                                                                  topicList:
                                                                      widget
                                                                          .topicList,
                                                                  commentId: discussionMainHomeBloc
                                                                      .discussionCommentList[
                                                                          index]
                                                                      .commentid)))
                                                          .then((value) {
                                                        if (value) {
                                                          refresh();
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Add reply',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .lightBlueAccent),
                                                    ),
                                                  ))
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: appBloc.userid ==
                                            discussionMainHomeBloc
                                                .discussionCommentList[index]
                                                .postedby
                                                .toString()
                                        ? true
                                        : false,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                        onPressed: () {
                                          showAlertDialog(context, index);
                                        }))
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
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
        : Container();
  }

  void refresh() {
    discussionMainHomeBloc.add(GetDiscussionForumCommentEvent(
        forumId: widget.forumList.forumID,
        topicID: widget.topicList.contentID));
  }

  showAlertDialog(BuildContext context, int index) {
    // Create button
    Widget deleteButton = FlatButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    Widget cancelButton = FlatButton(
      child: const Text(
        "Yes, delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        discussionMainHomeBloc.add(DeleteCommentEvent(
            topicID: widget.topicList.contentID,
            forumID: widget.forumList.forumID,
            replyID: discussionMainHomeBloc.discussionCommentList[index].replyID,
            topicName: widget.topicList.name,
            noOfReplies: (widget.topicList.noOfReplies - 1),
            lastPostedDate: discussionMainHomeBloc.discussionCommentList[index].posteddate,
            createdUserID: discussionMainHomeBloc.discussionCommentList[index].postedby,
            attachmentPath: ""));
        discussionMainHomeBloc.discussionCommentList.removeAt(index);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      title: Text(
        "Confirm",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      content: Text("Are you sure you want to delete this comment?",
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
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
}
