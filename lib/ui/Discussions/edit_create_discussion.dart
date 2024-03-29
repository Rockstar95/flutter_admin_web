import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/create_discussion_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/create_discussion_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discusiion_topic_user_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/create_discussion_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/createDiscussion/create_discussion_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Discussions/create_discussion.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../../configs/constants.dart';

class EditCreateDiscussion extends StatefulWidget {
  final ForumList forumList;

  const EditCreateDiscussion({Key? key, required this.forumList}) : super(key: key);

  @override
  _EditCreateDiscussionState createState() => _EditCreateDiscussionState();
}

class _EditCreateDiscussionState extends State<EditCreateDiscussion> with SingleTickerProviderStateMixin {
  var arrSettings = [
    'Allow users to create new topics',
    'Allow usres to attach files with posts',
    'Allow usres to like and comment',
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

  var isAllSeting = [false, false, false, false, false];
  var sendMailString = '';

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  TextEditingController ctrTitle = TextEditingController();
  TextEditingController ctrDescription = TextEditingController();

  FocusNode reqFocusTitle = FocusNode();
  FocusNode reqFocusDescription = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late CreateDiscussionBloc createDiscussionBloc;

  @override
  void initState() {
    super.initState();

    ctrTitle.text = widget.forumList.name;
    ctrDescription.text = widget.forumList.description;

    createDiscussionBloc = CreateDiscussionBloc(
        createDiscussionRepositry:
            CreateDiscussionRepositoryBuilder.repository());

    createDiscussionBloc.fileName = widget.forumList.forumThumbnailPath != ''
        ? widget.forumList.forumThumbnailPath.split('/').reversed.first
        : "";

    createDiscussionBloc.add(GetDiscussionTopicUserListDetails());
    createDiscussionBloc.isSwitched = widget.forumList.isPrivate;
    isAllSeting[0] = widget.forumList.createNewTopic;
    isAllSeting[1] = widget.forumList.attachFile;
    isAllSeting[2] = widget.forumList.likePosts;
    isAllSeting[3] = widget.forumList.allowShare;
    isAllSeting[4] = widget.forumList.allowPin;
    switch (widget.forumList.sendEmail) {
      case 'all':
        selectedNotification = notificationSubscriptions[1];
        break;
      case 'onlytopic':
        selectedNotification = notificationSubscriptions[2];
        break;
      case 'dontsend':
        selectedNotification = notificationSubscriptions[0];
        break;
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
          'Edit Discussion',
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
                    child: createDiscussionButton())
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                autovalidateMode: _validate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
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
                    TextFormField(
                      style: TextStyle(
                          fontSize: 14.h,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                      focusNode: reqFocusTitle,
                      controller: ctrTitle,
                      textInputAction: TextInputAction.next,
                      onSaved: (val) => ctrTitle.text = val ?? "",
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: AppColors.getTextFieldHintColor()),
                        hintText: 'Enter your title here..',
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
                            vertical: 35.0, horizontal: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 5.0, right: 10.0, bottom: 10.0),
                      child: Text(
                        'Description',
                        style: TextStyle(
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
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          focusNode: reqFocusDescription,
                          controller: ctrDescription,
                          textInputAction: TextInputAction.next,
                          onSaved: (val) => ctrDescription.text = val ?? "",
                          onChanged: (val) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: AppColors.getTextFieldHintColor()),
                            hintText: 'Enter your description here..',
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
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 45.0, horizontal: 20.0),
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              connectionsList(),
              supportDocument(),
              settings(),
              privacy(),
              notificationSubscription()
            ],
          ),
        ),
      ],
    );
  }

  //region Select Moderators Section
  Widget connectionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                //color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDADCE0), ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 20,),
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
                  const SizedBox(width: 10,),
                  const Icon(Icons.arrow_forward_ios, size: 20,),
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
      return const SizedBox();
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
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
        bloc: createDiscussionBloc,
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
                    'Thumbnails',
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
                      if (createDiscussionBloc.fileName.isEmpty ||
                              createDiscussionBloc.fileName == '...') {
                        createDiscussionBloc
                            .add(OpenFileExplorerEvent(FileType.image));
                      }
                    },
                    color: createDiscussionBloc.fileName.isNotEmpty &&
                            createDiscussionBloc.fileName != '...'
                        ? Colors.grey
                        : Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    textColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                    elevation: 5,
                    child: const Text('Upload File',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Visibility(
                  visible: (createDiscussionBloc.fileName.isNotEmpty &&
                      createDiscussionBloc.fileName != '...'),
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
                                  createDiscussionBloc.fileName,
                                  //createDiscussionBloc.filePath.substring(createDiscussionBloc.filePath.lastIndexOf("/") + 1),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: InsColor(appBloc).appTextColor,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  createDiscussionBloc.fileBytes != null
                                      ? '${(createDiscussionBloc.fileBytes!.length / 1024).toStringAsFixed(0)}kb'
                                      : '',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                createDiscussionBloc.fileName = "";
                                createDiscussionBloc.fileBytes = null;
                                widget.forumList.forumThumbnailPath = '';
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

  Widget settings() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
        bloc: createDiscussionBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 5.0, right: 10.0, bottom: 10.0),
            child: Text(
              'Settings',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: arrSettings.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          arrSettings[index],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: isAllSeting[index],
                        onChanged: (value) {
                          setState(() {
                            isAllSeting[index] = value;
                          });
                          MyPrint.printOnConsole("88888 : ${isAllSeting[index]}");
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        });
  }

  Widget privacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 5.0, right: 10.0, bottom: 10.0),
          child: Text(
            'Privacy',
            style: TextStyle(
                fontSize: 18.0,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                'Private discussion',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
            ),
            const Spacer(),
            Switch(
              value: createDiscussionBloc.isSwitched,
              onChanged: (value) {
                setState(() {
                  createDiscussionBloc.isSwitched = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            ),
          ],
        ),
      ],
    );
  }

  Widget notificationSubscription() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
        bloc: createDiscussionBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 5.0, right: 10.0, bottom: 10.0),
            child: Text(
              'Notification Subscriptions for this Discussion Forum',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 5.0, right: 10.0, bottom: 10.0),
            child: Text(
              'The Discussion notifications at the site level must be \u0027on\u0027 for the user to receive any notifications. The following settings apply to this Discussion Forum only.',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: notificationSubscriptions.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: notificationSubscriptions[index],
                        groupValue: selectedNotification,
                        onChanged: (value) {
                          setState(() {
                            selectedNotification = value ?? "";
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            notificationSubscriptions[index],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          );
        });
  }

  Widget createDiscussionButton() {
    return BlocConsumer<CreateDiscussionBloc, CreateDiscussionState>(
      bloc: createDiscussionBloc,
      listener: (context, state) {
        if (state is CreateDiscussionDetailsState) {
          if (state.status == Status.LOADING) {

          }
          else if (state.status == Status.COMPLETED) {
            Navigator.of(context).pop(true);
          }
          else if (state.status == Status.ERROR) {
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
        if(state is CreateDiscussionDetailsState && state.status == Status.LOADING) {
          return Center(
            child: AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70)
            ),
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              padding: const EdgeInsets.all(15.0),
              onPressed: () {
                validateCreateDiscuusionForum();
              },
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              textColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
              elevation: 5,
              child:
                  const Text('Edit discussion', style: TextStyle(fontSize: 20)),
            ),
          ),
        );
      },
    );
  }

  void validateCreateDiscuusionForum() {
    if (notificationSubscriptions[0] == selectedNotification) {
      setState(() {
        sendMailString = 'dontsend';
      });
    }
    else if (notificationSubscriptions[1] == selectedNotification) {
      setState(() {
        sendMailString = 'all';
      });
    }
    else {
      setState(() {
        sendMailString = 'onlytopic';
      });
    }

    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();

      createDiscussionBloc.add(CreateDiscussionForumEvent(
        likePosts: isAllSeting[2],
        description: ctrDescription.text,
        moderation: false,
        updatedDate: createDiscussionBloc.formatter.format(DateTime.now()),
        forumID: widget.forumList.forumID,
        forumThumbnailName: widget.forumList.forumThumbnailPath,
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
        fileBytes: createDiscussionBloc.fileBytes,
        fileName: createDiscussionBloc.fileName,
      ));
    }
    else {
      setState(() {
        _validate = true;
      });
    }
  }

  void filterSearchResults(String name) {
    List<DiscussionTopicUserListResponse> searchList = [];
    searchList.addAll(createDiscussionBloc.topicUserList);
    if (name.isNotEmpty || name == '') {
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

    checkModerator();
    /*for(int i=0; i<createDiscussionBloc.topicUserList.length; i++) {
      if(widget.forumList.moderatorID.split(',').contains(createDiscussionBloc.filterTopicList[i].userID.toString())) {
        createDiscussionBloc.userChecked[i] = true;
      }
      else {
        createDiscussionBloc.userChecked[i] = false;
      }
    }*/
  }

  void checkModerator() {
    for (int i = 0; i < createDiscussionBloc.topicUserList.length; i++) {
      if (widget.forumList.moderatorID.split(',').contains(createDiscussionBloc.filterTopicList[i].userID.toString())) {
        createDiscussionBloc.userChecked[i] = true;
      } else {
        createDiscussionBloc.userChecked[i] = false;
      }
    }
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
}
