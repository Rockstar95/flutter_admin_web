import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/EventTrackList/bloc/event_track_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/states/app_state.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/global_search_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/review_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/share_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/file_course_downloader.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/local_downloading_service.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/zip_course_downloader.dart';
import 'package:flutter_admin_web/framework/local/app_delegate.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/provider/exapmle_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/SplashRepository/splash_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/globalSearch/globalSearch_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/providers/ActBaseProvider.dart';
import 'package:flutter_admin_web/providers/my_learning_download_provider.dart';
import 'package:flutter_admin_web/ui/splash/splash_screen.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../../framework/common/constants.dart';
import '../../framework/helpers/ApiEndpoints.dart';
import '../../providers/connection_provider.dart';
import '../../providers/discussion_forum_provider.dart';

Size appScreenSize = Size(600, 1100);

class App extends StatefulWidget {
  final String mainSiteUrl, appAuthURL, appWebApiUrl, splashScreenLogo;

  const App({
    required this.mainSiteUrl,
    required this.appAuthURL,
    required this.appWebApiUrl,
    required this.splashScreenLogo,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    MyPrint.printOnConsole("App init called");

    ApiEndpoints.mainSiteURL = widget.mainSiteUrl;
    ApiEndpoints.appAuthURL = widget.appAuthURL;
    ApiEndpoints.appWebApiUrl = widget.appWebApiUrl;
    kSplashLogo = widget.splashScreenLogo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //LogUtil().printLog(message: 'Showing app');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionProvider>(create: (_) => ConnectionProvider(), lazy: false,),
        ChangeNotifierProvider<ActBaseProvider>(create: (_) => ActBaseProvider(),),
        ChangeNotifierProvider<MyLearningDownloadProvider>(create: (_) => MyLearningDownloadProvider(),),
        ChangeNotifierProvider<DiscussionForumProvider>(create: (_) => DiscussionForumProvider(),),
        ChangeNotifierProvider<ClassroomEventsController>(create: (_) => ClassroomEventsController(),),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) =>
                AppBloc(splashRepository: SplashRepositoryBuilder.repository()),
          ),
          BlocProvider<ChangeThemeBloc>(
            create: (context) => ChangeThemeBloc(),
          ),
          BlocProvider<MyLearningBloc>(
            create: (BuildContext context) => MyLearningBloc(
                myLearningRepository: MyLearningRepositoryBuilder.repository()),
          ),
          BlocProvider<ReviewBloc>(
            create: (BuildContext context) => ReviewBloc(
                myLearningRepository: MyLearningRepositoryBuilder.repository()),
          ),
          BlocProvider<ShareBloc>(
            create: (BuildContext context) => ShareBloc(
                myLearningRepository: MyLearningRepositoryBuilder.repository()),
          ),
          BlocProvider<EventTrackBloc>(
              create: (BuildContext context) => EventTrackBloc(
                  eventTrackListRepository:
                      EventTrackRepositoryBuilder.repository())),
          BlocProvider<CatalogBloc>(
              create: (BuildContext context) => CatalogBloc(
                  catalogRepository: CatalogRepositoryBuilder.repository())),
          BlocProvider<EvntModuleBloc>(
              create: (BuildContext context) => EvntModuleBloc(
                  eventModuleRepository: EventRepositoryBuilder.repository())),
          BlocProvider<GlobalSearchBloc>(
              create: (BuildContext context) => GlobalSearchBloc(
                  globalSearchRepository:
                      GlobalSearchRepositoryBuilder.repository())),
        ],
        child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
          bloc: changeThemeBloc,
          builder: (BuildContext context, state) {
            return BlocBuilder<AppBloc, AppState>(
              builder: (BuildContext context, appState) {
                return ScreenUtilInit(
                  designSize: appScreenSize,
                  builder: (BuildContext context, Widget? child) {
                    return MainApp(state: state);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  final ChangeThemeState state;
  const MainApp({Key? key, required this.state}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  static void downloadCallback(String taskid, DownloadTaskStatus status, int progress) {
    print("downloadCallback called for TaskId:$taskid, DownloadStatus:$status, Progress:$progress}");

    //This Is New Download Isolate
    SendPort? downloadCoursesendPort = IsolateNameServer.lookupPortByName(DOWNLOAD_COURSE_ISOLATE_NAME);
    print("Sendport:$downloadCoursesendPort");
    downloadCoursesendPort?.send([taskid, status, progress]);

    final SendPort? localDownloadServiceSendPort = IsolateNameServer.lookupPortByName(LocalDownloadService.backgroundIsolateName);
    localDownloadServiceSendPort?.send([taskid, status, progress]);

    final SendPort? fileCourseDownloaderServiceSendPort = IsolateNameServer.lookupPortByName(FileCourseDownloader.backgroundIsolateName);
    fileCourseDownloaderServiceSendPort?.send([taskid, status, progress]);

    final SendPort? zipCourseDownloaderServiceSendPort = IsolateNameServer.lookupPortByName(ZipCourseDownloader.backgroundIsolateName);
    zipCourseDownloaderServiceSendPort?.send([taskid, status, progress]);
  }

  @override
  void initState() {
    MyPrint.printOnConsole('MainApp Init Called');
    if(!kIsWeb) {
      bool isUnregisteredPort = IsolateNameServer.removePortNameMapping(DOWNLOAD_COURSE_ISOLATE_NAME);
      MyPrint.printOnConsole("isUnregisteredPort:$isUnregisteredPort");

      bool isRegisteredPort = IsolateNameServer.registerPortWithName(_port.sendPort, DOWNLOAD_COURSE_ISOLATE_NAME);
      MyPrint.printOnConsole("isRegisteredPort:$isRegisteredPort");

      _port.listen((dynamic data) {
        print("DOWNLOAD_ISOLATE_NAME port received data:$data");

        String taskid = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];

        MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(context, listen: false);
        myLearningDownloadProvider.updateDownloadProgress(taskid: taskid, status: status, progress: progress);
      });

      FlutterDownloader.registerCallback(downloadCallback);
    }
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(DOWNLOAD_COURSE_ISOLATE_NAME);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationController().mainNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Instancy',
      theme: widget.state.themeData,
      home: SplashScreen(false),
      localizationsDelegates: [
        AppTranslationsDelegate(
            newLocale:
            BlocProvider.of<AppBloc>(context).appLocale),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", ""),
        Locale("ar", ""),
        Locale("hi", ""),
      ],
      locale: BlocProvider.of<AppBloc>(context).appLocale,
    );
  }
}
