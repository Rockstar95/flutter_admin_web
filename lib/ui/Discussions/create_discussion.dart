import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/create_discussion_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/create_discussion_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_topic_user_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/create_discussion_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/create_discussion_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class CreateDiscussion extends StatefulWidget {
  @override
  _CreateDiscussionState createState() => _CreateDiscussionState();
}

class _CreateDiscussionState extends State<CreateDiscussion> with SingleTickerProviderStateMixin {
  var arrSettings = [
    'Allow users to create new topics',
    'Allow users to attach files with posts',
    'Allow users to like and comment',
    'Allow users to share',
    'Allow users to pin'
  ];
  var notificationSubscriptions = [
    'Don’t send any notifications',
    'Send notifications to the moderators and to the users who post topic, comment or reply on this forum',
    'Send notifications about activity on a specific topic to the moderators of this Forum and to the users who post a comment or a reply to that topic'
  ];

  var selectedNotification =
      'Send notifications to the moderators and to the users who post topic, comment or reply on this forum';

  var isAllSeting = [true, true, true, true, true];

  var sendMailString = '';

  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrTitle = TextEditingController();
  TextEditingController ctrDescription = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();
  FocusNode reqFocusDescription = FocusNode();

  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late CreateDiscussionBloc createDiscussionBloc;
  late FToast flutterToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    createDiscussionBloc = CreateDiscussionBloc(
        createDiscussionRepositry:
            CreateDiscussionRepositoryBuilder.repository());

