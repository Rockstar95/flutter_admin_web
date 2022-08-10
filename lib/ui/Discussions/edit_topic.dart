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
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/app_colors.dart';

class EditTopic extends StatefulWidget {
  final ForumList forumList;
  final TopicList topicList;

  EditTopic({Key? key, required this.forumList, required this.topicList})
      : super(key: key);

  @override
  _EditTopicState createState() => _EditTopicState();
}

class _EditTopicState extends State<EditTopic>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;

  TextEditingController ctrTopicTitle = TextEditingController();
  TextEditingController ctrTopicDesc = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();
  FocusNode reqFocusDescription = FocusNode();

  late DiscussionTopicBloc discussionTopicBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ctrTopicTitle.text = widget.topicList.name;
    ctrTopicDesc.text = widget.topicList.longDescription;

    discussionTopicBloc = DiscussionTopicBloc(
        discussionTopicRepositry:
            DiscussionTopicRepositoryBuilder.repository());

    print("File Name:${widget.topicList.uploadFileName}");
    if (widget.topicList.uploadFileName != '') {
      discussionTopicBloc.fileName =
          widget.topicList.uploadFileName.split('/').reversed.first.toString();
      discussionTopicBloc.fileName = discussionTopicBloc.fileName
          .substring(discussionTopicBloc.fileName.indexOf("_") + 1);
    } else {
      discussionTopicBloc.fileName = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Edit Topic',
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
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: Stack(
          children: <Widget>[
            Divider(
              height: 2,
              color: Colors.black87,
            ),
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
                autovalidateMode: _validate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: new Text(
                          'Title',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      new TextFormField(
                        style: TextStyle(
                            fontSize: 14.h,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        focusNode: reqFocusTitle,
                        controller: ctrTopicTitle,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrTopicTitle.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        validator: (String? val) =>
                            (val?.isNotEmpty ?? false) ? null : "*required",
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: AppColors.getTextFieldHintColor(),),
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
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                          // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),

                          contentPadding: new EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: new Text(
                          'Description (Optional)',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      Container(
                        child: new ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 400.0,
                          ),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 14.h,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            focusNode: reqFocusDescription,
                            controller: ctrTopicDesc,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => ctrTopicDesc.text = val ?? "",
                            onChanged: (val) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.getTextFieldHintColor(),
                              ),
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
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 45.0, horizontal: 20.0),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),

                      supportDocument(),
                      // settings(),
                      // privacy()
                    ]))),
      ],
    );
  }

  Widget supportDocument() {
    return BlocConsumer<DiscussionTopicBloc, DiscussionTopicState>(
        bloc: discussionTopicBloc,
        listener: (context, state) {},
        builder: (context, state) {
          print(
              "discussionTopicBloc.fileName:'${discussionTopicBloc.fileName}'");

          return new Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                  child: new Text(
                    'Support Documentss (Optional)',
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                ),
                new SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    onPressed: () {
                      if (discussionTopicBloc.fileName.isEmpty ||
                              discussionTopicBloc.fileName == '...') {
                        discussionTopicBloc
                            .add(OpenFileExplorerTopicEvent(FileType.image));
                      }
                    },
                    child: const Text('Upload File',
                        style: TextStyle(fontSize: 20)),
                    color: discussionTopicBloc.fileName.isNotEmpty &&
                            discussionTopicBloc.fileName != '...'
                        ? Colors.grey
                        : Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    textColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    elevation: 5,
                  ),
                ),
                Visibility(
                  visible: (discussionTopicBloc.fileName.isNotEmpty &&
                      discussionTopicBloc.fileName != '...'),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, left: 5.0, right: 10.0, bottom: 10.0),
                    child: new Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
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
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.normal),
                                ),
                                new Text(
                                  discussionTopicBloc.filePath.isNotEmpty &&
                                          discussionTopicBloc.filePath != "..."
                                      ? (File(discussionTopicBloc.filePath)
                                                      .lengthSync() /
                                                  1024)
                                              .toStringAsFixed(0) +
                                          'kb'
                                      : '',
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
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
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            )),
                      ],
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
        if (state is EditTopicState) {
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
            if (discussionTopicBloc.filePath.isNotEmpty) {
              discussionTopicBloc.add(UploadAttachmentEvent(
                topicID: widget.topicList.contentID,
                replyID: "",
                isTopic: true,
                fileName: discussionTopicBloc.fileName,
                filePath: discussionTopicBloc.filePath,
              ));
            }
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
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.h,
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.bottomCenter,
            child: new SizedBox(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () {
                  validateAddTopicForm();
                },
                child:
                    const Text('Update Topic', style: TextStyle(fontSize: 20)),
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                textColor: Colors.white,
                elevation: 5,
              ),
            ),
          );
        }
      },
    );
  }

  void validateAddTopicForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      discussionTopicBloc.add(EditTopicEvent(
        strAttachFile: discussionTopicBloc.fileName,
        orgID: widget.forumList.siteID,
        forumID: widget.forumList.forumID,
        strContentID: widget.topicList.contentID,
        description: ctrTopicDesc.text,
        title: ctrTopicTitle.text,
        forumName: widget.forumList.name,
      ));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
