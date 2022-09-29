import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/ui/classroom_events/event_list_screen.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:provider/provider.dart';

import '../../backend/classroom_events/classroom_events_controller.dart';
import '../../configs/constants.dart';

class EventMainPage2 extends StatefulWidget {
  final String searchString;
  final bool enableSearching;
  final ClassroomEventsController? classroomEventsController;

  const EventMainPage2({
    this.searchString = "",
    this.enableSearching = true,
    this.classroomEventsController,
  });

  @override
  State<EventMainPage2> createState() => _EventMainPage2State();
}

class _EventMainPage2State extends State<EventMainPage2> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isFirst = true;

  int selectedIndex = 0;
  String tabValue = 'upcoming';
  late ClassroomEventsController classroomEventsController;
  ScrollController _sc = new ScrollController();
  late Future<void> getTabsFuture;

  TabController? tabController;
  List<Widget> tabScreensList = [];

  bool isMylearningDataGot = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  Future<void> getTabsList() async {
    await classroomEventsController.getPeopleListingTab(isGetFromCache: true);
    tabController = TabController(length: classroomEventsController.tabList.length, vsync: this);
    tabScreensList = classroomEventsController.tabList.map((e) {
      return EventListScreen(
        tabId: e.tabId,
        tabValue: ClassroomEventsController.getTabValue(e.tabId),
        myLearningBloc: myLearningBloc,
        enableSearching: ClassroomEventsController.getTabValue(e.tabId) != "calendar" ? widget.enableSearching : false,
        searchString: widget.searchString,
        classroomEventsController: classroomEventsController.childControllers[e.tabId],
      );
    }).toList();
    MyPrint.printOnConsole("Tab Controller Assigned");
  }

  @override
  void initState() {
    isMylearningDataGot = false;
    myLearningBloc.add(ResetFilterEvent());
    myLearningBloc.add(GetFilterMenus(
      listNativeModel: appBloc.listNativeModel,
      localStr: appBloc.localstr,
      moduleName: "Training Events",
    ));
    myLearningBloc.add(GetSortMenus("153"));

    if(widget.classroomEventsController != null) {
      classroomEventsController = widget.classroomEventsController!;
    }
    else {
      classroomEventsController = ClassroomEventsController(searchString: widget.searchString, mainMapOfEvents: {});
    }
    getTabsFuture = getTabsList();

    super.initState();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider.value(
      value: classroomEventsController,
      child: Consumer<ClassroomEventsController>(
        builder: (BuildContext context, ClassroomEventsController controller, Widget? child) {
          return FutureBuilder<void>(
            future: getTabsFuture,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return getMainBody(classroomEventsController);
              }
              else {
                return getLoadingWidget();
              }
            },
          );
        },
      ),
    );
  }

  Widget getMainBody(ClassroomEventsController classroomEventsController) {
    MyPrint.printOnConsole('ClassroomEventsBloc Build Called with isFirstLoading:${classroomEventsController.isFirstLoading} and isLoadingTabs:${classroomEventsController.isLoadingTabs}');
    MyPrint.printOnConsole('Child Objects:${classroomEventsController.childControllers.map((key, value) => MapEntry(key, value.hashCode))}');

    if(classroomEventsController.isFirstLoading || classroomEventsController.isLoadingTabs || tabController == null) {
      return getLoadingWidget();
    }

    MyPrint.printOnConsole("Tab Bar View Called");
    return Scaffold(
      body: Column(
        children: [
          getTabBarWidget(classroomEventsController.tabList),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: tabScreensList,
            ),
          ),
        ],
      ),
    );
  }

  Widget getLoadingWidget() {
    return Center(
      child: AbsorbPointer(
        child: AppConstants().getLoaderWidget(iconSize: 70)
      ),
    );
  }

  Widget getTabBarWidget(List<GetPeopleTabListResponse> tabList) {
    if(tabList.isEmpty) {
      return SizedBox();
    }

    return TabBar(
      controller: tabController,
      indicatorColor: AppColors.getAppButtonBGColor(),
      isScrollable: tabList.length > 3,
      tabs: tabList.map((e) {
        return Tab(
          text: e.mobileDisplayName,
        );
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