    createDiscussionBloc.add(GetDiscussionTopicUserListDetails());
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
          'Create Discussion',
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
            // Divider(
            //   height: 2,
            //   color: Colors.black87,
            // ),
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
                    child: createDiscussionButton())
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context, double itemWidth, double itemHeight) {
    return new Column(
      children: [
        new Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Form(
                      key: _formKey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0,left: 5,top: 20),
                            child: Text.rich(
                              TextSpan(
                                text: "Title ",
                                style: TextStyle(color: AppColors.getAppTextColor()),
                                children: [
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                                  ),
                                ]
                              ),
                            ),
                          ),
                          // ),
                          new TextFormField(
                            style: TextStyle(color: InsColor(appBloc).appTextColor),
                            focusNode: reqFocusTitle,
                            controller: ctrTitle,
                            minLines: 3,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                            onSaved: (val) => ctrTitle.text = val ?? "",
                            onChanged: (val) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: AppColors.getAppTextColor().withOpacity(0.7)),
                              hintText: 'Enter your title here..',
                              // contentPadding: new EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFFDADCE0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                          //   child:
                          getTextFormFieldTitle("Description"),
                          // ),
                          Container(
                            child: new ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 400.0,
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: InsColor(appBloc).appTextColor),
                                focusNode: reqFocusDescription,
                                controller: ctrDescription,
                                textInputAction: TextInputAction.next,
                                onSaved: (val) =>
                                    ctrDescription.text = val ?? "",
                                onChanged: (val) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: AppColors.getTextFieldHintColor()),
                                  hintText: 'Enter your description here..',
                                  // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),
                                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: InsColor(appBloc).appTextColor)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      color: Color(0xFFDADCE0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      width: 1,
                                    ),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                  contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                                ),
                                maxLines: 6,
                                minLines: 6,
                              ),
                            ),
                          ),
                        ],
                      )),
                  connectionsList(),
                  supportDocument(),
                  settings(),
                  privacy(),
                  notificationSubscription()
                ])),
      ],
    );
  }

  //region Select Moderators Section
  Widget connectionsList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          getSelectModeratorsWidget(),
          getSelectedModeratorsList(),
        ],
      ),
    );
  }

  Widget getSelectModeratorsWidget() {
    return GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => SelectModeratorsDialog(
                  createDiscussionBloc: createDiscussionBloc,
                  appBloc: appBloc,
                ),
              );
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                //color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFDADCE0), ),
              ),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Select moderators ",
                        style: TextStyle(color: AppColors.getAppTextColor()),
                        children: [
                          TextSpan(
                            text: "*",
                            style: TextStyle(color: AppColors.getMandatoryStarColor(),),
                          ),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_forward_ios, size: 20,),
                ],
              ),
            ),
          );
  }

  Widget getSelectedModeratorsList() {
    List<int> list = [];

    for(int i = 0; i < createDiscussionBloc.userChecked.length; i++) {
      if(createDiscussionBloc.userChecked[i] && i < createDiscussionBloc.topicUserList.length) {
        list.add(i);
      }
    }

    if(list.isEmpty) {
      return SizedBox();
    }

    return Column(
      children: List.generate(list.length, (index) {
        return GetConnectionCard(
          response: createDiscussionBloc.filterTopicList[list[index]],
          userChecked: true,
          onCheck: (bool isChecked) {
            setState(() {
              createDiscussionBloc.userChecked[list[index]] = isChecked;
            });
          },
        );
      }),
    );
  }
  //endregion

  Widget supportDocument() {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
        bloc: createDiscussionBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTextFormFieldTitle("Thumbnails"),
                new SizedBox(
                  width: useMobileLayout
                      ? double.infinity
                      : MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(
                    padding: EdgeInsets.all(15.0),
                    onPressed: () {
                      if (createDiscussionBloc.filePath.isEmpty) {
                        createDiscussionBloc.add(
                            OpenFileExplorerEvent(FileType.image));
                      }
                    },
                    child: const Text('Upload File', style: TextStyle(fontSize: 20)),
                    color: createDiscussionBloc.filePath.isNotEmpty
                        ? Colors.grey
                        : AppColors.getAppButtonBGColor(),
                    textColor: Colors.white,
                    elevation: 0,
                  ),
                ),
                SizedBox(height: 6,),
                Center(
                  child: Text("Recommended Image 200x150 pixels (.png .jpeg and .svg files)",style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.normal),),
                ),
                SizedBox(height: 6,),
                Visibility(
                  visible: (createDiscussionBloc.filePath.isNotEmpty),
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
                        new Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                            ),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  //createDiscussionBloc.fileName,
                                  createDiscussionBloc.filePath.substring(createDiscussionBloc.filePath.lastIndexOf("/") + 1),
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: InsColor(appBloc).appTextColor,
                                      fontWeight: FontWeight.normal),
                                ),
                                new Text(
                                  createDiscussionBloc.filePath.isNotEmpty && File(createDiscussionBloc.filePath).existsSync()
                                      ? (File(createDiscussionBloc.filePath).lengthSync() / 1024).toStringAsFixed(0) + 'kb'
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
                                createDiscussionBloc.fileName = "";
                                createDiscussionBloc.filePath = "";
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
        },
    );
  }

  Widget settings() {
    return new Container(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       getTextFormFieldTitle("Settings"),
        new ListView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: arrSettings.length,
            itemBuilder: (context, index) {
              return new Container(
                margin: EdgeInsets.only(top: 5.0),
                child: new Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: new Text(
                        arrSettings[index],
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: AppColors.getAppTextColor().withOpacity(.54)),
                      ),
                    ),
                    new Spacer(),
                    new Switch(
                      value: isAllSeting[index],
                      onChanged: (value) {
                        setState(() {
                          if (isAllSeting[index] == false) {
                            isAllSeting[index] = true;
                          } else {
                            isAllSeting[index] = false;
                          }
                        });
                      },
                      activeTrackColor: AppColors.getAppButtonBGColor().withOpacity(0.3),
                      activeColor: AppColors.getAppButtonBGColor()
                    ),
                  ],
                ),
              );
            }),
      ],
    ));
  }

  Widget privacy() {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         getTextFormFieldTitle("PRIVACY"),
          new Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
                child: new Text(
                  'Private Forum',
                  style: new TextStyle(
                    fontSize: 16.0,
                    color:AppColors.getAppTextColor().withOpacity(.54)
                  ),
                ),
              ),
              new Spacer(),
              new Switch(
                value: createDiscussionBloc.isSwitched,
                onChanged: (value) {
                  setState(() {
                    if (createDiscussionBloc.isSwitched == false) {
                      createDiscussionBloc.isSwitched = true;
                    } else {
                      createDiscussionBloc.isSwitched = false;
                    }
                  });
                },
                activeTrackColor: AppColors.getAppButtonBGColor().withOpacity(0.3),
                activeColor: AppColors.getAppButtonBGColor()
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget notificationSubscription() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
        bloc: createDiscussionBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return new Container(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                child: new Text(
                  'Notification Subscriptions for this Discussion Forum',
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: AppColors.getAppTextColor().withOpacity(.54)),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: 20, left: 5.0, right: 10.0, bottom: 10.0),
              //   child: new Text(
              //     'The Discussion notifications at the site level must be \u0027on\u0027 for the user to receive any notifications. The following settings apply to this Discussion Forum only.',
              //     style: new TextStyle(
              //         fontSize: 16.0,
              //         color: Color(int.parse(
              //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              //   ),
              // ),
              new ListView.builder(
                  shrinkWrap: true,
                  itemCount: notificationSubscriptions.length,
                  itemBuilder: (context, index) {
                    return new Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: new Row(
                        children: [
                          Container(
                            // color:Colors.red ,
                            child: Theme(
                                data: ThemeData(

                                  //here change to your color
                                  unselectedWidgetColor: AppColors.getAppTextColor().withOpacity(.54),
                                  primarySwatch: Colors.lightGreen
                                ),
                                child: Radio<String>(

                                  focusColor: MaterialStateColor.resolveWith((states) => Colors.green),
                                  value: notificationSubscriptions[index],
                                  groupValue: selectedNotification,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedNotification = value ?? "";
                                    });
                                  },
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: new Text(
                                notificationSubscriptions[index],
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.getAppTextColor().withOpacity(.54)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ));
        });
  }

  Widget createDiscussionButton() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
      bloc: createDiscussionBloc,
      listener: (context, state) {
        if (state is CreateDiscussionDetailsState) {
          if (state.status == Status.LOADING) {
            /*return Align(
              alignment: Alignment.center,
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70,
                ),
              ),
            );*/
          } else if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);

            flutterToast.showToast(
              child: CommonToast(
                displaymsg: 'Forum Created successfully',
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: Duration(seconds: 2),
            );
          } else if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }

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
        if (state.status == Status.LOADING &&
            createDiscussionBloc.isCreateLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
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
                  validateCreateDiscuusionForum();
                },
                child: const Text('Create Discussion',
                    style: TextStyle(fontSize: 20)),
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

  void validateCreateDiscuusionForum() {
    var titleNameVar = ctrTitle.text;

    if (notificationSubscriptions[0] == selectedNotification) {
      setState(() {
        sendMailString = 'dontsend';
      });
    } else if (notificationSubscriptions[1] == selectedNotification) {
      setState(() {
        sendMailString = 'all';
      });
    } else {
      setState(() {
        sendMailString = 'onlytopic';
      });
    }

    if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Enter title name'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }
    /*else if(descriptionVar.isEmpty){
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Enter Description name'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    } else if (filepath.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Choose file'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }*/
    else if (createDiscussionBloc.selectedEditUserId().isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Please select atleast one connection'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }
    createDiscussionBloc.isCreateLoading = true;
    createDiscussionBloc.add(CreateDiscussionForumEvent(
      likePosts: isAllSeting[2],
      description: ctrDescription.text,
      moderation: false,
      updatedDate: createDiscussionBloc.formatter.format(DateTime.now()),
      forumID: -1,
      forumThumbnailName: "",
      categoryIDs: "",
      sendEmail: sendMailString,
      parentForumID: 0,
      name: ctrTitle.text,
      createNewTopic: isAllSeting[0],
      attachFile: isAllSeting[1],
      requiresSubscription: true,
      moderatorID: createDiscussionBloc.selectedEditUserId(),
      createdDate: createDiscussionBloc.formatter.format(DateTime.now()),
      allowShare: isAllSeting[3],
      isPrivate: createDiscussionBloc.isSwitched,
      allowPinTopic: isAllSeting[4],
      filePath: createDiscussionBloc.filePath,
      fileName: createDiscussionBloc.fileName,
    ));
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Text(
                        appBloc.localstr.commoncomponentLabelNodatalabel,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 24)),
                  ),
                ),
              )
            ],
          )
        : new Container();
  }

  //helper method

  Widget getTextFormFieldTitle(String text){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0,left: 5,top: 20),
      child: Text(
        text,
        style: new TextStyle(
            fontSize: 15.0,
            letterSpacing: 0.9,
            fontWeight: FontWeight.w500,
            color:Colors.black.withOpacity(0.54)),
      ),
    );
  }
}

