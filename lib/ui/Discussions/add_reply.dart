import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_comment_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_comment_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_comment_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_comment_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';

class AddReply extends StatefulWidget {
  final ForumList forumList;
  final TopicList topicList;
  final int commentId;

  AddReply(
      {Key? key,
      required this.forumList,
      required this.topicList,
      this.commentId = 0})
      : super(key: key);

  @override
  _AddReplyState createState() => _AddReplyState();
}

class _AddReplyState extends State<AddReply> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;

  TextEditingController ctrReply = TextEditingController();

  FocusNode reqFocusReply = FocusNode();

  late DiscussionTopicCommentBloc discussionTopicCommentBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      resizeToAvoidBottomInset: true,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Add Reply',
          style: TextStyle(
              fontSize: 18,
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: mainWidget(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: addReplyButton())
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
                    padding: EdgeInsets.only(
                        top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                    child: Text.rich(
                      TextSpan(
                        text: "Reply ",
                        style: TextStyle(
                          color: AppColors.getAppTextColor(),
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: "*",
                            style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                          ),
                        ]
                      ),
                    ),
                    /*child: new Text(
                      'REPLY',
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getAppTextColor().withOpacity(.54)),
                    ),*/
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _validate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: TextFormField(
                        style: TextStyle(
                            color: AppColors.getAppTextColor(),
                            fontSize: 14.h),
                        focusNode: reqFocusReply,
                        controller: ctrReply,
                        keyboardType: TextInputType.multiline,
                        onSaved: (val) => ctrReply.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          hintStyle: TextStyle(
                            color: AppColors.getTextFieldHintColor(),
                          ),
                          hintText: 'Enter your reply here..',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color(0xFFDADCE0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        maxLines: null,
                        minLines: 10,
                      ),
                    ),
                  ),
                ],
            ),
        ),
      ],
    );
  }

  Widget addReplyButton() {
    return BlocConsumer<DiscussionTopicCommentBloc,
        DiscussionTopicCommentState>(
      bloc: discussionTopicCommentBloc,
      listener: (context, state) {
        if (state is GetDiscussionTopicReplyDetailsState) {
          if (state.status == Status.LOADING) {
            /*return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.h,
                ),
              ),
            );*/
          } else if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
          } else if (state.status == Status.ERROR) {
            FToast flutterToast = FToast();
            flutterToast.init(context);

            flutterToast.showToast(
              child: CommonToast(
                displaymsg: state.message,
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: Duration(seconds: 2),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING) {
          return Align(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        } else {
          return Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () {
                  validate();
                },
                child: const Text('Add Reply', style: TextStyle(fontSize: 20)),
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                textColor: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                elevation: 5,
              ),
            ),
          );
        }
      },
    );
  }

  void validate() {
    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
//      showLoading();

      FocusScope.of(context).unfocus();

      discussionTopicCommentBloc.add(GetDiscussionTopicCommentReplyEvent(
          strCommentID: widget.commentId,
          topicID: discussionTopicCommentBloc.list[0].topicid,
          forumID: widget.forumList.forumID,
          involvedUserIDList: "",
          topicName: widget.topicList.name,
          strAttachFile: "",
          message: ctrReply.text,
          strReplyID: "-1",
          forumTitle: widget.forumList.name,
          strCommentTxt: discussionTopicCommentBloc.list[0].message));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
