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
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_topic_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_topic_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_topic_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussionTopic/discussion_topic_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';
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
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

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
            const Divider(
              height: 2,
              color: Colors.black87,
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: mainWidget(context, itemWidth, itemHeight),
                  ),
                ),
                Padding(
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
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: Form(
                key: _formKey,
                autovalidateMode: _validate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: Text(
                          'Title',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      TextFormField(
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
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
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

                          // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),

                          contentPadding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: Text(
                          'Description (Optional)',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      Container(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
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
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
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
                              contentPadding: const EdgeInsets.symmetric(
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
          MyPrint.printOnConsole("discussionTopicBloc.fileName:'${discussionTopicBloc.fileName}'");

          return Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    'Support Documentss (Optional)',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(15.0),
                    onPressed: () {
                      if (discussionTopicBloc.fileName.isEmpty ||
                              discussionTopicBloc.fileName == '...') {
                        discussionTopicBloc
                            .add(OpenFileExplorerTopicEvent(FileType.image));
                      }
                    },
                    color: discussionTopicBloc.fileName.isNotEmpty &&
                            discussionTopicBloc.fileName != '...'
                        ? Colors.grey
                        : Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    textColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    elevation: 5,
                    child: const Text('Upload File',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Visibility(
                  visible: (discussionTopicBloc.fileName.isNotEmpty &&
                      discussionTopicBloc.fileName != '...'),
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
                                  discussionTopicBloc.fileName,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  discussionTopicBloc.fileBytes != null
                                      ? (discussionTopicBloc.fileBytes!.length / 1024).toStringAsFixed(0) + 'kb'
                                      : '',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                discussionTopicBloc.fileName = "";
                                discussionTopicBloc.fileBytes = null;
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
            if (discussionTopicBloc.fileBytes != null) {
              discussionTopicBloc.add(UploadAttachmentEvent(
                topicID: widget.topicList.contentID,
                replyID: "",
                isTopic: true,
                fileName: discussionTopicBloc.fileName,
                fileBytes: discussionTopicBloc.fileBytes,
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
              toastDuration: const Duration(seconds: 2),
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
                padding: const EdgeInsets.all(15.0),
                onPressed: () {
                  validateAddTopicForm();
                },
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                textColor: Colors.white,
                elevation: 5,
                child:
                    const Text('Update Topic', style: TextStyle(fontSize: 20)),
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
