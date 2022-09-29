import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../configs/constants.dart';
import '../../controllers/connection_controller.dart';
import '../../controllers/my_learning_download_controller.dart';
import '../../controllers/mylearning_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../framework/bloc/app/bloc/app_bloc.dart';
import '../../framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import '../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../framework/bloc/mylearning/state/mylearning_state.dart';
import '../../framework/helpers/ResponsiveWidget.dart';
import '../../framework/helpers/utils.dart';
import '../../framework/repository/mylearning/mylearning_repositry_public.dart';
import '../../models/my_learning/download_feature/mylearning_download_model.dart';
import '../../providers/my_learning_download_provider.dart';
import '../../utils/my_print.dart';
import '../../utils/my_safe_state.dart';
import '../common/app_colors.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';
import 'components/mylearning_component_card.dart';

class MyDownloadsScreen extends StatefulWidget {
  final MyLearningBloc? myLearningBloc;
  final MyLearningDownloadProvider? myLearningDownloadProvider;

  const MyDownloadsScreen({
    Key? key,
    this.myLearningBloc,
    this.myLearningDownloadProvider,
  }) : super(key: key);

  @override
  State<MyDownloadsScreen> createState() => _MyDownloadsScreenState();
}

class _MyDownloadsScreenState extends State<MyDownloadsScreen> with MySafeState {
  bool isFirst = true;
  late MyLearningBloc? myLearningBloc;
  late MyLearningDownloadProvider myLearningDownloadProvider;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  Future<void> showBottomSheetForMyDownloads(context, DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel, {bool isTrackContent = false}) async {
    await showModalBottomSheet(
      shape: AppConstants().bottomSheetShapeBorder(),
      context: context,
      builder: (BuildContext bc) {
        return AppConstants().bottomSheetContainer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BottomSheetDragger(),
                if(!isTrackContent) displayPauseDownload(table2, downloadModel),
                if(!isTrackContent) displayResumeDownload(table2, downloadModel),
                if(!isTrackContent) displayCancelDownload(table2, downloadModel),
                displayRemoveFromDownload(table2, downloadModel, isTrackContent: isTrackContent),
              ],
            ),
          ),
        );
      },
    );
  }

  /// region card functions
  void _onMoreTap({required DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel? downloadModel, isTrackContent = false}) {
    if(downloadModel != null) {
      showBottomSheetForMyDownloads(context, table2, downloadModel, isTrackContent: isTrackContent);
    }
  }

  void _onViewTap(DummyMyCatelogResponseTable2 table2, {bool isArchieved = false, DummyMyCatelogResponseTable2? trackModel}) async {
    if(trackModel != null) {
      NavigationController().navigateToEventTrackListScreen(context: context, myLearningModel: trackModel, isTraxkList: true);
      return;
    }

    bool isValidate = AppDirectory.isValidString(table2.viewprerequisitecontentstatus ?? '');
    print('isValidate:$isValidate');

    if (isValidate) {
      print('ifdataaaaa');
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage +
          '  \"' +
          appBloc.localstr.prerequisLabelContenttypelabel +
          '\" ' +
          appBloc.localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Pre-requisite Sequence',
              style: TextStyle(
                  color: Color(
                    int.parse(
                        '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                  ),
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alertMessage,
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        ))),
                Text(
                    '\n' +
                        table2.viewprerequisitecontentstatus
                            .toString()
                            .split('#%')[1]
                            .split('\$;')[0],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                    )),
                Text(
                    table2.viewprerequisitecontentstatus
                        .toString()
                        .split('#%')[1]
                        .split('\$;')[1],
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        )))
              ],
            ),
            backgroundColor: AppColors.getAppBGColor(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            actions: <Widget>[
              TextButton(
                child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                style: TextButton.styleFrom(primary: Colors.blue,),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }
    else {
      // covered
      bool result = await MyLearningController().decideCourseLaunchMethod(
        context: context,
        table2: table2,
        isContentisolation: false,
      );
      if (!result) {
        table2.isdownloaded = false;
        setState(() {});
      }
    }
  }

  void onDownloadPaused(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloadPaused called:$downloadModel, Task Id:${downloadModel?.taskId}");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().resumeDownload(downloadModel);
    }
  }

  void onDownloading(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloading called");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().pauseDownload(downloadModel);
    }
  }

  void _onDownloadTap(DummyMyCatelogResponseTable2 table2) async {
    MyPrint.printOnConsole("_onDownloadTap called");

    if (table2.isdownloaded) {
      return;
    }

    if(ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
      setState(() {
        table2.isDownloading = true;
        //isLoading = true;
      });

      //bool isDownloaded = await MyLearningController().storeMyLearningContentOffline(context, table2, appBloc.userid);
      bool isDownloaded = await MyLearningDownloadController().storeMyLearningContentOffline(
        context,
        table2,
        appBloc.userid,
        /*checkFileOnServerCallback: () {
          isLoading = false;
          setState(() {});

          //Snakbar().show_info_snakbar(context, "Download Started...");
        },*/
      );
      setState(() {
        table2.isdownloaded = isDownloaded;
        table2.isDownloading = false;
      });
    }
  }
  /// endregion card functions

  @override
  void initState() {
    super.initState();

    if(widget.myLearningBloc != null) {
      myLearningBloc = widget.myLearningBloc;
    }
    else {
      myLearningBloc = MyLearningBloc(myLearningRepository: MyLearningRepositoryPublic());
    }

    if(widget.myLearningDownloadProvider != null) {
      myLearningDownloadProvider = widget.myLearningDownloadProvider!;
    }
    else {
      myLearningDownloadProvider = MyLearningDownloadProvider();
    }

    if(myLearningDownloadProvider.downloads.isEmpty) {
      MyLearningController().getMyDownloads(provider: myLearningDownloadProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    if(isFirst) {
      isFirst = false;
    }

    return BlocConsumer<MyLearningBloc, MyLearningState>(
      bloc: myLearningBloc,
      listener: (BuildContext context, MyLearningState myLearningState) async {

      },
      builder: (BuildContext context, MyLearningState myLearningState) {
        MyPrint.printOnConsole("BlocConsumer builder called for MyLearningBloc in MyDownloadsScreen");

        return ChangeNotifierProvider.value(
          value: myLearningDownloadProvider,
          child: Consumer<MyLearningDownloadProvider>(
            builder: (BuildContext context, MyLearningDownloadProvider myLearningDownloadProvider, Widget? child) {
              MyPrint.printOnConsole("Consumer builder called for MyLearningDownloadProvider in MyDownloadsScreen");

              //List<MyLearningDownloadModel> list = myLearningDownloadProvider.downloads.where((element) => element.isTrackContent == false).toList();
              List<MyLearningDownloadModel> list = myLearningDownloadProvider.downloads;

              if(myLearningDownloadProvider.isLoadingMyDownloads) {
                return Center(
                  child: AbsorbPointer(
                    child: AppConstants().getLoaderWidget(iconSize: 70)
                  ),
                );
              }
              else if (list.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await MyLearningDownloadController().checkDownloadedContentSubscribed();
                    MyLearningController().getMyDownloads();
                  },
                  color: AppColors.getAppButtonBGColor(),
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Downloads",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: AppColors.getAppTextColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              else {
                //MyPrint.printOnConsole("MyDownloads Length:${myLearningDownloadProvider.downloads.length}");

                List<MyLearningDownloadModel> newList = [];
                list.forEach((element) {
                  if(element.trackModel != null && element.trackModel!.contentid.isNotEmpty) {
                    String contentId = element.trackModel!.contentid;
                    List<MyLearningDownloadModel> existingList = newList.where((element) => element.trackModel?.contentid == contentId).toList();
                    if(existingList.isEmpty) {
                      newList.add(element);
                    }
                  }
                  else {
                    newList.add(element);
                  }
                });

                return ResponsiveWidget(
                  mobile: RefreshIndicator(
                    onRefresh: () async {
                      await MyLearningDownloadController().checkDownloadedContentSubscribed();
                      MyLearningController().getMyDownloads();
                    },
                    color: AppColors.getAppButtonBGColor(),
                    child: Container(
                      height: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: false,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: newList.length,
                        itemBuilder: (context, i) {
                          MyLearningDownloadModel myLearningDownloadModel = newList[i];

                          //MyPrint.printOnConsole("Content Id:${myLearningDownloadModel.table2.contentid}, Name:${myLearningDownloadModel.table2.name}");

                          return Container(
                            child: getMyLearningDownloadCard(
                              myLearningDownloadProvider,
                              myLearningDownloadModel.table2,
                              false,
                              context,
                              downloadModel: myLearningDownloadModel,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  tab: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width / 900,
                    ),
                    shrinkWrap: false,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      MyLearningDownloadModel myLearningDownloadModel = list[i];

                      return Container(
                        child: getMyLearningDownloadCard(
                          myLearningDownloadProvider,
                          myLearningDownloadModel.table2,
                          false,
                          context,
                          downloadModel: myLearningDownloadModel,
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget getMyLearningDownloadCard(MyLearningDownloadProvider myLearningDownloadProvider, DummyMyCatelogResponseTable2 table2, bool isArchive, BuildContext context, {MyLearningDownloadModel? downloadModel}) {
    if(downloadModel == null) {
      List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == table2.contentid).toList();
      //MyPrint.printOnConsole("Downloads Length:${downloads.length}");
      if(downloads.isNotEmpty) {
        downloadModel = downloads.first;
      }
    }

    return MyLearningComponentCard(
      table2: downloadModel?.trackModel ?? table2,
      // table2: table2,
      trackModel: downloadModel?.trackModel,
      trackContentId: downloadModel?.trackContentId ?? "",
      trackContentName: downloadModel?.trackContentName ?? "",
      isShowTrackName: false,
      isArchive: isArchive,
      isTrackContent: (downloadModel?.isTrackContent ?? false),
      isDownloadCard: false,
      isShowMoreOption: !(downloadModel?.isTrackContent ?? false),
      onMoreTap: () {
        _onMoreTap(table2: table2, downloadModel: downloadModel, isTrackContent: (downloadModel?.isTrackContent ?? false));
      },
      onViewTap: () => _onViewTap(table2, isArchieved: isArchive, trackModel: downloadModel?.trackModel),
      onDownloadPaused: () {
        onDownloadPaused(downloadModel);
      },
      onDownloading: () {
        onDownloading(downloadModel);
      },
      onDownloaded: () async {
        MyPrint.printOnConsole("onDownloaded called");
      },
      onNotDownloaded: () => _onDownloadTap(table2),
    );
  }


  //region My Downloads Bottomsheet
  Widget displayPauseDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || !downloadModel.table2.isDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
      iconData: Icons.pause,
      text: AppStrings.pause_download,
      onTap: () async {
        MyPrint.printOnConsole('Pause Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        onDownloading(downloadModel);
      },
    );
  }

  Widget displayResumeDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || downloadModel.table2.isDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
      iconData: Icons.play_arrow,
      text: AppStrings.resume_download,
      onTap: () async {
        MyPrint.printOnConsole('Resume Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        onDownloadPaused(downloadModel);
      },
    );
  }

  Widget displayCancelDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
      iconData: Icons.delete,
      text: AppStrings.cancel_download,
      onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().cancelDownload(downloadModel);
        mySetState();
      },
    );
  }

  Widget displayRemoveFromDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel, {bool isTrackContent = false}) {
    if(!downloadModel.isFileDownloaded) {
      return SizedBox();
    }

    return BottomsheetOptionTile(
      iconData: Icons.delete,
      text: AppStrings.remove_downloads,
      onTap: () async {
        MyPrint.printOnConsole('Remove From Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        List<Future> futures = [];
        if(isTrackContent) {
          List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.isTrackContent && element.trackContentId == downloadModel.trackContentId).toList();
          downloads.forEach((element) {
            futures.add(MyLearningDownloadController().removeFromDownload(element));
          });
        }
        else {
          futures.add(MyLearningDownloadController().removeFromDownload(downloadModel));
        }
        await Future.wait(futures);
        mySetState();
      },
    );
  }
  //endregion My Downloads Bottomsheet
}
