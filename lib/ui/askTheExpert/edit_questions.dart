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
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/askTheExpert/skill_category.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/outline_button.dart';

class EditQuestion extends StatefulWidget {
  final QuestionList questionList;

  const EditQuestion({Key? key, required this.questionList}) : super(key: key);

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController ctrQuestion = TextEditingController();
  TextEditingController ctrQuestionDesc = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();
  FocusNode reqFocusDescription = FocusNode();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late AskTheExpertBloc askTheExpertBloc;

  late FToast flutterToast;
  var titleSelectCategory = 'Select Skill';
  List<SkillCateModel> skillCategoriesListLocal = [];

  @override
  void initState() {
    super.initState();
    ctrQuestion.text = widget.questionList.userQuestion;
    ctrQuestionDesc.text = widget.questionList.userQuestionDescription;
    titleSelectCategory = widget.questionList.questionCategories;

    if (widget.questionList.questionCategories.isNotEmpty) {
      widget.questionList.questionCategories.split(',').forEach((element) {
        skillCategoriesListLocal.add(SkillCateModel(
            skillID: '0', preferrenceTitle: element, isSelected: true));
      });
    }

    askTheExpertBloc = new AskTheExpertBloc(
        askTheExpertRepository: AskTheExpertRepositoryBuilder.repository());

    print("File Name:${widget.questionList.userQuestionImage}");
    askTheExpertBloc.fileName = widget.questionList.userQuestionImage.isNotEmpty
        ? widget.questionList.userQuestionImage
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
          'Edit a question',
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
                    child: createQuestionButton())
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
                          'Question',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ),
                      new TextFormField(
                        style: TextStyle(
                            fontSize: 14.h,
                            color: InsColor(appBloc).appTextColor),
                        focusNode: reqFocusTitle,
                        controller: ctrQuestion,
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => ctrQuestion.text = val ?? "",
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: InsColor(appBloc).appTextColor),
                          hintText: 'Enter your question here..',
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 35.0, horizontal: 20.0),
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                        child: new Text(
                          'Description(Optional)',
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
                                color: InsColor(appBloc).appTextColor),
                            focusNode: reqFocusDescription,
                            controller: ctrQuestionDesc,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => ctrQuestionDesc.text = val ?? "",
                            onChanged: (val) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              hintText: 'Enter your description here..',
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
                            maxLines: null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 0.0, left: 10.0, right: 16.0),
                        child: Text(
                          "Skills",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: OutlineButton(
                            border: Border.all(
                                color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                    .withOpacity(0.5)),
                            child: SizedBox(
                              child: Text(
                                titleSelectCategory,
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                            onPressed: () {
                              moveSkillCategory();
                            },
                          )),
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
                      color: Colors.grey,
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
                      color: askTheExpertBloc.filePath.isNotEmpty
                          ? Colors.grey
                          : Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
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
                                          color: InsColor(appBloc).appTextColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    new Text(
                                      askTheExpertBloc.filePath.isNotEmpty && File(askTheExpertBloc.filePath).existsSync()
                                          ? (File(askTheExpertBloc.filePath).lengthSync() / 1024).toStringAsFixed(0) + 'kb'
                                          : '',
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: InsColor(appBloc).appTextColor,
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

  Widget createQuestionButton() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state is AddQuestionState) {
          if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Question Edited successfully'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4));
          } else if (state.status == Status.ERROR) {
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
          return askTheExpertBloc.isFirstLoading
              ? Align(
                  child: AbsorbPointer(
                    child: SpinKitCircle(
                      color: Colors.grey,
                      size: 70.h,
                    ),
                  ),
                )
              : Container();
        } else {
          return Container(
            alignment: Alignment.bottomCenter,
            child: new Row(
              children: [
                new Expanded(
                    child: MaterialButton(
                        onPressed: () => {
                              validateAddQuestionForm(),
                            },
                        minWidth: MediaQuery.of(context).size.width,
                        disabledColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5),
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        child: Text(
                          'Submit question',
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        textColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
              ],
            ),
          );
        }
      },
    );
  }

  void validateAddQuestionForm() {
    var filepath = askTheExpertBloc.filePath;
    var fileName = askTheExpertBloc.fileName;
    var descriptionVar = ctrQuestionDesc.text;
    var titleNameVar = ctrQuestion.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please enter question'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }
    askTheExpertBloc.add(AddQuestionEvent(
        '',
        '',
        1,
        titleNameVar,
        descriptionVar,
        fileName,
        filepath,
        fileName,
        titleSelectCategory,
        updateSelectedCatId(),
        widget.questionList.questionID,
        false));
  }

  void moveSkillCategory() async {
    skillCategoriesListLocal = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SkillCategory(skillCateModel: skillCategoriesListLocal)));

    updateSkillCategoryTitle();
  }

  String formatString(List x) {
    if (x.length == 0) {
      return 'Select Skill';
    }
    String formatted = '';
    for (var i in x) {
      formatted += '$i,';
    }
    return formatted.replaceRange(formatted.length - 1, formatted.length, '');
  }

  String updateSelectedCatId() {
    List<String> selectedCategoryID = [];

    skillCategoriesListLocal.length > 0
        ? skillCategoriesListLocal.forEach((element) {
            selectedCategoryID.add('${element.skillID}');
          })
        : selectedCategoryID.clear();
    print('selectedCategoryID ${formatString(selectedCategoryID)}');

    //updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  String updateSkillCategoryTitle() {
    List<String> selectedCategoryID = [];

    skillCategoriesListLocal.length > 0
        ? skillCategoriesListLocal.forEach((element) {
            selectedCategoryID.add('${element.preferrenceTitle}');
          })
        : selectedCategoryID.clear();
    print('selectedCategoryID ${formatString(selectedCategoryID)}');

    updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  void updateInformation(String information) {
    setState(() => titleSelectCategory = information);
  }
}
