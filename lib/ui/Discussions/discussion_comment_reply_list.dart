import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../../configs/constants.dart';

class DiscussionCommentReplyList extends StatefulWidget {
  final int commentId;

  DiscussionCommentReplyList({Key? key, required this.commentId})
      : super(key: key);

  @override
  _DiscussionCommentReplyListState createState() =>
      _DiscussionCommentReplyListState();
}

class _DiscussionCommentReplyListState extends State<DiscussionCommentReplyList>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  late DiscussionTopicBloc discussionTopicBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  Fluttertoast? flutterToast;

  String removeAllHtmlTags(String htmlText) {
    String parsedString = "";

    var document = parse(htmlText);

    parsedString = parse(document.body?.text ?? "").documentElement?.text ?? "";

    return parsedString;
  }

  @override
  void initState() {
    discussionTopicBloc = DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());

    discussionTopicBloc.add(TopicReplyEvent(commentId: widget.commentId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Reply',
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
    return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
        bloc: discussionTopicBloc,
        listener: (context, state) {
          if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.LOADING &&
              discussionTopicBloc.isFirstLoading == true) {
            return Center(
              child: AbsorbPointer(
                child: AppConstants().getLoaderWidget(iconSize: 70)
              ),
            );
          } else if (discussionTopicBloc.replyList.isEmpty) {
            return noDataFound(true);
          } else {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  itemCount: discussionTopicBloc.replyList.length,
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: discussionTopicBloc.replyList[index]
                                                .replyProfile !=
                                            ""
                                        ? NetworkImage(discussionTopicBloc
                                                .replyList[index].replyProfile
                                                .startsWith('http')
                                            ? discussionTopicBloc
                                                .replyList[index].replyProfile
                                            : '${ApiEndpoints.strSiteUrl + discussionTopicBloc.replyList[index].replyProfile}')
                                        : const AssetImage(
                                            'assets/user.gif',
                                          ) as ImageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0)),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Text(
                                          discussionTopicBloc
                                                  .replyList[index].replyBy +
                                              ' replied ' +
                                              discussionTopicBloc
                                                  .replyList[index]
                                                  .dtPostedDate,
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10.0),
                                        child: Text(
                                          removeAllHtmlTags(discussionTopicBloc
                                              .replyList[index].message),
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                  .withOpacity(0.5),
                                              fontSize: 16.0),
                                        )),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    size: 18.0,
                                  ),
                                  onPressed: () {
                                    showAlertDialog(context, index);
                                  })
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
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
        : Container();
  }

  showAlertDialog(BuildContext context, int index) {
    // Create button
    Widget deleteButton = FlatButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.of(context).pop(true);
        discussionTopicBloc.add(DeleteReplyEvent(
            replyID: discussionTopicBloc.replyList[index].replyID));
        discussionTopicBloc.replyList.removeAt(index);
      },
    );

    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(true);
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
        "Are you sure you want to delete this reply?",
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
}
