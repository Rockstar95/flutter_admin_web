import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_topic_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class AddTopic extends StatefulWidget {
  final ForumList forumList;

  AddTopic({Key? key, required this.forumList}) : super(key: key);

  @override
  _AddTopicState createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController ctrTopicTitle = TextEditingController();
  TextEditingController ctrTopicDesc = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();
  FocusNode reqFocusDescription = FocusNode();

  late DiscussionTopicBloc discussionTopicBloc;

  late FToast flutterToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    discussionTopicBloc = DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Create Topic',
          style: TextStyle(
              fontSize: 18,
              color: AppColors.getAppHeaderTextColor()),
        ),
        backgroundColor: AppColors.getAppHeaderColor(),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.getAppHeaderTextColor()),
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
        color:  AppColors.getAppHeaderColor(),
        child: Stack(
          children: <Widget>[
            new Column(
              children: [
                new Expanded(
                  child: SingleChildScrollView(
                    child: mainWidget(context, itemWidth, itemHeight),
                  ),
                ),
                new Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: createTopicButton())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget mainWidget(BuildContext context, double itemWidth, double itemHeight) {
    return new Column(
      children: [
        new Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: new Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: Text.rich(
                          TextSpan(
                            text: "Title ",
                            style: TextStyle(color: AppColors.getAppTextColor()),
                            children: [
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                              ),
                            ]
                          ),
                        ),
                      ),
                      new TextFormField(
                        style: TextStyle(
                          color: AppColors.getAppTextColor(),
                        ),
                        focusNode: reqFocusTitle,
                        controller: ctrTopicTitle,
                        minLines: 3,
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrTopicTitle.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: AppColors.getTextFieldHintColor(),
                          ),
                          hintText: 'Enter your topic here..',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFFDADCE0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(
                              color: AppColors.getAppTextColor(),
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: new Text(
                          'Description',
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: AppColors.getAppTextColor().withOpacity(0.54),
                              letterSpacing:  0.9
                          ),
                        ),
                      ),
                      Container(
                        child: new ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 400.0,
                          ),
                          child: TextFormField(
                            minLines: 10,
                            style: TextStyle(
                              color: AppColors.getAppTextColor(),
                            ),
                            focusNode: reqFocusDescription,
                            controller: ctrTopicDesc,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => ctrTopicDesc.text = val ?? "",
                            onChanged: (val) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: AppColors.getTextFieldHintColor()),
                              hintText: 'Enter your description here..',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Color(0xFFDADCE0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),

                      Visibility(
                          visible: (widget.forumList.attachFile) ? true : false,
                          child: supportDocument()),
                      // settings(),
                      // privacy()
                    ]))),
      ],
    );
  }

  Widget supportDocument() {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
        bloc: discussionTopicBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return new Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                  child: new Text(
                    'Thumbnail',
                    style: new TextStyle(
                      fontSize: 14.0,
                        color: AppColors.getAppTextColor().withOpacity(0.54),
                      letterSpacing:  0.9
                    ),
                  ),
                ),
                new SizedBox(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(
                      padding: EdgeInsets.all(15.0),
                      onPressed: () {
                        if (discussionTopicBloc.filePath.isEmpty) {
                          discussionTopicBloc.add(
                              OpenFileExplorerTopicEvent(FileType.image));
                        }
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                      color: discussionTopicBloc.filePath.isNotEmpty
                          ? Colors.grey
                          : Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text('Upload File'),
                      textColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                ),
                Visibility(
                  visible: (discussionTopicBloc.fileName.isNotEmpty && discussionTopicBloc.fileName != '...'),
                  child: Container(
                    width: useMobileLayout
                        ? double.infinity
                        : MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 10.0, bottom: 10.0),
                      child: new Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: InsColor(appBloc).appTextColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text(
                                    discussionTopicBloc.fileName,
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        color: InsColor(appBloc).appTextColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  new Text(
                                    discussionTopicBloc.filePath.isNotEmpty && File(discussionTopicBloc.filePath).existsSync()
                                        ? (File(discussionTopicBloc.filePath).lengthSync() / 1024).toStringAsFixed(0) + 'kb'
                                        : '',
                                    style: new TextStyle(
                                        fontSize: 12.0,
                                        color: InsColor(appBloc).appTextColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new IconButton(
                              onPressed: () {
                                setState(() {
                                  discussionTopicBloc.fileName = "";
                                  discussionTopicBloc.filePath = "";
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: InsColor(appBloc).appTextColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget createTopicButton() {
    return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
      bloc: discussionTopicBloc,
      listener: (context, state) {
        if (state is AddTopicState) {
          if (state.status == Status.COMPLETED) {
            //print('aaaaaa : ' + state.data.split('#')[2]);
            if (state.data.contains('exist')) {
              flutterToast.showToast(
                  child: CommonToast(displaymsg: 'Topic is already Created'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 4));
            }
            discussionTopicBloc.add(UploadAttachmentEvent(
              topicID: state.data.split('#')[2],
              replyID: '',
              isTopic: true,
              fileName: discussionTopicBloc.fileName,
              filePath: discussionTopicBloc.filePath,
            ));
            Navigator.of(context).pop(true);
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Topic Created Successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
          } else if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }

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
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.h,
              ),
            ),
          );
        }
        else {
          return Align(
            alignment: Alignment.bottomCenter,
            child: new SizedBox(
              width: double.infinity,
              child: MaterialButton(
                  padding: EdgeInsets.all(15.0),
                  onPressed: () {
                    validateAddTopicForm();
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  disabledColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                      .withOpacity(0.5),
                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text('Create Topic'),
                  textColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          );
        }
      },
    );
  }

  void validateAddTopicForm() {
    var titleNameVar = ctrTopicTitle.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Enter title name'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }
    discussionTopicBloc.add(AddTopicEvent(
      strAttachFile: discussionTopicBloc.fileName,
      orgID: widget.forumList.siteID,
      forumID: widget.forumList.forumID,
      strContentID: "",
      description: ctrTopicDesc.text,
      title: ctrTopicTitle.text,
      forumName: widget.forumList.name,
    ));
  }
}
