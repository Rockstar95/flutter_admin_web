import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/share_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/share_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/share_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class SendviaEmailMylearning extends StatefulWidget {
  final DummyMyCatelogResponseTable2 myLearningModel;
  final bool isTraxkList;
  final List<DummyMyCatelogResponseTable2> list;

  SendviaEmailMylearning(this.myLearningModel, this.isTraxkList, this.list);

  @override
  Sendviaemail createState() => Sendviaemail();
}

class Sendviaemail extends State<SendviaEmailMylearning> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  ShareBloc get shareBloc => BlocProvider.of<ShareBloc>(context);
  String strUserName = '';

  TextEditingController toController = new TextEditingController();
  late TextEditingController subjectController;
  TextEditingController messagetoController = new TextEditingController();
  late FToast flutterToast;
  String msgString = "";

  @override
  void initState() {
    // TODO: implement initState
    getEmailId();
    String what = appBloc.localstr.sendingdocumenttomyselfviaemail;
    String info = appBloc.localstr.sendingdocumenttomyselfviaemail == null
        ? 'Sending document to myself'
        : appBloc.localstr.sendingdocumenttomyselfviaemail;
    String contenetname = widget.myLearningModel.name;
    subjectController =
        new TextEditingController(text: info + " - " + contenetname);
    super.initState();
  }

  Future<void> getEmailId() async {
    String name = await sharePrefGetString(sharedPref_LoginEmailId);
    setState(() {
      strUserName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        appBar: AppBar(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          title: Text(
            "Share via Email",
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
                  if (state is SendviaMailToMyLearn) {
                    if (state.status == Status.COMPLETED) {
                      if (state.isSucces) {
                        flutterToast.showToast(
                          child: CommonToast(
                              displaymsg: 'Email Sent Successfully'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                      }

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
                  if (state.status == Status.LOADING) {
                    return Container(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                      child: Center(
                          child: AbsorbPointer(
                              child: SpinKitCircle(
                        color: Colors.grey,
                        size: 70.h,
                      ))),
                    );
                  }

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
                                Text(
                                  "To * :",
                                  style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      splashColor: Colors.transparent),
                                  child: TextField(
                                    style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    ),
                                    maxLines: 1,
                                    readOnly: true,
                                    controller: toController,
                                    decoration: InputDecoration(
                                      hintText: '$strUserName',
                                      filled: true,
                                      fillColor: Color(int.parse("0xFFdfe6e9")),
                                      hintStyle: TextStyle(
                                          color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.7)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                            width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Subject * :",
                                  style: TextStyle(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Body :",
                                  style: TextStyle(
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
                                  textInputAction: TextInputAction.done,
                                  minLines: 5,
                                  //Normal textInputField will be displayed
                                  maxLines: 10,

                                  decoration: InputDecoration(
                                    hintText: 'Enter your body here',
                                    hintStyle: TextStyle(
                                      color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                          .withOpacity(0.7),
                                    ),
//                                    fillColor: Colors.white70,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                            appBloc.localstr
                                .discussionforumActionsheetCanceloption,
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
                        onPressed: () {
                          if (subjectController.text.toString() != "") {
                            shareBloc.add(SendviaMailInmylearn(
                                strUserName,
                                subjectController.text.toString(),
                                messagetoController.text.toString(),
                                true,
                                widget.myLearningModel.contentid));
                          } else {
                            flutterToast.showToast(
                              child: CommonToast(
                                  displaymsg: 'Please Enter Subject'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
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
      ),
    );
  }
}
