import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:html_editor/html_editor.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/share_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/share_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/share_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/app_colors.dart';

class ShareMainScreen extends StatefulWidget {
  final bool isPeople;
  final bool isFromForum;
  final bool isFromQuestion;
  final String contentName;
  final String contententId;

  const ShareMainScreen(
    this.isPeople,
    this.isFromForum,
    this.isFromQuestion,
    this.contententId,
    this.contentName,
  );

  @override
  State<ShareMainScreen> createState() => _ShareMainScreenState();
}

class _ShareMainScreenState extends State<ShareMainScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  ShareBloc get shareBloc => BlocProvider.of<ShareBloc>(context);

  TextEditingController toController = new TextEditingController();
  late TextEditingController subjectController;
  late TextEditingController messagetoController;
  late FToast flutterToast;
  String msgString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messagetoController = new TextEditingController(
        text: widget.isFromForum
            ? 'I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your YouTube site! \n\nContent Name: ${widget.contentName}. \n\n Content Link: ${ApiEndpoints.mainSiteURL}/ForumID/${widget.contententId}/TopicId/${widget.contentName}'
            : widget.isFromQuestion
                ? 'I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your YouTube site! \n\nContent Name: ${widget.contentName}. \n\n Content Link: ${ApiEndpoints.mainSiteURL}/User-Questions-List/QuestionID/${widget.contententId}'
                : 'I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your YouTube site! \n\nContent Name: ${widget.contentName}. \n\n Content Link: ${ApiEndpoints.mainSiteURL}/InviteURLID/contentId/${widget.contententId}/ComponentId/1.');
    subjectController = new TextEditingController(text: widget.contentName);

    setState(() {
      msgString =
          "I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your YouTube site! \n\nContent Name: ${widget.contentName}. \n\n Content Link: ${ApiEndpoints.mainSiteURL}/InviteURLID/contentId/${widget.contententId}/ComponentId/1.";
    });
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    flutterToast = FToast();
    flutterToast.init(context);
    // GlobalKey<HtmlEditorState> keyEditor = GlobalKey();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      appBar: AppBar(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        title: Text(
          widget.isPeople ? "Share with People" : "Share with Connections",
          style: TextStyle(
            fontSize: 18,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
        ),
        elevation: 2,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
        ),
      ),
      body: Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: Stack(
          children: <Widget>[
            BlocConsumer<ShareBloc, ShareState>(
              bloc: shareBloc,
              listener: (context, state) {
                if (state is SendMailToPeopleState) {
                  if (state.status == Status.COMPLETED) {
                    flutterToast.showToast(
                      child: CommonToast(displaymsg: 'Email successfully sent'),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 2),
                    );
                    Navigator.pop(context);
                    /*if (widget.isConnection) {
                      Navigator.pop(context);
                    } else {

                    }*/
                  } else if (state.status == Status.ERROR) {
                    flutterToast.showToast(
                      child: CommonToast(displaymsg: 'Server Error - 500'),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 2),
                    );
                  }
                }
              },
              builder: (context, state) {
                return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widget.isPeople
                                  ? Text(
                                      "To :",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                    )
                                  : Container(),
                              widget.isPeople
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : Container(),
                              widget.isPeople
                                  ? TextField(
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                      maxLines: useMobileLayout ? 2 : 4,
                                      controller: toController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter email addresses separated by a comma(,) and no spaces',
                                        hintStyle: TextStyle(
                                            color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                                .withOpacity(0.7)),
//                                          fillColor: Colors.white70,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                            color: AppColors.getTextFieldBorderColor(),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: AppColors.getTextFieldBorderColor(),
                                              width: 2),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Subject :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLines: useMobileLayout ? 2 : 4,
                                style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                                controller: subjectController,
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.7),
                                  ),
//                                    fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: AppColors.getTextFieldBorderColor(),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: AppColors.getTextFieldBorderColor(),
                                        width: 2),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Message :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                ),
                                controller: messagetoController,
                                minLines: useMobileLayout ? 5 : 10,
                                //Normal textInputField will be displayed
                                maxLines: useMobileLayout ? 10 : 16,
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                        .withOpacity(0.7),
                                  ),
//                                    fillColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                      color: AppColors.getTextFieldBorderColor(),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: AppColors.getTextFieldBorderColor(),
                                        width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    (state.status == Status.LOADING)
                        ? Align(
                            alignment: Alignment.center,
                            child: AbsorbPointer(
                              child: SpinKitCircle(
                                color: Colors.grey,
                                size: 70,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      disabledColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.5),
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text(
                          appBloc
                              .localstr.discussionforumActionsheetCanceloption,
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      disabledColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.5),
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text(appBloc.localstr.detailsButtonSubmitbutton,
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                      onPressed: () async {
                        /* final txt = await keyEditor.currentState.getText();
                        flutterToast.showToast(
                          child: CommonToast(displaymsg: txt),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );*/
                        if (widget.isPeople) {
                          if (getEmailvalidate(toController.text.toString())) {
                            if (subjectController.text.toString() != "") {
                              if (messagetoController.text.toString() != "") {
                                shareBloc.add(SendMailToPeopleEvent(
                                    toEmail: toController.text.toString(),
                                    subject: subjectController.text.toString(),
                                    message:
                                        messagetoController.text.toString(),
                                    isPeople: widget.isPeople,
                                    isFromForm: widget.isFromForum,
                                    isFromQuestion: widget.isFromQuestion,
                                    emailList: "",
                                    contentid: widget.contententId));
                              } else {
                                flutterToast.showToast(
                                  child:
                                      CommonToast(displaymsg: 'Enter Message'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                              }
                            } else {
                              flutterToast.showToast(
                                child: CommonToast(displaymsg: 'Enter Subject'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 2),
                              );
                            }
                          } else {
                            flutterToast.showToast(
                              child:
                                  CommonToast(displaymsg: 'Enter Valid Email'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                          }
                        } else {
                          if (subjectController.text.toString() != "") {
                            if (messagetoController.text.toString() != "") {
                              print(
                                  "Selected Connections:${shareBloc.selectedconnectionlist}");
                              shareBloc.add(SendMailToPeopleEvent(
                                  toEmail: "",
                                  subject:
                                      subjectController.text.trim().toString(),
                                  message: messagetoController.text.toString(),
                                  isPeople: widget.isPeople,
                                  isFromForm: widget.isFromForum,
                                  isFromQuestion: widget.isFromQuestion,
                                  emailList: formatString(
                                      shareBloc.selectedconnectionlist),
                                  contentid: widget.contententId));
                            } else {
                              flutterToast.showToast(
                                child: CommonToast(displaymsg: 'Enter Message'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 2),
                              );
                            }
                          } else {
                            flutterToast.showToast(
                              child: CommonToast(displaymsg: 'Enter Subject'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            /*state.status == Status.LOADING && state is AddReviewState ? Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70,
                ),
              ),
            ):Container(),*/
          ],
        ),
      ),
    );
  }

  String formatString(List x) {
    String formatted = '';
    for (var i in x) {
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }

  bool getEmailvalidate(String string) {
    bool isEmailbool = false;
    List<String> emails = string.split(",");

    emails.forEach((element) {
      if (isEmail(element)) {
        isEmailbool = true;
      } else {
        isEmailbool = false;
      }
    });

    return isEmailbool;
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
