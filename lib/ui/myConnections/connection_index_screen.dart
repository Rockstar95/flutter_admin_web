import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/my_connection_bloc.dart';
import 'package:flutter_admin_web/framework/repository/myConnections/myConnection_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import 'connections_screen.dart';

class ConnectionIndexScreen extends StatefulWidget {
  final String searchString;

  ConnectionIndexScreen({this.searchString = ""});

  @override
  _ConnectionIndexScreenState createState() => _ConnectionIndexScreenState();
}

class _ConnectionIndexScreenState extends State<ConnectionIndexScreen> {
  late MyConnectionBloc connectionsBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    connectionsBloc = MyConnectionBloc(myConnectionRepository: MyConnectionRepositoryBuilder.repository());
    connectionsBloc.isFirstLoading = true;
    connectionsBloc.add(GetDynamicTabsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyConnectionBloc, MyConnectionState>(
      bloc: connectionsBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (connectionsBloc.isFirstLoading == true) {
          return Container(
            child: Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70,
                ),
              ),
            ),
          );
        }
        if (connectionsBloc.dynamicTabList.length == 0) {
          return ConnectionScreen(isFromConnectionPage: false);
        }
        return DefaultTabController(
          length: connectionsBloc.dynamicTabList.length,
          child: Scaffold(
            backgroundColor: InsColor(appBloc).appBGColor,
            body: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle: Theme.of(context).textTheme.subtitle2,
                  labelColor: InsColor(appBloc).appTextColor,
                  indicatorColor: InsColor(appBloc).appTextColor,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2.0),
                      insets: EdgeInsets.symmetric(horizontal: 16.0)),
                  tabs: connectionsBloc.dynamicTabList.map((e) {
                    return  Tab(
                              text: e.mobileDisplayName,
                            );
                  }).toList()
                  // [
                  //   // for (var item in connectionsBloc.dynamicTabList.map((e) => e.mobileDisplayName))
                  //
                  //     Tab(
                  //       text: item,
                  //     )
                  // ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (var item in connectionsBloc.dynamicTabList.map((e) => e))
                        ConnectionScreen(
                          dynamicTab: item,
                          searchString: widget.searchString,
                          enableSearching: widget.searchString.isEmpty,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
