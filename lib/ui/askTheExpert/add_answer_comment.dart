import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/answers_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class AddAnswerComment extends StatefulWidget {
  final Table1 table1;

  const AddAnswerComment(this.table1, {Key? key}) : super(key: key);

  @override
  State<AddAnswerComment> createState() => _AddAnswerCommentState();
}

class _AddAnswerCommentState extends State<AddAnswerComment>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
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

    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());
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
          'Comment',
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
              color: InsColor(appBloc).appTextColor,
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
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: Text(
                          'Comment',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 14.h),
                        focusNode: reqFocusTitle,
                        controller: ctrComment,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrComment.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          hintText: 'Enter your comment here..',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 45.0, horizontal: 20.0),
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
          return Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    'Support Documents (Optional)',
                    style: TextStyle(
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
                  child: MaterialButton(
                      onPressed: () => {
                            askTheExpertBloc.fileName.isEmpty ||
                                    askTheExpertBloc.fileName == '...'
                                ? askTheExpertBloc.add(
                                    const OpenFileExplorerTopicEvent(FileType.image))
                                : null
                          },
                      minWidth: MediaQuery.of(context).size.width,
                      color: askTheExpertBloc.fileName.isNotEmpty &&
                              askTheExpertBloc.fileName != '...'
                          ? Colors.grey
                          : Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      textColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                      child: const Text('Upload File')),
                ),
                Visibility(
                  visible: (askTheExpertBloc.fileName.isNotEmpty &&
                      askTheExpertBloc.fileName != '...'),
                  child: SizedBox(
                    width: useMobileLayout
                        ? double.infinity
                        : MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.description,
                              color: InsColor(appBloc).appTextColor),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      askTheExpertBloc.fileName.isNotEmpty
                                          ? askTheExpertBloc.fileName
                                          : '',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: InsColor(appBloc).appTextColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      askTheExpertBloc.fileBytes != null
                                          ? '${askTheExpertBloc.fileBytes!.length}kb'
                                          : '',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: InsColor(appBloc).appTextColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  askTheExpertBloc.fileName = "";
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
                child: CommonToast(displaymsg: 'Comment added successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4));
          } else if (state.status == Status.ERROR) {
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
          return Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: MaterialButton(
                        onPressed: () => {
                              validateAddCommentForm(widget.table1),
                            },
                        minWidth: MediaQuery.of(context).size.width,
                        disabledColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5),
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        textColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                        child: const Text('Submit'))),
              ],
            ),
          );
        }
      },
    );
  }

  void validateAddCommentForm(Table1 table1) {
    var filebytes = askTheExpertBloc.fileBytes;
    var fileName = askTheExpertBloc.fileName;

    var titleNameVar = ctrComment.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please enter comment'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 4),
      );
      return;
    }
    askTheExpertBloc.add(AddAnswerCommentEvent(
        table1.questionID,
        table1.responseID,
        '-1',
        titleNameVar,
        '',
        0,
        false,
        filebytes,
        fileName));
  }
}