class SelectModeratorsDialog extends StatefulWidget {
  final CreateDiscussionBloc createDiscussionBloc;
  final AppBloc appBloc;

  const SelectModeratorsDialog({Key? key, required this.createDiscussionBloc, required this.appBloc}) : super(key: key);

  @override
  State<SelectModeratorsDialog> createState() => _SelectModeratorsDialogState();
}

class _SelectModeratorsDialogState extends State<SelectModeratorsDialog> {
  late CreateDiscussionBloc createDiscussionBloc;
  late AppBloc appBloc;

  late ScrollController scrollController;

  void filterSearchResults(String name) {
    List<DiscussionTopicUserListResponse> searchList = [];
    searchList.addAll(createDiscussionBloc.topicUserList);
    if (name.isNotEmpty) {
      List<DiscussionTopicUserListResponse> listData = [];
      searchList.forEach((item) {
        if (item.userName.toLowerCase().contains(name.toLowerCase())) {
          listData.add(item);
        }
      });
      setState(() {
        createDiscussionBloc.filterTopicList.clear();
        createDiscussionBloc.filterTopicList.addAll(listData);
      });
    }
    else {
      setState(() {
        createDiscussionBloc.filterTopicList.clear();
        createDiscussionBloc.filterTopicList
            .addAll(createDiscussionBloc.topicUserList);
      });
    }
  }

