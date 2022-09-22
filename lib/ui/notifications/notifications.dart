import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/bloc/notification_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/event/notification_event.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/model/notification_response.dart';
import 'package:flutter_admin_web/framework/bloc/notifications/state/notification_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/notification_string.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/notifications/notification_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Catalog/prerequisite_detail_screen.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/home/ActBase.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';

import '../../configs/constants.dart';

class Notifications extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;

  Notifications({required this.nativeMenuModel});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late NotificationBloc notificationBloc;
  late MyLearningDetailsBloc detailsBloc;

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
  late FToast flutterToast;
  bool isMarkAsRead = true;

  void getDetailsApiCall(String contentid) {
    MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
    detailsRequest.locale = 'en-us';
    detailsRequest.contentId = contentid;
    detailsRequest.metadata = '1';
    detailsRequest.intUserId = catalogBloc.strUserID ?? "";
    detailsRequest.iCms = false;
    detailsRequest.componentId = '';
    detailsRequest.siteId = ApiEndpoints.siteID;
    detailsRequest.eRitems = '';
    detailsRequest.detailsCompId = '107';
    detailsRequest.detailsCompInsId = '3291';
    detailsRequest.componentDetailsProperties = '';
    detailsRequest.hideAdd = 'false';
    detailsRequest.objectTypeId = '-1';
    detailsRequest.scoId = '';
    detailsRequest.subscribeErc = false;

    catalogBloc
        .add(GetCatalogDetails(myLearningDetailsRequest: detailsRequest));

    print("om--------${detailsRequest.toString()}");
  }

  void moveToContent(Notification1 notificationModel) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => ActBase(
        notification: notificationModel.notificationID.toString(),
        contentId: notificationModel.otherParams1,
        isFromNotification: true,
      ),
    ), (_) => false);
  }

  String notificationTitle(Notification1 notificationModel) {
    String title = '';
    switch (notificationModel.notificationID.toString()) {
      case AssignedToMyCatalog:
        var contentId = notificationModel.contentID;

        if ((notificationBloc.notificationResponse.table3.isNotEmpty)) {
          Notification3 item =
          notificationBloc.notificationResponse.table3.firstWhere(
                (element) => element.contentID == contentId,
          );
          if (item != null) {
            title = appBloc.localstr.assignedToMyCatalogLbl
                .replaceAll('[[Content Title]]', item.name)
                .replaceAll('[[Date Assigned]]', notificationModel.dispalynotificationStartdate);
          }
        }
        return title;
      case Reminder1:
        return appBloc.localstr.reminder1lbl;
      case NewConnectionRequest:
        return appBloc.localstr.newConnectionRequestLbl.replaceAll(
            '[[User Name]]',
            notificationModel.fromUserDisplayName);
      case NewInCatalog:
        var contentId = notificationModel.contentID;

        if ((notificationBloc.notificationResponse.table3.isNotEmpty)) {
          Notification3 item =
          notificationBloc.notificationResponse.table3.firstWhere(
                (element) => element.contentID == contentId,
          );
          if (item != null) {
            title = appBloc.localstr.newInCatalogLbl
                .replaceAll('[[Content Title]]', item.name)
                .replaceAll('[[Date published]]', item.displayPublishedDate);
          }
        }
        return title;
      case ForumCommentNotification:
        var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        if ((notificationBloc.notificationResponse.table4.isNotEmpty)) {
          Notification4 item =
          notificationBloc.notificationResponse.table4.firstWhere(
                (element) => element.contentID == contentId,
          );
          if (item != null) {
            title = "$message ${item.forumName}";
          } else {
            title = "$message";
          }
        }
        return title;
      case NewInDiscussionThread:
        var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        if ((notificationBloc.notificationResponse.table4.isNotEmpty)) {
          Notification4? item;
          if(notificationBloc.notificationResponse.table4.isNotEmpty) {
            List<Notification4> list = notificationBloc.notificationResponse.table4.where((element) => element.contentID == contentId).toList();
            if(list.isNotEmpty) item = list.first;
          }
          if (item != null) {
            title = "$message ${item.forumName}";
          } else {
            title = "$message";
          }
        }
        return title;
      case General:
        return appBloc.localstr.generalLbl;
      case SPACEDLEARNING:
        //var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        title = "$message";
        // if ((notificationBloc.notificationResponse.table4.isNotEmpty)) {
        //   Notification4? item;
        //   if(notificationBloc.notificationResponse.table4.isNotEmpty) {
        //     List<Notification4> list = notificationBloc.notificationResponse.table4.where((element) => element.contentID == contentId).toList();
        //     if(list.isNotEmpty) item = list.first;
        //   }
        //   if (item != null) {
        //     title = "$message ${item.forumName}";
        //   } else {
        //     title = "$message";
        //   }
        // }
        return title;
      default:
        return '';
    }
  }

  InlineSpan notificationTitle2(Notification1 notificationModel) {
    TextStyle defaultStyle = Theme.of(context).textTheme.bodyText1?.apply(color: AppColors.getAppTextColor(),) ??
        TextStyle(color: AppColors.getAppTextColor(), fontSize: 14);

    TextSpan title = TextSpan(
      text: "New Notification",
      style: defaultStyle,
    );

    switch (notificationModel.notificationID.toString()) {
      case AssignedToMyCatalog: {
        var contentId = notificationModel.contentID;

        if ((notificationBloc.notificationResponse.table3.isNotEmpty)) {
          Notification3? item;
          List<Notification3> list = notificationBloc.notificationResponse.table3.where((element) => element.contentID == contentId,).toList();
          if(list.isNotEmpty) {
            item = list.first;
          }
          if (item != null) {
            String titleText = appBloc.localstr.assignedToMyCatalogLbl.replaceAll('[[Date Assigned]]', notificationModel.dispalynotificationStartdate);
            String parameter = "[[Content Title]]";
            if(titleText.contains(parameter)) {
              int index = titleText.indexOf(parameter);
              String newText1 = titleText.substring(0, index);
              String newText2 = titleText.substring(index + parameter.length);
              title = TextSpan(
                text: newText1,
                style: defaultStyle,
                children: [
                  TextSpan(text: item.name, style: defaultStyle.copyWith(color: Colors.blue, fontWeight: FontWeight.w600)),
                  TextSpan(text: newText2, style: defaultStyle),
                ],
              );
            }
          }
        }
        break;
      }
      case Reminder1: {
        title = TextSpan(
          text: appBloc.localstr.reminder1lbl,
          style: defaultStyle,
        );
        break;
      }
      case NewConnectionRequest: {
        title = TextSpan(
          text: appBloc.localstr.newConnectionRequestLbl.replaceAll('[[User Name]]', notificationModel.fromUserDisplayName),
          style: defaultStyle,
        );
        break;
      }
      case NewInCatalog: {
        var contentId = notificationModel.contentID;

        if ((notificationBloc.notificationResponse.table3.isNotEmpty)) {
          Notification3? item;
          List<Notification3> list = notificationBloc.notificationResponse.table3.where((element) => element.contentID == contentId,).toList();
          if(list.isNotEmpty) {
            item = list.first;
          }

          if (item != null) {
            String titleText = appBloc.localstr.assignedToMyCatalogLbl.replaceAll('[[Date published]]', item.displayPublishedDate);
            String parameter = "[[Content Title]]";
            if(titleText.contains(parameter)) {
              int index = titleText.indexOf(parameter);
              String newText1 = titleText.substring(0, index);
              String newText2 = titleText.substring(index + parameter.length);
              title = TextSpan(
                text: newText1,
                style: defaultStyle,
                children: [
                  TextSpan(text: item.name, style: defaultStyle.copyWith(color: Colors.blue)),
                  TextSpan(text: newText2, style: defaultStyle),
                ],
              );
            }
          }
        }

        break;
      }
      case ForumCommentNotification: {
        var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        if ((notificationBloc.notificationResponse.table4.isNotEmpty)) {
          Notification4? item;
          List<Notification4> list = notificationBloc.notificationResponse.table4.where((element) => element.contentID == contentId,).toList();
          if(list.isNotEmpty) {
            item = list.first;
          }

          String titleString = "";
          if (item != null) {
            titleString = "$message ${item.forumName}";
          }
          else {
            titleString = "$message";
          }

          title = TextSpan(
            text: titleString,
            style: defaultStyle,
          );
        }
        return title;
      }
      case NewInDiscussionThread: {
        var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        if ((notificationBloc.notificationResponse.table4.isNotEmpty)) {
          Notification4? item;
          if(notificationBloc.notificationResponse.table4.isNotEmpty) {
            List<Notification4> list = notificationBloc.notificationResponse.table4.where((element) => element.contentID == contentId).toList();
            if(list.isNotEmpty) item = list.first;
          }

          String titleString = "";
          if (item != null) {
            titleString = "$message ${item.forumName}";
          }
          else {
            titleString = "$message";
          }

          title = TextSpan(
            text: titleString,
            style: defaultStyle,
          );
        }
        break;
      }
      case General: {
        title = TextSpan(
          text: appBloc.localstr.generalLbl,
          style: defaultStyle,
        );
        break;
      }
      case SPACEDLEARNING: {
        //var contentId = notificationModel.contentID;
        var message = notificationModel.message;
        title = TextSpan(
          text: message,
          style: defaultStyle,
        );
        break;
      }
    }

    return title;
  }

  @override
  void initState() {
    super.initState();
    detailsBloc = new MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());
    notificationBloc = new NotificationBloc(
        notificationRepository: NotificationRepositoryBuilder.repository());

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    return Scaffold(
      // bottomNavigationBar: notificationBloc.notificationResponse != null ? bottomNavigation(): Container() ,
      backgroundColor: AppColors.getAppBGColor(),
      key: _scaffoldkey,
      body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: Column(
            children: [
              Expanded(child: getNotificationsListView()),
              Align(alignment: Alignment.bottomCenter, child: bottomNavigation())
            ],
          )),
    );
  }

  Widget getNotificationsListView() {
    return BlocConsumer<NotificationBloc, NotificationState>(
        bloc: notificationBloc,
        listener: (context, state) {
          MyPrint.printOnConsole("NotificationBloc Listener Called for State :${state.runtimeType} & Status:${state.status}");

          if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
          if (state is RemoveNotiFicationEvent || state is ClearNotiFicationEvent) {
            if (state.status == Status.COMPLETED) {
              appBloc.add(NotificationCountEvent());
            }
          }
          else if (state is MarkNotificationState) {
            if (state.status == Status.COMPLETED) {
              notificationBloc.isFirstLoading = false;
              appBloc.add(NotificationCountEvent());
              if (isMarkAsRead) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PrerequisiteDetailScreen(
                            contentid: widget.nativeMenuModel.repositoryId,
                            detailsBloc: detailsBloc,
                            table2: catalogBloc.catalogRes,
                            nativeModel: widget.nativeMenuModel,
                            isFromNotification: true)))
                    .then((value) {
                  print("Value:$value");
                  if (value ?? true) {
                    refresh();
                  }
                });
              }
              else {
                refresh();
              }
            }
          }
          else if(state is NotificationDataState) {
            if(state.status == Status.LOADING) {
              notificationBloc.isFirstLoading = true;
            }
            else if([Status.COMPLETED, Status.ERROR].contains(state.status)) {
              notificationBloc.isFirstLoading = false;
            }
          }
          else if (state is DoPeopleListingActionState) {
            if (state.status == Status.COMPLETED) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: notificationBloc.acceptRequest.message),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              );
              refresh();
            }
          }
          else if (state is DeleteNotificationState) {
            if (state.status == Status.COMPLETED) {
              appBloc.add(NotificationCountEvent());
            }
          }
          else if (state is DoPeopleListingActionState) {
            if (state.status == Status.COMPLETED) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: notificationBloc.acceptRequest.message),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              );
              refresh();
            }
          }
          if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        },
        builder: (context, state) {
          if (notificationBloc.isFirstLoading == true) {
            return Center(
              child: AbsorbPointer(
                child: AppConstants().getLoaderWidget(iconSize: 70),
              ),
            );
          }
          else if (state.status == Status.ERROR || (notificationBloc.notificationResponse.table.isNotEmpty ? notificationBloc.notificationResponse.table.first.notificationCount : 0) == 0) {
            return noDataFound(true);
          }
          else {
            return RefreshIndicator(
              onRefresh: () async {
                refresh();
              },
              color: AppColors.getAppButtonBGColor(),
              child: ListView.builder(
                itemCount: notificationBloc.notificationResponse.table1.length,
                itemBuilder: (context, index) {
                  Notification1 notificationModel = notificationBloc.notificationResponse.table1[index];

                  //print("Notification:${value.message}");

                  return getNotificationCard(notificationModel);
                },
              ),
            );
          }
        });
  }

  Widget getNotificationCard(Notification1 notificationModel) {
    String notificationDate = notificationModel.dispalynotificationStartdate;

    try {
      DateTime dateTime = DateFormat("mm/dd/yyyy").parse(notificationModel.dispalynotificationStartdate);
      //MyPrint.printOnConsole("DateTime:${dateTime}");
      notificationDate = DateFormat("dd MMM yyyy").format(dateTime);
    }
    catch(e) {}

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: AppColors.getNotificationCardBorderColor(), offset: Offset(0, 2), spreadRadius: 1, blurRadius: 1),
        ]
      ),
      child: Slidable(
        key: Key(notificationModel.message),
        startActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: 'Mark read',
              backgroundColor: AppColors.getNotificationCardSlideMarkAsReadColor(),
              icon: Icons.mail,
              onPressed: (BuildContext context) => {
                isMarkAsRead = false,
                notificationBloc.isFirstLoading = false,
                notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
              },
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              label: 'Delete',
              backgroundColor: AppColors.getNotificationCardSlideDeleteColor(),
              icon: Icons.delete,
              onPressed: (BuildContext context) => {
                notificationBloc.add(DeleteNotiFicationEvent(
                    userNotificationID:
                    notificationModel.userNotificationID.toString())),

                setState(() {
                  this
                      .notificationBloc
                      .notificationResponse
                      .table1
                      .removeWhere((element) =>
                  element.userNotificationID ==
                      notificationModel.userNotificationID);
                })

                // refresh()
              },
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => {
            getDetailsApiCall(notificationModel.contentID),

            print("Id:${notificationModel.notificationID.toString()}"),

            if (notificationModel.notificationID.toString() == AssignedToMyCatalog) {
              //   catalogBloc.isFirstLoadingCatalog = true,
              notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
              //requiredFunctionalityForTheSelectedCell()
            }
            else if (notificationModel.notificationID.toString() == NewInCatalog) {
              // catalogBloc.isFirstLoadingCatalog = true,
              notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
              // requiredFunctionalityForTheSelectedCell()
            }
            else if (notificationModel.notificationID.toString() == ForumCommentNotification) {
              isMarkAsRead = false,
              notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
              moveToContent(notificationModel)
            }
            else if (notificationModel.notificationID.toString() == NewConnectionRequest) {
              //selectedWidget = ConnectionIndexScreen()
              moveToContent(notificationModel)
            }
            else if (notificationModel.notificationID.toString() == NewInDiscussionThread) {
              isMarkAsRead = false,
              notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
              //selectedWidget = ConnectionIndexScreen()
              moveToContent(notificationModel)
            }
            else if (notificationModel.notificationID.toString() == SPACEDLEARNING) {
              notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 20),
            decoration: BoxDecoration(
              color: notificationModel.markAsRead
                  ? AppColors.getAppBGColor()
                  : AppColors.getNotificationCardUnreadBGColor(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.getNotificationCardFlashIconBackgroundColor(),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.flash_on, color: AppColors.getNotificationCardFlashIconColor(),),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30.w,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        notificationModel.fromUserDisplayName,
                        style: Theme.of(context).textTheme.bodyText1?.apply(
                          color: InsColor(appBloc).appTextColor,
                          fontWeightDelta: 2,
                          fontSizeDelta: 0.5,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Visibility(
                        visible: notificationModel.notificationID.toString() == NewConnectionRequest,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: notificationTitle2(notificationModel),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  notificationBloc.add(DoPeopleListingActionEvent(
                                      selectedObjectID:
                                      notificationModel
                                          .fromUserID,
                                      currentMenu:
                                      'People',
                                      userName: notificationModel
                                          .fromUserDisplayName,
                                      selectAction:
                                      'Ignore',
                                      consolidationType:
                                      'mainsite'));
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 38.0,
                                  color: InsColor(
                                      appBloc)
                                      .appTextColor
                                      .withOpacity(0.5),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  notificationBloc.add(DoPeopleListingActionEvent(
                                      selectedObjectID:
                                      notificationModel
                                          .fromUserID,
                                      currentMenu:
                                      'People',
                                      userName: notificationModel
                                          .fromUserDisplayName,
                                      selectAction:
                                      'Accept',
                                      consolidationType:
                                      'mainsite'));
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(
                                      left: 5,
                                      right: 8),
                                  child: Icon(
                                    Icons
                                        .check_circle_outlined,
                                    size: 38.0,
                                    color: Colors
                                        .lightGreen,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: notificationModel.notificationID.toString() != NewConnectionRequest,
                        child: RichText(
                          text: notificationTitle2(notificationModel),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        notificationDate,
                        style: Theme.of(context).textTheme.bodyText1?.apply(
                          color: AppColors.getAppTextColor().withAlpha(180),
                          fontWeightDelta: 1,
                          fontSizeDelta: -2,
                        ),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNotificationOldCard(Notification1 notificationModel) {
    return Slidable(
      key: Key(notificationModel.message),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Mark read',
            backgroundColor: Colors.blue,
            icon: Icons.mail,
            onPressed: (BuildContext context) => {
              isMarkAsRead = false,
              notificationBloc.isFirstLoading = false,
              notificationBloc.add(MarkNotificationEvent(
                  userNotificationID:
                  notificationModel.userNotificationID.toString())),
              refresh()
            },
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (BuildContext context) => {
              notificationBloc.add(DeleteNotiFicationEvent(
                  userNotificationID:
                  notificationModel.userNotificationID.toString())),

              setState(() {
                this
                    .notificationBloc
                    .notificationResponse
                    .table1
                    .removeWhere((element) =>
                element.userNotificationID ==
                    notificationModel.userNotificationID);
              })

              // refresh()
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => {
          getDetailsApiCall(notificationModel.contentID),

          print("Id:${notificationModel.notificationID.toString()}"),

          if (notificationModel.notificationID.toString() == AssignedToMyCatalog) {
            //   catalogBloc.isFirstLoadingCatalog = true,
            notificationBloc.add(MarkNotificationEvent(
                userNotificationID:
                notificationModel.userNotificationID.toString())),
            //requiredFunctionalityForTheSelectedCell()
          }
          else if (notificationModel.notificationID.toString() == NewInCatalog) {
            // catalogBloc.isFirstLoadingCatalog = true,
            notificationBloc.add(MarkNotificationEvent(
                userNotificationID:
                notificationModel.userNotificationID.toString())),
            // requiredFunctionalityForTheSelectedCell()
          }
          else if (notificationModel.notificationID.toString() == ForumCommentNotification) {
              isMarkAsRead = false,
              notificationBloc.add(MarkNotificationEvent(
                  userNotificationID:
                  notificationModel.userNotificationID.toString())),
              moveToContent(notificationModel)
            }
            else if (notificationModel.notificationID.toString() == NewConnectionRequest) {
                //selectedWidget = ConnectionIndexScreen()
                moveToContent(notificationModel)
              }
              else if (notificationModel.notificationID.toString() == NewInDiscussionThread) {
                  isMarkAsRead = false,
                  notificationBloc.add(MarkNotificationEvent(userNotificationID: notificationModel.userNotificationID.toString())),
                  //selectedWidget = ConnectionIndexScreen()
                  moveToContent(notificationModel)
                }
                else if (notificationModel.notificationID.toString() == SPACEDLEARNING) {
                    notificationBloc.add(MarkNotificationEvent(
                        userNotificationID:
                        notificationModel.userNotificationID.toString())),
                  }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
          height: 70,
          decoration: BoxDecoration(
            color: notificationModel.markAsRead
                ? Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"))
                : Colors.grey.shade400,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MaterialButton(
                onPressed: () {},
                color: notificationModel.markAsRead
                    ? Colors.blueAccent
                    : Colors.red,
                textColor: Colors.white,
                child: Icon(
                  notificationModel.markAsRead
                      ? Icons.check
                      : Icons.star,
                  size: 25,
                ),
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      (notificationModel.notificationID.toString() ==
                          NewConnectionRequest)
                          ? Container(
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .center,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: new Text(
                                notificationTitle(notificationModel),
                                style: Theme.of(
                                    context)
                                    .textTheme
                                    .bodyText1
                                    ?.apply(
                                    color: InsColor(
                                        appBloc)
                                        .appTextColor),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                notificationBloc.add(DoPeopleListingActionEvent(
                                    selectedObjectID:
                                    notificationModel
                                        .fromUserID,
                                    currentMenu:
                                    'People',
                                    userName: notificationModel
                                        .fromUserDisplayName,
                                    selectAction:
                                    'Ignore',
                                    consolidationType:
                                    'mainsite'));
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 38.0,
                                color: InsColor(
                                    appBloc)
                                    .appTextColor
                                    .withOpacity(0.5),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                notificationBloc.add(DoPeopleListingActionEvent(
                                    selectedObjectID:
                                    notificationModel
                                        .fromUserID,
                                    currentMenu:
                                    'People',
                                    userName: notificationModel
                                        .fromUserDisplayName,
                                    selectAction:
                                    'Accept',
                                    consolidationType:
                                    'mainsite'));
                              },
                              child: Padding(
                                padding:
                                EdgeInsets.only(
                                    left: 5,
                                    right: 8),
                                child: Icon(
                                  Icons
                                      .check_circle_outlined,
                                  size: 38.0,
                                  color: Colors
                                      .lightGreen,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                          : new Text(
                        notificationTitle(notificationModel),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.apply(
                            color: InsColor(
                                appBloc)
                                .appTextColor),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),

              /*new IconButton(
                                        icon: Icon(Icons.delete,
                                        color: Color(
                                            int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),),
                                        onPressed: ()=> {
                                          notificationBloc.add(DeleteNotiFicationEvent(
                                              userNotificationID: notificationBloc.notificationResponse
                                                  .table1[index].userNotificationID.toString()
                                          )),
                                          refresh()
                                        })*/
            ],
          ),
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  void refresh() {
    notificationBloc.add(NotiFicationDataEvent(recordCount: 10));
  }

  Widget noDataFound(val) {
    return val
        ? Center(
      child: Text(
          appBloc.localstr.commoncomponentLabelNodatalabel,
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              fontSize: 24)),
    )
        : new Container();
  }

  showAlertDialog(BuildContext context, String message, String title) {
    // Create button

    Widget cancelButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        // discussionMainHomeBloc.myDiscussionForumList.removeAt(index);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline2
            ?.apply(color: InsColor(appBloc).appTextColor),
      ),
      content: Text(message,
          style: Theme.of(context)
              .textTheme
              .headline2
              ?.apply(color: InsColor(appBloc).appTextColor)),
      actions: [cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget bottomNavigation() {
    return BlocConsumer<NotificationBloc, NotificationState>(
      bloc: notificationBloc,
      listener: (context, state) {
        if (state is RemoveNotificationState || state is ClearNotificationState) {
          if (state.status == Status.COMPLETED) {
            notificationBloc.isFirstLoading = false;
            appBloc.add(NotificationCountEvent());
          }
        }
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }
      },
      builder: (context, state) {
        if (notificationBloc.isFirstLoading == true) {
          return Container();
        }
        else {
          if(notificationBloc.notificationResponse.table1.isNotEmpty) {
            return Padding(
                padding: EdgeInsets.only(
                    left: 14.0, right: 14.0, bottom: 5.0, top: 5.0),
                child: new Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Visibility(
                            visible: !notificationBloc.notificationResponse.table1.first.markAsRead,
                            child: CommonPrimarySecondaryButton(
                              isPrimary: true,
                              text: 'Mark All as Read',
                              onPressed: () {
                                notificationBloc.add(RemoveNotiFicationEvent());
                                refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 40.w,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Visibility(
                            visible: notificationBloc.notificationResponse.table1.isNotEmpty,
                            child: CommonPrimarySecondaryButton(
                              isPrimary: false,
                              text: 'Clear All',
                              onPressed: () {
                                notificationBloc.add(ClearNotiFicationEvent(
                                    userNotificationID: '-1'));
                                refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
            );
          }
          else {
            return SizedBox();
          }
        }
      },
    );
  }
}
