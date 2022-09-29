import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_comment_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_comment_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_comment_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_comment_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/app_colors.dart';

class AddComment extends StatefulWidget {
  final ForumList forumList;
  final TopicList topicList;

  AddComment({Key? key, required this.forumList, required this.topicList})
      : super(key: key);

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;

  TextEditingController ctrTopic = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();

  late DiscussionTopicCommentBloc discussionTopicCommentBloc;
  late DiscussionTopicBloc discussionTopicBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discussionTopicBloc = DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());

    // createDiscussionBloc = BlocProvider.of<CreateDiscussionBloc>(context);
    discussionTopicCommentBloc = DiscussionTopicCommentBloc(
        discussionTopicCommentRepositry:
            DiscussionTopicCommentRepositoryBuilder.repository());

    discussionTopicCommentBloc.add(GetDiscussionTopicCommentListDetails(
        forumID: widget.forumList.forumID,
        topicID: widget.topicList.contentID));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Add Comment',
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
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
                  child: SingleChildScrollView(
                    child: mainWidget(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: addCommentButton())
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                    child: Text.rich(
                      TextSpan(
                        text: "Comment ",
                        style: TextStyle(color: AppColors.getAppTextColor(), fontSize: 18),
                        children: [
                          TextSpan(
                            text: "*",
                            style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                          ),
                        ]
                      ),
                    ),
                  ),
                  Container(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 400.0,
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _validate
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,

                          child: TextFormField(
                            style: TextStyle(
                              color: AppColors.getAppTextColor(),
                            ),
                            focusNode: reqFocusTitle,
                            controller: ctrTopic,
                            minLines: 10,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => ctrTopic.text = val ?? "",
                            onChanged: (val) {
                              setState(() {});
                            },
                            validator: (String? text) {
                              return (text?.isNotEmpty ?? false)
                                  ? null
                                  : "*required";
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.getTextFieldHintColor(),
                              ),
                              hintText: 'Enter your comment here..',
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: const BorderRadius.all(const Radius.circular(5)),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDADCE0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            ),
                            maxLines: null,
                          ),

                          // child: TextFormField(
                          //   style: TextStyle(
                          //       fontSize: 14.h,
                          //       color: Color(int.parse(
                          //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          //   focusNode: reqFocusTitle,
                          //   controller: ctrTopic,
                          //   textInputAction: TextInputAction.next,
                          //   onSaved: (val) => ctrTopic.text = val,
                          //   onChanged: (val) {
                          //     setState(() {});
                          //   },
                          //   decoration: InputDecoration(
                          //     hintStyle: TextStyle(
                          //         color: Color(int.parse(
                          //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          //     hintText: 'Enter your comment here..',
                          //     contentPadding: new EdgeInsets.symmetric(
                          //         vertical: 45.0, horizontal: 20.0),
                          //     enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: InsColor(appBloc).appTextColor)),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: InsColor(appBloc).appTextColor)),
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8.0)),
                          //   ),
                          //   maxLines: null,
                          // ),
                        )),
                  ),
                  Visibility(
                      visible: widget.forumList.attachFile ? true : false,
                      child: supportDocument()),
                  // settings(),
                  // privacy()
                ])),
      ],
    );
  }

  Widget supportDocument() {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    return BlocConsumer<DiscussionTopicCommentBloc,
        DiscussionTopicCommentState>(
      bloc: discussionTopicCommentBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                child: new Text(
                  'Attachment',
                  style: new TextStyle(
                    fontSize: 18.0,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                ),
              ),
              SizedBox(
                width: useMobileLayout
                    ? double.infinity
                    : MediaQuery.of(context).size.width / 3,
                child: RaisedButton(
                  padding: const EdgeInsets.all(15.0),
                  onPressed: () {
                    if (discussionTopicCommentBloc.fileBytes == null) {
                      discussionTopicCommentBloc.add(
                          OpenFileExplorerEvent(FileType.image));
                    }
                  },
                  color: discussionTopicCommentBloc.fileBytes != null
                      ? Colors.grey
                      : Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  textColor: InsColor(appBloc).appBtnTextColor,
                  elevation: 5,
                  child:
                      const Text('Upload File', style: TextStyle(fontSize: 20)),
                ),
              ),
              Visibility(
                visible: (discussionTopicCommentBloc.fileName.isNotEmpty),
                child: SizedBox(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 5.0, right: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discussionTopicCommentBloc.fileName,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    discussionTopicCommentBloc.fileBytes != null
                                        ? '${(discussionTopicCommentBloc.fileBytes!.length / 1024).toStringAsFixed(0)}kb'
                                        : '',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              )),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                discussionTopicCommentBloc.fileName = "";
                                discussionTopicCommentBloc.fileBytes = null;
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget addCommentButton() {
    return BlocConsumer<DiscussionTopicCommentBloc, DiscussionTopicCommentState>(
      bloc: discussionTopicCommentBloc,
      listener: (context, state) {
        if (state is GetDiscussionTopicCommentDetailsState) {
          if (state.status == Status.LOADING) {
            /*return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.h,
                ),
              ),
            );*/
          }
          else if (state.status == Status.COMPLETED) {
            MyPrint.printOnConsole('aaaaaa : ${state.data.split('#')[2]}');
            discussionTopicBloc.add(UploadAttachmentEvent(
              topicID: widget.topicList.contentID,
              replyID: state.data.split('#')[2],
              isTopic: false,
              fileName: discussionTopicCommentBloc.fileName,
              fileBytes: discussionTopicCommentBloc.fileBytes,
            ));
            Navigator.of(context).pop(true);
          }
          else if (state.status == Status.ERROR) {
            FToast flutterToast = FToast();
            flutterToast.init(context);

            flutterToast.showToast(
              child: CommonToast(
                displaymsg: state.message,
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING) {
          return Align(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.h,
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                padding: const EdgeInsets.all(15.0),
                onPressed: () {
                  validate();
                },
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                textColor: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                elevation: 5,
                child:
                    const Text('Add Comment', style: TextStyle(fontSize: 20)),
              ),
            ),
          );
        }
      },
    );
  }

  void validate() {
    discussionTopicCommentBloc.isFirstLoading = true;
    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
//      showLoading();

      FocusScope.of(context).unfocus();

      discussionTopicCommentBloc.add(GetDiscussionTopicCommentDetails(
        topicID: widget.topicList.contentID,
        topicName: widget.topicList.name,
        forumID: widget.forumList.forumID,
        forumTitle: widget.forumList.name,
        message: ctrTopic.text,
        strAttachFil: discussionTopicCommentBloc.fileName,
        strReplyID: '',
        fileBytes: discussionTopicCommentBloc.fileBytes,
        fileName: discussionTopicCommentBloc.fileName,
      ));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
