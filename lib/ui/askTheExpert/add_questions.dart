import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/bloc/ask_the_expert_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/event/ask_the_expert_event.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/state/ask_the_expert_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/askTheExpert/ask_the_expert_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/askTheExpert/skill_category.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/outline_button.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
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
          'Add Question',
          style: TextStyle(
              fontSize: 20,
              color: AppColors.getAppTextColor()),
        ),
        backgroundColor: AppColors.getAppHeaderColor(),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.getAppTextColor()),
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
        color: AppColors.getAppBGColor(),
        child: Stack(
          children: <Widget>[
            // Divider(
            //   height: 2,
            //   color: Colors.black87,
            // ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: mainWidget(context, itemWidth, itemHeight),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 10.0, right: 10.0, bottom: 8.0),
                    child: createQuestionButton())
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
                    'Question*',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.getAppTextColor()),
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: AppColors.getAppTextColor(),
                  ),
                  minLines: 3,
                  maxLines: 3,

                  focusNode: reqFocusTitle,
                  controller: ctrQuestion,
                  textInputAction: TextInputAction.next,
                  onSaved: (val) => ctrQuestion.text = val ?? "",
                  onChanged: (val) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20,bottom: 20),
                    hintStyle: TextStyle(
                      color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.7),
                    ),
                    hintText: 'Enter your question here..',
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
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.getAppTextColor()),
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: AppColors.getAppTextColor(),
                  ),
                  minLines: 7,
                  maxLines: 7,
                  focusNode: reqFocusDescription,
                  controller: ctrQuestionDesc,
                  textInputAction: TextInputAction.next,
                  onSaved: (val) => ctrQuestionDesc.text = val ?? "",
                  onChanged: (val) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20,bottom: 20),
                    hintStyle: TextStyle(
                      color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.7),
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
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 5.0, right: 10.0),
                  child: Text(
                    "Skills*",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.getAppTextColor()),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: OutlineButton(
                      border: Border.all(color: Colors.grey.shade500),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                titleSelectCategory,

                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: titleSelectCategory == "Select Skill"? AppColors.getAppTextColor().withOpacity(0.5): Colors.grey.shade600),
                              )),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade600,
                              )
                            ],
                          ),
                        ),
                      ),
                      onPressed: () {
                        moveSkillCategory();
                      },
                    )),
                supportDocument(),
              ],
            ),
          ),
        ),
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
                  'Attachments',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.getAppTextColor()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: SizedBox(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                      onPressed: () => {
                            askTheExpertBloc.isFirstLoading = false,
                            askTheExpertBloc.fileBytes != null
                                ? askTheExpertBloc.add(const OpenFileExplorerTopicEvent(FileType.image))
                                : null
                          },
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                      color: askTheExpertBloc.fileBytes != null
                          ? Colors.grey
                          :  AppColors.getAppButtonBGColor(),
                      textColor:  AppColors.getAppButtonTextColor(),
                      child: Text(
                        'Upload File',
                        style: TextStyle(
                            color: AppColors.getAppButtonTextColor()),
                      )),
                ),
              ),
              Visibility(
                visible: (askTheExpertBloc.fileBytes != null),
                child: SizedBox(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 2,
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
                                        ? ('${askTheExpertBloc.fileBytes!.length.toStringAsFixed(0)}kb')
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
                                askTheExpertBloc.fileBytes = null;
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
      },
    );
  }

  Widget createQuestionButton() {
    return BlocConsumer<AskTheExpertBloc, AskTheExpertState>(
      bloc: askTheExpertBloc,
      listener: (context, state) {
        if (state is AddQuestionState) {
          if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
            flutterToast.showToast(
                child: CommonToast(displaymsg: 'Question Added successfully'),
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
        MyPrint.printOnConsole("Status:${state.status}");
        MyPrint.printOnConsole("askTheExpertBloc.isFirstLoading:${askTheExpertBloc.isFirstLoading}");
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
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    onPressed: () {
                      validateAddQuestionForm();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    disabledColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                        .withOpacity(0.5),
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    textColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                    child: const Text('Submit Question'),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void validateAddQuestionForm() {
    var filebytes = askTheExpertBloc.fileBytes;
    var fileName = askTheExpertBloc.fileName;
    var descriptionVar = ctrQuestionDesc.text;
    var titleNameVar = ctrQuestion.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please enter question'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 4),
      );
      return;
    } else if (titleSelectCategory == 'Select Skill') {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please choose atleast one skill'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 4),
      );
      return;
    }
    askTheExpertBloc.add(AddQuestionEvent(
        '',
        '',
        1,
        titleNameVar,
        descriptionVar,
        '',
        fileName,
        filebytes,
        titleSelectCategory,
        updateSelectedCatId(),
        -1,
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
    if (x.isEmpty) {
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

    skillCategoriesListLocal.isNotEmpty
        ? skillCategoriesListLocal.forEach((element) {
            selectedCategoryID.add('${element.skillID}');
          })
        : selectedCategoryID.clear();
    MyPrint.printOnConsole('selectedCategoryID ${formatString(selectedCategoryID)}');

    //updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  String updateSkillCategoryTitle() {
    List<String> selectedCategoryID = [];

    skillCategoriesListLocal.isNotEmpty
        ? skillCategoriesListLocal.forEach((element) {
            selectedCategoryID.add(element.preferrenceTitle);
          })
        : selectedCategoryID.clear();
    MyPrint.printOnConsole('selectedCategoryID ${formatString(selectedCategoryID)}');

    updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  void updateInformation(String information) {
    setState(() => titleSelectCategory = information);
  }
}
