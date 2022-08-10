import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/bloc/feedback_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/event/feedback_event.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/model/feedbackresponse.dart';
import 'package:flutter_admin_web/framework/bloc/feedback/state/feedback_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/feedback/feedback_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class FeedbackScreen extends StatefulWidget {
  final Function updateTitle;

  FeedbackScreen(this.updateTitle);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late ProfileBloc profileBloc;

  late FeedbackBloc feedbackBloc;

  TextEditingController titleController = new TextEditingController();

  TextEditingController descController = new TextEditingController();

  bool isFeedbackform = true;

  late FToast flutterToast;

  final ImagePicker _picker = ImagePicker();
  XFile _imageFile = XFile('');

  bool imageAttached = false;

  @override
  void initState() {
    super.initState();
    flutterToast = FToast();
    flutterToast.init(context);

    profileBloc =
        ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    feedbackBloc = FeedbackBloc(
        feedbackRepository: FeedbackRepositoryBuilder.repository());

    feedbackBloc.isFirstLoading = true;

    getFeedbackListing();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(
          int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeData.fallback().bottomAppBarColor,
          onPressed: () {},
          child: InkWell(
              onTap: () {
                isFeedbackform == true ? getFeedbackListing() : print('object');
                setState(() {
                  isFeedbackform
                      ? isFeedbackform = false
                      : isFeedbackform = true;
                  Future.delayed(Duration(seconds: 0)).then((value) {
                    isFeedbackform
                        ? appBloc.feedbackTitle = 'Enter New Feedback'
                        : appBloc.feedbackTitle = 'Previous Feedback List';
                    widget.updateTitle();
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: isFeedbackform
                    ? Icon(
                        Icons.list_outlined,
                        color: Colors.black,
                      )
                    : Icon(
                        Icons.feedback,
                        color: Colors.black,
                      ),
              )),
        ),
        body: isFeedbackform
            ? SingleChildScrollView(
                reverse: true,
                child: BlocConsumer<FeedbackBloc, FeedbackState>(
                  bloc: feedbackBloc,
                  listener: (context, state) {
                    if (state is PostFeedbackState &&
                        state.status == Status.LOADING &&
                        feedbackBloc.isFirstLoading == true) {
                      /*return Container(
                        child: Center(
                          child: AbsorbPointer(
                            child: SpinKitCircle(
                              color: InsColor(appBloc).appIconColor,
                              size: 70,
                            ),
                          ),
                        ),
                      );*/
                    } else if (state is PostFeedbackState &&
                        state.status == Status.COMPLETED) {
                      titleController.text = '';
                      descController.text = '';
                      _imageFile = XFile('');
                      showToast();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.all(16.0),
                                  //   child: Text(
                                  //     "",
                                  //     textAlign: TextAlign.left,
                                  //     style: TextStyle(
                                  //       fontSize: 20.0,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 1.0,
                                  //       bottom: 16.0,
                                  //       left: 16.0,
                                  //       right: 16.0),
                                  //   child: Text(feedbackBloc.fileName,
                                  //       textAlign: TextAlign.left,
                                  //       style: TextStyle(
                                  //           color: Color(
                                  //         int.parse(
                                  //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  //       ))),
                                  // ),
                                  SizedBox(height: 10.0,),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 6.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: Text.rich(
                                      TextSpan(
                                        text: "Title ",
                                        style: TextStyle(
                                          color: AppColors.getAppTextColor(),
                                          fontSize: 15.0,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 16.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                      // key: Key(wikiUploadBloc.fileName),
                                      controller: titleController,
                                      decoration: InputDecoration(
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
                                        hintText: 'Title',
                                        hintStyle: TextStyle(
                                          color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 6.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: Text.rich(
                                      TextSpan(
                                        text: "Feedback ",
                                        style: TextStyle(
                                          color: AppColors.getAppTextColor(),
                                          fontSize: 15.0,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1.0,
                                        bottom: 16.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: TextField(
                                      style: TextStyle(
                                          color: Color(
                                        int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                      )),
                                      controller: descController,
                                      cursorHeight: 25.0,
                                      maxLines: 10,
                                      decoration: InputDecoration(
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
                                        hintStyle: TextStyle(
                                          color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.7),
                                        ),
                                        hintText: 'Enter Feedback',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: RaisedButton.icon(
                                        icon: Icon(_imageFile.path.isEmpty
                                            ? Icons.image
                                            : Icons.highlight_remove),
                                        onPressed: () => {
                                              setState(() {
                                                feedbackBloc.filePath = '';
                                                feedbackBloc.fileName = '';
                                                _imageFile = XFile('');
                                              }),
                                              print('choose file ${_imageFile.path}'),
                                              _imageFile.path.isEmpty
                                                  ? showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              new AlertDialog(
                                                                title: Text(
                                                                  'Choose Image From',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          int.parse(
                                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                ),
                                                                content:
                                                                    Container(
                                                                  height: 100,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      InkWell(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.camera_alt,
                                                                              color: InsColor(appBloc).appIconColor,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              'Camera',
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          onImageButtonPressed(
                                                                              ImageSource.camera,
                                                                              context: context);
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Divider(),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      InkWell(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(Icons.image,
                                                                                color: InsColor(appBloc).appIconColor),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              'Gallery',
                                                                              style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          onImageButtonPressed(
                                                                              ImageSource.gallery,
                                                                              context: context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        new BorderRadius.circular(
                                                                            5)),
                                                              ))
                                                  : updateUIForImage,
                                            },
                                        disabledColor: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                            .withOpacity(0.5),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                        label: Text(_imageFile.path.isEmpty
                                            ? 'Choose Image'
                                            : 'Remove Image'),
                                        textColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _imageFile.path.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.file(
                                              File(_imageFile.path),
                                              fit: BoxFit.cover,
                                              width: 105,
                                              height: 105,
                                            ))
                                        : Container(),
                                  )
                                ],
                              ),
                            ))
                      ],
                    );
                  },
                ),
              )
            : BlocConsumer<FeedbackBloc, FeedbackState>(
                bloc: feedbackBloc,
                builder: (context, state) {
                  return Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: feedbackBloc.feedbackList.length != 0
                        ? ListView.builder(
                            itemCount: feedbackBloc.feedbackList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Container(
                                child: FeedbackCell(
                                  feedback: feedbackBloc.feedbackList[index],
                                  onDeleteTap: (int id) {
                                    //feedbackBloc.feedbackList.removeAt(index);
                                    feedbackBloc
                                        .add(DeleteFeedbackEvent(id: id));
                                    print(id);
                                  },
                                  appBloc: appBloc,
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                  appBloc
                                      .localstr.commoncomponentLabelNodatalabel,
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontSize: 24)),
                            ),
                          ),
                  );
                },
                listener: (context, state) {}),
        bottomNavigationBar: isFeedbackform
            ? Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: MaterialButton(
                      height: 40,
                      disabledColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                          .withOpacity(0.5),
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      child: Text(
                        "Add Feedback",
                        // appBloc.localstr.catalogButtonSavebuttontitle,
                        // style: TextStyle(
                        //     fontSize: 14,
                        //     color: Color(int.parse(
                        //         "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: InsColor(appBloc).appBtnTextColor),
                      ),
                      onPressed: () {
                        submitFeedback();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void getFeedbackListing() {
    bool isAdmin = privilegeCreateForumIdExists();
    feedbackBloc.add(GetFeedbackResponseEvent(isAdmin ? "true" : "false"));
  }

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1277) {
        if (profileBloc.userprivilige[i].roleid == 8) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> submitFeedback() async {
    var filepath = _imageFile.path;
    var descriptionVar = descController.text;
    var titleNameVar = titleController.text;

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please Enter Title'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    } else if (descriptionVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please Enter Feedback'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }

    File file = new File(_imageFile.path);

    var filname = await AppDirectory.getFileNameWithExtension(file);

    feedbackBloc.add(FeedbackSubmitEvent(
        image: _imageFile.path,
        feedbackTitle: titleController.text,
        feedbackDesc: descController.text,
        currentUserId: '0',
        currentUrl: '',
        currentSiteId: '',
        imageFileName: filname,
        isUrl: true));
  }

  void onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
          source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 100);
      Navigator.of(context).pop();

      if (pickedFile != null) {
        var imageName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        setState(() {
          // _imageFile =;
          print('pickedFile.path ${pickedFile.path}');
          if (titleController.text.isEmpty) {
           titleController.text = imageName;
          }
          // descController.text = pickedFile.path;
          _imageFile = pickedFile;
        });
        print('imageName $imageName');
      }
    } catch (e) {
      setState(() {});
    }
  }

  void updateUIForImage() {
    setState(() {
      _imageFile = XFile('');
    });
  }

  void showToast() {
    flutterToast.showToast(
      child: CommonToast(
          displaymsg: 'Feedback Submitted Successfully  \n Thank you!'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }
}

class FeedbackCell extends StatelessWidget {
  final void Function()? onTap;
  final Function? onDeleteTap;
  final FeedbackModel feedback;
  final AppBloc appBloc;

  FeedbackCell(
      {Key? key,
      required this.feedback,
      this.onTap,
      this.onDeleteTap,
      required this.appBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    // print('${ApiEndpoints.strSiteUrl}${feedback.userProfilePathdata}');

    String atachmentPath = feedback.saveimagepath;

    atachmentPath = atachmentPath.startsWith("http")
        ? atachmentPath
        : ApiEndpoints.strSiteUrl + atachmentPath;

    String profImg = feedback.userProfilePathdata;

    profImg = profImg.startsWith("http")
        ? profImg
        : ApiEndpoints.strSiteUrl + profImg;

    return InkWell(
      onTap: onTap,
      child: Card(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profImg,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/user.gif',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Text(
                              feedback.userDisplayName,
                              // style: TextStyle(
                              //     fontSize: 16,
                              //     color: Color(
                              //       int.parse(
                              //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              //     ),
                              // ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Text(
                              feedback.date.split(' ').first,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: InsColor(appBloc)
                                          .appTextColor
                                          .withOpacity(0.7),
                                      fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      //color: Colors.red,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: IconButton(
                        icon: Icon(Icons.delete,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                        onPressed: () {
                          showConfirmDialog(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  feedback.titlename,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: InsColor(appBloc).appTextColor, fontSize: 15),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Text(
                  feedback.desc,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: InsColor(appBloc).appTextColor, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                ),
              ),
              feedback.imagepath.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        showDialogImage(context, atachmentPath);
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(
                            useMobileLayout ? kCellThumbHeight : 180),
                        width:
                            ScreenUtil().setHeight(useMobileLayout ? 200 : 280),
                        child: CachedNetworkImage(
                          imageUrl: atachmentPath,
                          width: MediaQuery.of(context).size.width,
                          placeholder: (context, url) => Image.asset(
                            'assets/cellimage.jpg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/cellimage.jpg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void showDialogImage(BuildContext context, String atachmentPath) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 300,
            child: CachedNetworkImage(
              imageUrl: atachmentPath,
              width: MediaQuery.of(context).size.width,
              placeholder: (context, url) => Image.asset(
                'assets/cellimage.jpg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/cellimage.jpg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              title: Text(
                "Feedback",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              ),
              content: Text(
                'Are you sure you want to delete',
                style: TextStyle(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              ),
              backgroundColor: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              actions: <Widget>[
                new FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: Text('Delete'),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (onDeleteTap != null) onDeleteTap!(feedback.iD);
                  },
                ),
              ],
            ));
  }
}
