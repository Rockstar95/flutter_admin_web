import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/askTheExpert/view_comment.dart';
import 'package:flutter_admin_web/ui/common/Viewimagenew.dart';

import '../../configs/constants.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';
import 'add_answer.dart';
import 'add_answer_comment.dart';

class ViewAnswers extends StatefulWidget {
  final QuestionList questionList;

  const ViewAnswers(this.questionList);

  @override
  State<ViewAnswers> createState() => _ViewAnswersState();
}

class _ViewAnswersState extends State<ViewAnswers> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;

  bool pageMounted = false, isGetAnswersDone = false, isUpdateViewDone = false;

  @override
  void initState() {
    super.initState();
    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    // final double itemWidth = size.width / 2;

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'View Answers',
          style: TextStyle(
              fontSize: 20,
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
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const Divider(
                    height: 2,
                    color: Colors.black87,
                  ),
                  userQuestion(),
                  const Divider(
                    height: 2,
                    color: Colors.black87,
                  ),
                  userAnswersListWidget()
                ],
              ),
            ),
          )),
    );
  }

  Widget userAnswersListWidget() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }

        if (state is AnswersListState && state.status == Status.COMPLETED) {
          print(
              "Got Answers List:${askTheExpertBloc.answersResponse.table1.length}");
          widget.questionList.answers =
              askTheExpertBloc.answersResponse.table1.length.toString();
          if (pageMounted) setState(() {});
        }
        if ((state is UpAndDownVoteState || state is DeleteUserResponseState) &&
            state.status == Status.COMPLETED) {
          refresh();
        }
      },
      builder: (context, state) {
        //print("State:${state.runtimeType}, \nStatus:${state.status}");

        if (state is ViewQuestionState) isUpdateViewDone = true;
        if (state is AnswersListState) isGetAnswersDone = true;

        //if (state.status == Status.LOADING/* && askTheExpertBloc.isFirstLoading == true*/) {
        if (!isGetAnswersDone || !isUpdateViewDone) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        }
        else if (askTheExpertBloc.answersResponse.table1.isEmpty) {
          return noDataFound(true);
        }
        else {
          return Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: askTheExpertBloc.answersResponse.table1.length,
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {
                      // openDiscussionTopic(index),
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: askTheExpertBloc.answersResponse
                                                .table1[index].picture !=
                                            ""
                                        ? NetworkImage(askTheExpertBloc
                                                .answersResponse
                                                .table1[index]
                                                .picture
                                                .startsWith('http')
                                            ? askTheExpertBloc.answersResponse
                                                .table1[index].picture
                                            : ApiEndpoints.strSiteUrl + askTheExpertBloc.answersResponse.table1[index].picture)
                                        : const AssetImage(
                                            'assets/user.gif',
                                          ) as ImageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0)),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10.0),
                                      child: Text(
                                        askTheExpertBloc.answersResponse
                                            .table1[index].respondedUserName,
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Text(
                                        askTheExpertBloc
                                            .answersResponse.table1[index].days,
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                            fontSize: 10.0),
                                      ))
                                ],
                              )),
                              IconButton(
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
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10.0, right: 10.0),
                                child: Html(
                                    data: askTheExpertBloc.answersResponse
                                            .table1[index].response,
                                    style: {
                                      "body": Style(
                                          color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          fontSize:
                                              FontSize(ScreenUtil().setSp(14))),
                                    }),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 10, left: 10.0),
                              //   child: askTheExpertBloc
                              //           .answersResponse
                              //           .table1[index]
                              //           .userResponseImagePath
                              //           .isNotEmpty
                              //       ? CircleAvatar(
                              //           radius: 10,
                              //           backgroundColor: Color(0xffFDCF09),
                              //           child: CircleAvatar(
                              //             radius: 10,
                              //             backgroundImage: NetworkImage(
                              //                 '${ApiEndpoints.strSiteUrl + askTheExpertBloc.answersResponse.table1[index].userResponseImagePath}'),
                              //             backgroundColor: Colors.grey.shade100,
                              //           ),
                              //         )
                              //       : Container(),
                              //
                              //   /* askTheExpertBloc.answersResponse
                              //         .table1[index].userResponseImagePath
                              //         .isNotEmpty
                              //         ? CircleAvatar(
                              //         radius: 12,
                              //         backgroundImage: NetworkImage(
                              //             '${ApiEndpoints.strSiteUrl +
                              //                 askTheExpertBloc.answersResponse
                              //                     .table1[index]
                              //                     .userResponseImagePath}'))*/
                              //   //  : Container(),
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10.0),
                                child: InkWell(
                                  child: askTheExpertBloc
                                          .answersResponse
                                          .table1[index]
                                          .userResponseImagePath
                                          .isNotEmpty
                                      ? Container(
                                          width: 20.0,
                                          height: 20.0,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7c94b6),
                                            image: DecorationImage(
                                              image: askTheExpertBloc
                                                          .answersResponse
                                                          .table1[index]
                                                          .userResponseImagePath !=
                                                      ""
                                                  ? NetworkImage(askTheExpertBloc
                                                          .answersResponse
                                                          .table1[index]
                                                          .userResponseImagePath
                                                          .startsWith('http')
                                                      ? askTheExpertBloc
                                                          .answersResponse
                                                          .table1[index]
                                                          .userResponseImagePath
                                                      : ApiEndpoints.strSiteUrl + askTheExpertBloc.answersResponse.table1[index].userResponseImagePath)
                                                  : const AssetImage(
                                                      'assets/user.gif',
                                                    ) as ImageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                                const Radius.circular(50.0)),
                                          ),
                                        )
                                      : Container(),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewImageNew(
                                                askTheExpertBloc
                                                    .answersResponse
                                                    .table1[index]
                                                    .userResponseImagePath))).then(
                                        (value) {
                                      /*if (value ?? true) {
                                            refresh();
                                          }*/
                                    });
                                  },
                                ),

                                /* askTheExpertBloc.answersResponse
                                      .table1[index].userResponseImagePath
                                      .isNotEmpty
                                      ? CircleAvatar(
                                      radius: 12,
                                      backgroundImage: NetworkImage(
                                          '${ApiEndpoints.strSiteUrl +
                                              askTheExpertBloc.answersResponse
                                                  .table1[index]
                                                  .userResponseImagePath}'))*/
                                //  : Container(),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 0.0),
                                        child: Container(
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
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                onPressed: () {
                                                  askTheExpertBloc.add(
                                                      UpAndDownVoteEvent(
                                                          askTheExpertBloc
                                                              .answersResponse
                                                              .table1[index]
                                                              .responseID
                                                              .toString(),
                                                          3,
                                                          true));
                                                },
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.0),
                                                icon: Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  size: 16.0,
                                                  color: askTheExpertBloc
                                                              .strUserID ==
                                                          askTheExpertBloc
                                                              .answersResponse
                                                              .table1[index]
                                                              .respondedUserID
                                                              .toString()
                                                      ? Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                      : Color(int.parse(
                                                          "0xFF1D293F")),
                                                ),
                                              ),
                                              Text(
                                                askTheExpertBloc.answersResponse
                                                    .table1[index].upvotesCount
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(
                                                      int.parse("0xFF1D293F")),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          width: 50.0,
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
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  askTheExpertBloc.add(
                                                      UpAndDownVoteEvent(
                                                          askTheExpertBloc
                                                              .answersResponse
                                                              .table1[index]
                                                              .responseID
                                                              .toString(),
                                                          3,
                                                          false));
                                                },
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.0),
                                                icon: Icon(
                                                  Icons.thumb_down_alt_outlined,
                                                  size: 16.0,
                                                  color: Color(
                                                      int.parse("0xFF1D293F")),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Container(
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
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewComments(askTheExpertBloc
                                                                      .answersResponse
                                                                      .table1[
                                                                  index]))).then(
                                                      (value) {
                                                    if (value ?? true) {
                                                      refresh();
                                                    }
                                                  });
                                                },
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.0),
                                                icon: Icon(
                                                  Icons.message,
                                                  color: Color(
                                                      int.parse("0xFF1D293F")),
                                                  size: 16.0,
                                                ),
                                              ),
                                              Text(
                                                askTheExpertBloc.answersResponse
                                                    .table1[index].commentCount
                                                    .toString()
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
                                      Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddAnswerComment(
                                                            askTheExpertBloc
                                                                .answersResponse
                                                                .table1[index],
                                                          ))).then((value) {
                                                if (value) {
                                                  refresh();
                                                }
                                              });
                                            },
                                            child: const Text(
                                              'Add Comment',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ),
                                          ))
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }

  Widget userQuestion() {
    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    image: widget.questionList.userQuestionImagePath != ""
                        ? NetworkImage(widget.questionList.userQuestionImagePath
                                .startsWith('http')
                            ? widget.questionList.userQuestionImagePath
                            : ApiEndpoints.strSiteUrl + widget.questionList.userQuestionImagePath)
                        : const AssetImage(
                            'assets/user.gif',
                          ) as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10.0),
                      child: Text(
                        widget.questionList.userQuestion,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        '${DateTime.now()
                                .difference(askTheExpertBloc.formatter
                                    .parse(widget.questionList.postedDate))
                                .inDays} Days',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 10.0),
                      ))
                ],
              )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                child: Html(
                    data: widget.questionList.userQuestionDescription,
                    style: {
                      "body": Style(
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5),
                          fontSize: FontSize(ScreenUtil().setSp(14))),
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: questionCategories(widget.questionList.questionCategories.split(',')),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20.0),
                  child: Text(
                    'Asked by: ${widget.questionList.userName} | Asked on: ${widget.questionList.postedDate} | Last Active: ${widget.questionList.postedDate}',
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 70.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                              color: Color(int.parse("0xFFECF1F5")),
                              border: Border.all(
                                color:
                                    InsColor(appBloc).appTextColor.withAlpha(0),
                              ),
                              borderRadius:
                                  const BorderRadius.all(const Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .push(
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ViewAnswers(
                                  //                 widget.questionList)));
                                },
                                padding: const EdgeInsets.only(bottom: 1.0),
                                icon: Icon(
                                  Icons.question_answer,
                                  size: 16.0,
                                  color: Color(int.parse("0xFF1D293F")),
                                ),
                              ),
                              Text(
                                widget.questionList.answers,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(int.parse("0xFF1D293F")),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          width: 70.0,
                          height: 25.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(int.parse("0xFFECF1F5")),
                              border: Border.all(
                                color:
                                    InsColor(appBloc).appTextColor.withAlpha(0),
                              ),
                              borderRadius:
                                  const BorderRadius.all(const Radius.circular(20))),
                          child: Row(
                            children: [
                              IconButton(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                onPressed: () {},
                                padding: const EdgeInsets.only(bottom: 1.0),
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Color(int.parse("0xFF1D293F")),
                                  size: 16.0,
                                ),
                              ),
                              Text(
                                widget.questionList.views.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(int.parse("0xFF1D293F")),
                                ),
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
    askTheExpertBloc.isFirstLoading = false;
    isUpdateViewDone = false;
    isUpdateViewDone = false;
    if (pageMounted) setState(() {});

    askTheExpertBloc
        .add(AnswersListEvent(3510, 161, widget.questionList.questionID));
    askTheExpertBloc
        .add(ViewQuestionEvent(questionID: widget.questionList.questionID));
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
                      Visibility(
                          visible: askTheExpertBloc.answersResponse
                                      .table1[index].respondedUserName ==
                                  askTheExpertBloc.strUserName
                              ? true
                              : false,
                          child: BottomsheetOptionTile(
                            iconData: Icons.edit,
                            text: 'Edit',
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => AddAnswer(
                                            answerList: askTheExpertBloc
                                                .answersResponse.table1[index],
                                            isEdit: true,
                                            questionList: QuestionList(),
                                          )))
                                  .then((value) {
                                if (value) {
                                  refresh();
                                }
                              })
                            },
                          )),
                      BottomsheetOptionTile(
                        iconData: Icons.message,
                        text: 'Add Comment',
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddAnswerComment(
                                      askTheExpertBloc.answersResponse
                                          .table1[index]))).then((value) {
                            if (value) {
                              refresh();
                            }
                          })
                        },
                      ),
                      BottomsheetOptionTile(
                        iconData: IconDataSolid(
                            int.parse('0xf079'),
                          ),
                        text: 'Share with People',
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareMainScreen(
                                  true,
                                  false,
                                  true,
                                  askTheExpertBloc
                                      .answersResponse.table1[index].questionID
                                      .toString(),
                                  askTheExpertBloc
                                      .answersResponse.table1[index].response)))
                        },
                      ),
                      BottomsheetOptionTile(
                        iconData: IconDataSolid(int.parse('0xf1e0')),
                        text: 'Share with Connection',
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareWithConnections(
                                  false,
                                  true,
                                  widget.questionList.userQuestion,
                                  widget.questionList.questionID.toString())));
                        },
                      ),
                      Visibility(
                          visible: askTheExpertBloc.answersResponse
                                      .table1[index].respondedUserName ==
                                  askTheExpertBloc.strUserName
                              ? true
                              : false,
                          child: BottomsheetOptionTile(
                            iconData: Icons.delete,
                            text: 'Delete',
                            onTap: () => {showAlertDialog(context, index)},
                          )),
                    ],
                  ),
                );
              });
        });
  }

  Widget questionCategories(List<String> questionCategories) {
    var _crossAxisSpacing = 8;

    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 3;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 30;
    // var _aspectRatio = _width / cellHeight;

    return Wrap(
      children: List.generate(questionCategories.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Visibility(
            visible: questionCategories[index].trim().isEmpty ? false : true,
            child: Container(
              //height: 10.0,
              decoration: BoxDecoration(
                  color: Color(int.parse("0xFFECF1F5")),
                  border: Border.all(
                    color: InsColor(appBloc).appTextColor.withAlpha(0),
                  ),
                  borderRadius: const BorderRadius.all(const Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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

    /*return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 6,
            crossAxisCount: _crossAxisCount,
            childAspectRatio: _aspectRatio),
        itemCount: questionCategories == null ? 0 : questionCategories.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Visibility(
                visible:
                    questionCategories[index].trim().isEmpty ? false : true,
                child: new Container(
                  height: 10.0,
                  decoration: BoxDecoration(
                      color: Color(int.parse("0xFFECF1F5")),
                      border: Border.all(
                        color: InsColor(appBloc).appTextColor.withAlpha(0),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Text(questionCategories[index],
                          style: TextStyle(
                              color: Color(int.parse("0xFF1D293F")),
                              fontSize: 9.0),
                          textAlign: TextAlign.center)),
                ),
              ));
        });*/
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
        style: const TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
        askTheExpertBloc.add(DeleteUserResponseEvent(
            responseId:
                askTheExpertBloc.answersResponse.table1[index].responseID,
            userResponseImage: ''));
        //refresh();
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
        "Are you sure you want to delete this answer?",
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
