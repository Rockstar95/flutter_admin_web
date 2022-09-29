
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/answers_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';

class AddAnswer extends StatefulWidget {
  final QuestionList questionList;
  final Table1? answerList;
  final bool isEdit;

  const AddAnswer({
    Key? key,
    required this.questionList,
    this.answerList,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AddAnswer> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController ctrAnswer = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;

  FToast? flutterToast;

  @override
  void initState() {
    super.initState();

    ctrAnswer.text = widget.isEdit ? (widget.answerList?.response ?? "") : '';

    askTheExpertBloc = AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    askTheExpertBloc.fileName = widget.isEdit
        ? (widget.answerList?.userResponseImage != ''
            ? widget.answerList!.userResponseImage
            : "")
        : "";
    //askTheExpertBloc.filePath = widget.isEdit ? (widget.answerList?.userResponseImage != '' ? widget.answerList!.userResponseImage : "") : "";
    MyPrint.printOnConsole("askTheExpertBloc.fileName:${askTheExpertBloc.fileName}");
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast!.init(context);

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.isEdit ? 'Edit Answer' : 'Add Answer',
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
                          'Answer',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.apply(color: InsColor(appBloc).appTextColor),
                        focusNode: reqFocusTitle,
                        controller: ctrAnswer,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrAnswer.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.7)),
                          hintText: 'Enter your text here..',
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
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                      onPressed: () => {
                            askTheExpertBloc.fileBytes != null
                                ? askTheExpertBloc.add(const OpenFileExplorerTopicEvent(FileType.image))
                                : null
                          },
                      minWidth: MediaQuery.of(context).size.width,
                      color: askTheExpertBloc.fileBytes != null
                          ? Colors.grey
                          : Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      textColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                      child: Text(
                        'Upload File',
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                      )),
                ),
                Visibility(
                  visible: askTheExpertBloc.fileBytes != null,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 5.0, right: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: InsColor(appBloc).appTextColor,
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
                                    askTheExpertBloc.fileName,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: InsColor(appBloc).appTextColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    askTheExpertBloc.fileBytes != null
                                        ? '${(askTheExpertBloc.fileBytes!.length /1024).toStringAsFixed(0)}kb'
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
                                askTheExpertBloc.fileName = "";
                                askTheExpertBloc.fileBytes = null;
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
              ],
            ),
          );
        });
  }

  Widget createAnswerButton() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state is AddAnswerState) {
          if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
            flutterToast?.showToast(
                child: CommonToast(
                    displaymsg: widget.isEdit
                        ? 'Answer edited successfully'
                        : 'Answer added successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4));
          } else if (state.status == Status.ERROR) {
            flutterToast?.showToast(
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
          return Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: MaterialButton(
                        onPressed: () => {
                              validateAddAnswerForm(),
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

  void validateAddAnswerForm() {
    var filebytes = askTheExpertBloc.fileBytes;
    var fileName = askTheExpertBloc.fileName;

    var titleNameVar = ctrAnswer.text;

    if (titleNameVar.isEmpty) {
      flutterToast?.showToast(
        child: CommonToast(displaymsg: 'Please enter answer'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 4),
      );
      return;
    }
    widget.isEdit
        ? askTheExpertBloc.add(AddAnswerEvent(
            userEmail: '',
            userName: '',
            response: titleNameVar,
            userResponseImageName: '',
            responseID: widget.answerList?.responseID ?? 0,
            questionID: widget.answerList?.questionID ?? 0,
            isRemoveEditImage: false,
            fileBytes: filebytes,
            fileName: fileName,
          ))
        : askTheExpertBloc.add(AddAnswerEvent(
            userEmail: '',
            userName: '',
            response: titleNameVar,
            userResponseImageName: '',
            responseID: -1,
            questionID: widget.questionList.questionID,
            isRemoveEditImage: false,
            fileBytes: filebytes,
            fileName: fileName,
          ));
  }
}