  @override
  void initState() {
    createDiscussionBloc = widget.createDiscussionBloc;
    appBloc = widget.appBloc;
    scrollController = ScrollController();
    filterSearchResults("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.getAppBGColor(),
      insetPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(),
            getSearchTextfield(),
            Expanded(
              child: getListView(),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getDoneButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitle() {
    return Padding(
              padding: const EdgeInsets.only(bottom: 10.0,left: 5,top: 20),
              child: Text(
                "Moderators*",
                style: new TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w500,
                    color:Colors.black.withOpacity(0.54)),
              ),
            );
  }

  Widget getSearchTextfield() {
    return TextFormField(
      style: TextStyle(color: AppColors.getAppTextColor()),
      onChanged: (value) {
        setState(() {
          filterSearchResults(value);
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
        ),
        hintText: 'Search connections',
        hintStyle: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
        contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
    );
  }

  Widget getListView() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
      bloc: createDiscussionBloc,
      listener: (context, state) {
        if (state.status == Status.COMPLETED) {
          filterSearchResults('');
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING && createDiscussionBloc.isFirstLoading == true) {
          return Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: Colors.grey,
                size: 70.0,
              ),
            ),
          );
        }
        else if (createDiscussionBloc.filterTopicList.length == 0) {
          return noDataFound(true);
        }
        else {
          return new Container(
            color: AppColors.getAppBGColor(),
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xFFDADCE0), ),
              ),
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.resolveWith<Color>((states) => AppColors.getAppTextColor()),
                    trackColor: MaterialStateProperty.resolveWith<Color>((states) => AppColors.getAppTextColor().withOpacity(0.2)),
                  ),
                ),
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 8,
                  radius: Radius.circular(10),
                  interactive: true,
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(right: 15),
                    itemCount: createDiscussionBloc.filterTopicList.length,
                    itemBuilder: (context, index) {
                      return GetConnectionCard(
                        response: createDiscussionBloc.filterTopicList[index],
                        userChecked: index < createDiscussionBloc.userChecked.length ? createDiscussionBloc.userChecked[index] : false,
                        onCheck: (bool isChecked) {
                          setState(() {
                            createDiscussionBloc.userChecked[index] = isChecked;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget getDoneButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'Done',
        style: TextStyle(fontSize: 16),
      ),
      color: AppColors.getAppButtonBGColor(),
      textColor: Colors.white,
      elevation: 5,
    );
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Text(
                        widget.appBloc.localstr.commoncomponentLabelNodatalabel,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${widget.appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            fontSize: 24,
                        ),
                    ),
                  ),
                ),
              )
            ],
          )
        : new Container();
  }
}

class GetConnectionCard extends StatelessWidget {
  final DiscussionTopicUserListResponse response;
  final bool userChecked;
  final void Function(bool) onCheck;

  const GetConnectionCard({
    Key? key,
    required this.response,
    required this.userChecked,
    required this.onCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MyPrint.printOnConsole("response.userThumb:${ApiEndpoints.strSiteUrl + response.userThumb}");
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: response.userThumb.isNotEmpty
                    ? NetworkImage(response.userThumb.startsWith('http')
                        ? response.userThumb
                        : '${ApiEndpoints.strSiteUrl + response.userThumb}')
                    : AssetImage('assets/user.gif',) as ImageProvider,
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              response.userName,
              style: TextStyle(
                fontSize: 18.0,
                color: AppColors.getAppTextColor(),
              ),
            ),
          ),
          new Spacer(),
          new InkWell(
            onTap: () {
              onCheck(!userChecked);
            },
            child: new Icon(
              userChecked == false
                  ? Icons.remove_circle_outlined
                  : Icons.add_circle,
              color: userChecked == false
                  ? AppColors.getAppTextColor()
                  : AppColors.getAppButtonBGColor(),
            ),
          )
        ],
      ),
    );
  }
}

