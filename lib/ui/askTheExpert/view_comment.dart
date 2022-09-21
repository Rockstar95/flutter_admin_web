import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/answers_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/view_comment_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/Viewimagenew.dart';

import '../../configs/constants.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';
import 'edit_answer_comment.dart';

class ViewComments extends StatefulWidget {
  final Table1 table1;

  const ViewComments(this.table1);

  @override
  State<ViewComments> createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    // final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Comment',
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
          child: Column(
            children: [
              const Divider(
                height: 2,
                color: Colors.black87,
              ),
              Expanded(child: userComments()),
            ],
          )),
    );
  }

  Widget userComments() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }

        if (state is LikeDislikeState && state.status == Status.COMPLETED) {
          refresh();
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING &&
            askTheExpertBloc.isQuestionFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        } else if (askTheExpertBloc.commentList.length == 0) {
          return noDataFound(true);
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: askTheExpertBloc.commentList.length,
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                  itemBuilder: (context, index) {
                    CommentList comment = askTheExpertBloc.commentList[index];
                    print(
                        "userCommentImagePath:${comment.userCommentImagePath}");

                    print(
                        "LoggedIn User id:${appBloc.userid}, Comment UserId:${comment.commentUserID}");

                    return GestureDetector(
                      onTap: () => {
                        //openDiscussionTopic(index),
                      },
                      child: Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      image: askTheExpertBloc
                                                  .commentList[index].picture !=
                                              ""
                                          ? NetworkImage(askTheExpertBloc
                                                  .commentList[index].picture
                                                  .startsWith("http")
                                              ? askTheExpertBloc
                                                  .commentList[index].picture
                                              : ApiEndpoints.strSiteUrl + askTheExpertBloc.commentList[index].picture)
                                          : const AssetImage(
                                              'assets/user.png',
                                            ) as ImageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 1.0),
                                        child: Text(
                                            askTheExpertBloc.commentList[index]
                                                .commentedUserName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.apply(
                                                    color: InsColor(appBloc)
                                                        .appTextColor))),
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 1.0,
                                          ),
                                          child: Text(
                                              ' commented ${askTheExpertBloc
                                                      .commentList[index]
                                                      .commentedDate}',
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  ?.apply(
                                                      color: InsColor(appBloc)
                                                          .appTextColor))),
                                    )
                                  ],
                                )),
                                Visibility(
                                  visible: appBloc.userid ==
                                      comment.commentUserID.toString(),
                                  child: IconButton(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: InsColor(appBloc).appIconColor,
                                    ),
                                    onPressed: () {
                                      _settingModalBottomSheet(context, index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 15.0),
                                    child: Text(
                                        askTheExpertBloc.commentList[index]
                                            .commentDescription,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.apply(
                                                color: InsColor(appBloc)
                                                    .appTextColor
                                                    .withOpacity(0.5)))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                                  child: askTheExpertBloc.commentList[index]
                                          .userCommentImagePath.isNotEmpty
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundColor: const Color(0xffFDCF09),
                                          child: InkWell(
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                  askTheExpertBloc
                                                          .commentList[index]
                                                          .userCommentImagePath
                                                          .startsWith("http")
                                                      ? askTheExpertBloc
                                                          .commentList[index]
                                                          .userCommentImagePath
                                                      : ApiEndpoints.strSiteUrl + askTheExpertBloc.commentList[index].userCommentImagePath),
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                            ),
                                            onTap: () {
                                              //sreekanth commented
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewImageNew(
                                                              askTheExpertBloc
                                                                  .commentList[
                                                                      index]
                                                                  .userCommentImagePath))).then(
                                                  (value) {
                                                /*if (value ?? true) {
                                                      refresh();
                                                    }*/
                                              });
                                            },
                                          ),
                                        )
                                      : Container(),

                                  /* askTheExpertBloc
                                        .commentList[index].userCommentImagePath.isNotEmpty ?CircleAvatar(
                                        radius: 12,
                                        backgroundImage: NetworkImage(
                                            '${ApiEndpoints.strSiteUrl +  askTheExpertBloc
                                                .commentList[index].userCommentImagePath}')): Container(),*/
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        !askTheExpertBloc
                                                .commentList[index].isLiked
                                            ? askTheExpertBloc
                                                .add(LikeDisLikeEvent(
                                                strObjectID: askTheExpertBloc
                                                    .commentList[index]
                                                    .commentID
                                                    .toString(),
                                                intTypeID: 4,
                                                blnIsLiked: true,
                                              ))
                                            : askTheExpertBloc
                                                .add(LikeDisLikeEvent(
                                                strObjectID: askTheExpertBloc
                                                    .commentList[index]
                                                    .commentID
                                                    .toString(),
                                                intTypeID: 4,
                                                blnIsLiked: false,
                                              ));
                                      },
                                      padding: const EdgeInsets.only(
                                          bottom: 1.0, left: 5),
                                      icon: Icon(Icons.thumb_up,
                                          size: 16.0,
                                          color: askTheExpertBloc
                                                          .commentList[index]
                                                          .isLiked ==
                                                      null ||
                                                  !askTheExpertBloc
                                                      .commentList[index]
                                                      .isLiked
                                              ? Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              : Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
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
                          fontSize: 24),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  void refresh() {
    askTheExpertBloc.add(ViewCommentEvent(
        commentID: widget.table1.questionID,
        responseID: widget.table1.responseID));
  }

  void _settingModalBottomSheet(context, index) {
    showModalBottomSheet(
        shape: AppConstants().bottomSheetShapeBorder(),
        context: context,
        builder: (BuildContext bc) {
          return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
              bloc: askTheExpertBloc,
              listener: (context, state) {
                if (state.status == Status.COMPLETED) {}
              },
              builder: (context, state) {
                return AppConstants().bottomSheetContainer(
                  child: Wrap(
                    children: <Widget>[
                      const BottomSheetDragger(),
                      BottomsheetOptionTile(
                        iconData:Icons.edit,
                        text:'Edit',
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => EditAnswerComment(
                                      askTheExpertBloc.commentList[index])))
                              .then((value) {
                            if (value ?? true) {
                              refresh();
                            }
                          })
                        },
                      ),
                      BottomsheetOptionTile(
                        iconData: Icons.delete,
                          text:'Delete',
                        onTap: () => {showAlertDialog(context, index)},
                      ),
                    ],
                  ),
                );
              });
        });
  }

  showAlertDialog(BuildContext context, int index) {
    // Create button
    Widget cancelButton = FlatButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    Widget deleteButton = FlatButton(
      child: const Text(
        "Yes, delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
        askTheExpertBloc.add(DeleteCommentEvent(
            commentId: askTheExpertBloc.commentList[index].commentID));
        askTheExpertBloc.commentList.removeAt(index);
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
        "Are you sure you want to delete this comment?",
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
}
