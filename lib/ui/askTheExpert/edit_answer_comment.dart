import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/view_comment_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class EditAnswerComment extends StatefulWidget {
  final CommentList table;

  EditAnswerComment(this.table);

  @override
  _EditAnswerCommentState createState() => _EditAnswerCommentState();
}

class _EditAnswerCommentState extends State<EditAnswerComment>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController ctrComment = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;

  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    ctrComment.text = widget.table.commentDescription;

    askTheExpertBloc = new AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    askTheExpertBloc.fileName = widget.table.commentImage != ''
        ? widget.table.commentImage.split('/').reversed.first
        : "";
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
          'Edit Comment',
          style: TextStyle(
              fontSize: 20,
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
                        top: 0.0, left: 10.0, right: 10.0, bottom: 20.0),
                    child: createAnswerButton())
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
                        child: new Text(
                          'Comment',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      new TextFormField(
                        style: TextStyle(
                            color: InsColor(appBloc).appTextColor,
                            fontSize: 14.h),
                        focusNode: reqFocusTitle,
                        controller: ctrComment,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrComment.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your comment here..',
                          hintStyle: TextStyle(
                            color: InsColor(appBloc).appTextColor,
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 45.0, horizontal: 20.0),
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
                      ),
                      supportDocument(),
                    ]))),
      ],
    );
  }

  Widget supportDocument() {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
        bloc: askTheExpertBloc,
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
                    'Support Documents (Optional)',
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                ),
                new Container(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(
                      onPressed: () => {
                            askTheExpertBloc.filePath.isEmpty
                                ? askTheExpertBloc.add(OpenFileExplorerTopicEvent(FileType.image))
                                : null
                          },
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text(
                        'Upload File',
                        style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                      ),
                      textColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                ),
                Visibility(
                  visible: (askTheExpertBloc.filePath.isNotEmpty),
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
                                      askTheExpertBloc.fileName,
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    new Text(
                                      askTheExpertBloc.filePath.isNotEmpty && File(askTheExpertBloc.filePath).existsSync()
                                          ? (File(askTheExpertBloc.filePath).lengthSync() / 1024).toStringAsFixed(0) + 'kb'
                                          : '',
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )),
                          ),
                          new IconButton(
                              onPressed: () {
                                setState(() {
                                  askTheExpertBloc.fileName = "";
                                  askTheExpertBloc.filePath = "";
                                });
                              },
                              icon: Icon(Icons.delete,
                                  color: InsColor(appBloc).appTextColor)),
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

  Widget createAnswerButton() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state is AddAnswerCommentState) {
          if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Comment Edited successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
          } else if (state.status == Status.ERROR) {
            flutterToast.showToast(
              child: CommonToast(
                displaymsg: state.data,
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
          return Container(
            alignment: Alignment.bottomCenter,
            child: new Row(
              children: [
                new Expanded(
                    child: MaterialButton(
                        onPressed: () => {
                              validateAddCommentForm(widget.table),
                            },
                        minWidth: MediaQuery.of(context).size.width,
                        disabledColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5),
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        child: Text('Submit'),
                        textColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
              ],
            ),
          );
        }
      },
    );
  }

  void validateAddCommentForm(CommentList table) {
    var filepath = askTheExpertBloc.filePath;
    var fileName = askTheExpertBloc.fileName;

    var titleNameVar = ctrComment.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please enter comment'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }
    askTheExpertBloc.add(AddAnswerCommentEvent(
        table.commentQuestionID,
        table.commentResponseID,
        table.commentID.toString(),
        titleNameVar,
        fileName,
        0,
        false,
        filepath,
        fileName));
  }
}
