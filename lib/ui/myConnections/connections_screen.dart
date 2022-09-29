import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_user_response.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/connection_dynamic_tab_response.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/people_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/my_connection_bloc.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/myConnections/myConnection_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/messages/messages_list.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';

import '../../configs/constants.dart';
import '../common/bottomsheet_option_tile.dart';
import '../global_search_screen.dart';

class LoadingDialog {
  OverlayEntry? _overlay;

  void show(BuildContext context) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        // replace with your own layout
        builder: (context) => ColoredBox(
          color: Color(0x80000000),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}

Color getStatusColor(String state) {
  if (state == "Already Connected") {
    return Colors.green;
  } else if (state == "Request Pending") {
    return Colors.blue; //fromARGB(1, 0, 123, 255);
  } else {
    return Colors.orange;
  }
}

class ConnectionScreen extends StatefulWidget {
  final ConnectionDynamicTab? dynamicTab;
  final bool isFromConnectionPage, enableSearching;
  final String contentId;
  final int authorId;
  final ScrollController? scrollController;
  final String searchString;

  const ConnectionScreen({
    Key? key,
    this.dynamicTab,
    this.isFromConnectionPage = true,
    this.enableSearching = true,
    this.contentId = '',
    this.authorId = 0,
    this.scrollController,
    this.searchString = "",

  })
  : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late MyConnectionBloc connectionsBloc;

  MyConnectionRepository? myConnectionRepository;

  String filterType = '';
  int componentID = 78;
  int componentInstanceID = 3473;
  bool isListView = true;
  late ScrollController _scrollController;
  TextEditingController? _controller;

  @override
  void initState() {
    connectionsBloc = MyConnectionBloc(myConnectionRepository: MyConnectionRepositoryBuilder.repository());
    connectionsBloc.isFirstLoading = true;

    print("Search String:${widget.searchString}");
    print("Enable Searching:${widget.enableSearching}");
    print("isFromConnectionPage:${widget.isFromConnectionPage}");

    connectionsBloc.searchString = widget.searchString;
    if (widget.isFromConnectionPage) {
      filterType = widget.dynamicTab?.tabId.replaceAll(RegExp('-'), '') ?? "";
      connectionsBloc.add(GetPeopleListEvent(
        isRefresh: true,
        componentID: componentID,
        componentInstanceID: componentInstanceID,
        filterType: filterType,
        contentid: widget.contentId,
        searchText: connectionsBloc.searchString,
      ));
      _scrollController = widget.scrollController ?? ScrollController();
    }
    else {
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
      filterType = 'All';
      componentID = 78;
      componentInstanceID = 3473;
      connectionsBloc.add(GetPeopleListEvent(
        isRefresh: true,
        componentID: componentID,
        componentInstanceID: componentInstanceID,
        filterType: filterType,
        contentid: widget.contentId,
        searchText: connectionsBloc.searchString,
      ));
    }

    print("Author ID : " + widget.authorId.toString());

    super.initState();
  }

  _showConfirmationDialog(BuildContext context, String message) async {
    //print("MESSAGE :" + message);
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: new Text(
                      message,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(appBloc.localstr.myconnectionsAlertbuttonOkbutton),
                onPressed: () {
                  Navigator.pop(context);
                  if(widget.enableSearching) {
                    connectionsBloc.searchString = "";
                    _controller?.clear();
                  }
                  connectionsBloc.add(GetPeopleListEvent(
                    isRefresh: true,
                    componentID: componentID,
                    componentInstanceID: componentInstanceID,
                    filterType: filterType,
                    contentid: widget.contentId,
                    searchText: connectionsBloc.searchString,
                  ));
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    return Scaffold(
      backgroundColor: InsColor(appBloc).appBGColor,
      body: BlocConsumer<MyConnectionBloc, MyConnectionState>(
        bloc: connectionsBloc,
        listener: (context, state) {
          /*if (connectionsBloc.showLoader == true && !connectionsBloc.isFirstLoading) {
            print('its passing' + connectionsBloc.showLoader.toString());
            _loadingOverlay.show(context);
          }
          else {
            _loadingOverlay.hide();
          }*/

          if (state is AddConnectionState && state.status == Status.COMPLETED && connectionsBloc.isAddLoading == false) {
            _showConfirmationDialog(context, state.message);
          }

          if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        },
        builder: (context, state) {
          if (connectionsBloc.isFirstLoading == true) {
            return Container(
              color: InsColor(appBloc).appBGColor,
              child: Center(
                child: AbsorbPointer(
                  child: AppConstants().getLoaderWidget(iconSize: 70),
                ),
              ),
            );
          }
          // else if (state.status == Status.ERROR) {
          //   return noDataFound(true);
          // }

          _controller = TextEditingController(text: connectionsBloc.searchString);

          print("Enable Searching:${widget.enableSearching}");

          if (connectionsBloc.allConnectionList.length == 0 && connectionsBloc.searchString.length > 0) {
            return Container(
              color: InsColor(appBloc).appBGColor,
              child: Column(
                children: [
                  Visibility(
                    visible: widget.isFromConnectionPage,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${connectionsBloc.peopleCount} Connections',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.apply(color: InsColor(appBloc).appTextColor),
                            // style: TextStyle(
                            //     color: Color(int.parse(
                            //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            // ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.grid_view,
                                color: InsColor(appBloc).appIconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isListView = !isListView;
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isFromConnectionPage && widget.enableSearching,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Container(
                          color: InsColor(appBloc).appBGColor,
                          height: 44,
                          child: InsSearchTextField(
                            onTapAction: () {
                              if (appBloc.uiSettingModel.isGlobalSearch ==
                                  'true') {
                                _navigateToGlobalSearchScreen(context);
                              }
                            },
                            controller: _controller,
                            appBloc: appBloc,
                            suffixIcon: connectionsBloc.searchString.length > 0
                                ? IconButton(
                                    onPressed: () {
                                      connectionsBloc.isArchiveFirstLoading =
                                          true;
                                      connectionsBloc.searchString = "";
                                      print(_controller?.text);
                                      _controller?.clear();

                                      connectionsBloc.add(GetPeopleListEvent(
                                        isRefresh: true,
                                          componentID: componentID,
                                          componentInstanceID: componentInstanceID,
                                          searchText: connectionsBloc.searchString,
                                          filterType: filterType,
                                          contentid: widget.contentId));
                                    },
                                    icon: Icon(
                                      Icons.close,
                                    ),
                                  )
                                : null,
                            onSubmitAction: (value) {
                              if (value.toString().length > 0) {
                                connectionsBloc.isArchiveFirstLoading = true;
                                connectionsBloc.searchString = value.toString();
                                setState(() {
                                  //pageArchiveNumber = 1;
                                });
                                connectionsBloc.add(GetPeopleListEvent(
                                  isRefresh: true,
                                    componentID: componentID,
                                    componentInstanceID: componentInstanceID,
                                    searchText: connectionsBloc.searchString,
                                    filterType: filterType,
                                    contentid: widget.contentId));
                              }
                            },
                          )),
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Center(
                      child: Text(
                        appBloc.localstr.commoncomponentLabelNodatalabel,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          }

          if (connectionsBloc.allConnectionList.length == 0) {
            return Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: Center(
                child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.apply(color: InsColor(appBloc).appTextColor)),
              ),
            );
          }

          return Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Column(
              children: [
                Visibility(
                  visible: widget.isFromConnectionPage && widget.enableSearching,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Container(
                        height: 44,
                        child: InsSearchTextField(
                          onTapAction: () {
                            if (appBloc.uiSettingModel.isGlobalSearch ==
                                'true') {
                              _navigateToGlobalSearchScreen(context);
                            }
                          },
                          controller: _controller,
                          appBloc: appBloc,
                          suffixIcon: connectionsBloc.searchString.length > 0
                              ? IconButton(
                                  onPressed: () {
                                    connectionsBloc.isArchiveFirstLoading = true;
                                    connectionsBloc.searchString = "";
                                    print(_controller?.text);
                                    _controller?.clear();
                                    connectionsBloc.add(GetPeopleListEvent(
                                      isRefresh: true,
                                        componentID: componentID,
                                        componentInstanceID: componentInstanceID,
                                        searchText: connectionsBloc.searchString,
                                        filterType: filterType,
                                        contentid: widget.contentId));
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: InsColor(appBloc).appIconColor,
                                  ),
                                )
                              : null,
                          onSubmitAction: (value) {
                            if (value.toString().length > 0) {
                              connectionsBloc.isArchiveFirstLoading = true;
                              connectionsBloc.searchString = value.toString();
                              setState(() {
                                //pageArchiveNumber = 1;
                              });
                              connectionsBloc.add(GetPeopleListEvent(
                                isRefresh: true,
                                  componentID: componentID,
                                  componentInstanceID: componentInstanceID,
                                  searchText: connectionsBloc.searchString,
                                  filterType: filterType,
                                  contentid: widget.contentId));
                            }
                          },
                        )),
                  ),
                ),
                Visibility(
                  visible: widget.isFromConnectionPage,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            filterType =="AllPeople"?"${connectionsBloc.peopleCount} People":'${connectionsBloc.peopleCount} Connections',
                         // 'FCBFAJKBC',
                          style: TextStyle(color: AppColors.getAppTextColor().withOpacity(0.54),fontSize: 14)
                          // style: TextStyle(
                          //     color: Color(int.parse(
                          //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                          // ),
                        ),
                        IconButton(
                            icon: Icon(
                              isListView
                                  ? Icons.format_list_bulleted_rounded
                                  : Icons.grid_on_rounded,
                              color: InsColor(appBloc).appIconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isListView = !isListView;
                              });
                            })
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: widget.authorId != 0 && connectionsBloc != null,
                    child: widget.authorId == 0
                        ? Container()
                        : Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Author',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.apply(
                                            color:
                                                InsColor(appBloc).appTextColor),
                                  ),
                                ),
                                PeopleListCell(
                                  appBloc: appBloc,
                                  shortcurname: "",
                                  people: connectionsBloc.allConnectionList
                                      .firstWhere(
                                          (element) => (element.objectId ==
                                              widget.authorId),
                                          orElse: () => PeopleModel()),
                                  addConnectionTap: (objId, userName) {
                                    _showOptions(connectionsBloc
                                        .allConnectionList
                                        .firstWhere((element) =>
                                            element.objectId ==
                                            widget.authorId));
                                    //print(objId.toString());
                                  },
                                  onTap: () {
                                    //connectionsBloc.allConnectionList[index].objectId;
                                    return;
                                  },
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${connectionsBloc.peopleCount} Connections',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.apply(
                                            color:
                                                InsColor(appBloc).appTextColor),
                                    // style: TextStyle(
                                    //     color: Color(int.parse(
                                    //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                Expanded(
                  child: isListView
                      ? ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          controller: _scrollController,
                          itemCount: connectionsBloc.allConnectionList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if((index == 0 && connectionsBloc.allConnectionList.isEmpty) || index == connectionsBloc.allConnectionList.length) {
                              if(connectionsBloc.isLoadingUsers) {
                                return AbsorbPointer(
                                  child: AppConstants().getLoaderWidget(iconSize: 70),
                                );
                              }
                              else return SizedBox();
                            }

                            if(index > connectionsBloc.allConnectionList.length - 3 && connectionsBloc.hasMoreUsers && !connectionsBloc.isLoadingUsers) {
                              connectionsBloc.add(GetPeopleListEvent(
                                  isRefresh: false,
                                  componentID: componentID,
                                  componentInstanceID: componentInstanceID,
                                  searchText: connectionsBloc.searchString,
                                  filterType: filterType,
                                  contentid: widget.contentId));
                            }

                            StringBuffer username = StringBuffer("");

                            try {
                              String name = connectionsBloc.allConnectionList[index].userDisplayname;
                              List<String> nameinfo = name.split(" ");
                              if (nameinfo.length > 1) {
                                for (int i = 0; i < nameinfo.length; i++) {
                                  username.write(nameinfo[i].isNotEmpty ? nameinfo[i][0] : "");
                                }
                              }
                              else if (nameinfo.length == 1) {
                                username.write(name[0]);
                              }
                              else {}
                            }
                            catch (e, s) {
                              print(e);
                              print(s);
                            }

                            return new Container(
                              child: PeopleListCell(
                                appBloc: appBloc,
                                shortcurname: username.toString(),
                                people:
                                    connectionsBloc.allConnectionList[index],
                                addConnectionTap: (objId, userName) {
                                  _showOptions(connectionsBloc.allConnectionList[index]);
                                  //print(objId.toString());
                                },
                                onTap: () {
                                  return;
                                },
                              ),
                            );
                          },
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          // gridDelegate:
                          //     new SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 2),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height /
                                        (useMobileLayout ? 2 : 5)),
                          ),
                          itemCount: connectionsBloc.allConnectionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            StringBuffer username = StringBuffer("");

                            try {
                              String name = connectionsBloc.allConnectionList[index].userDisplayname;
                              List<String> nameinfo = name.split(" ");
                              if (nameinfo.length > 1) {
                                for (int i = 0; i < nameinfo.length; i++) {
                                  username.write(nameinfo[i].isNotEmpty ? nameinfo[i][0] : "");
                                }
                              }
                              if (nameinfo.length == 1) {
                                username.write(name[0]);
                              } else {}
                            } catch (e) {
                              print(e);
                            }

                            return useMobileLayout
                                ? new Container(
                                    child: PeopleGridCell(
                                        appBloc: appBloc,
                                        shortcurname: username.toString(),
                                        people: connectionsBloc
                                            .allConnectionList[index],
                                        addConnectionTap: (objId, userName) {
                                          _showOptions(connectionsBloc
                                              .allConnectionList[index]);
                                          //print(objId.toString());
                                        },
                                        onTap: () {
                                          return;
                                        }),
                                  )
                                : new Container(
                                    child: PeopleListCell(
                                      appBloc: appBloc,
                                      shortcurname: username.toString(),
                                      people: connectionsBloc
                                          .allConnectionList[index],
                                      addConnectionTap: (objId, userName) {
                                        _showOptions(connectionsBloc
                                            .allConnectionList[index]);
                                        //print(objId.toString());
                                      },
                                      onTap: () {
                                        return;
                                      },
                                    ),
                                  );
                            // return ResponsiveWidget(
                            //   mobile: new Container(
                            //     child: PeopleGridCell(
                            //         appBloc: appBloc,
                            //         Shortcurname: buffer.toString(),
                            //         people: connectionsBloc
                            //             .allConnectionList[index],
                            //         addConnectionTap: (objId, userName) {
                            //           _showOptions(connectionsBloc
                            //               .allConnectionList[index]);
                            //           //print(objId.toString());
                            //         },
                            //         onTap: () {
                            //           var objId = connectionsBloc
                            //               .allConnectionList[index].objectId;
                            //
                            //           return;
                            //           Navigator.of(context).push(
                            //               MaterialPageRoute(
                            //                   builder: (context) => Profile(
                            //                       isFromProfile: false,
                            //                       connectionUserId:
                            //                           objId.toString())));
                            //         }),
                            //   ),
                            //   tab: new Container(
                            //     child: PeopleListCell(
                            //       appBloc: appBloc,
                            //       Shortcurname: buffer.toString(),
                            //       people: connectionsBloc
                            //           .allConnectionList[index],
                            //       addConnectionTap: (objId, userName) {
                            //         _showOptions(connectionsBloc
                            //             .allConnectionList[index]);
                            //         //print(objId.toString());
                            //       },
                            //       onTap: () {
                            //         var objId = connectionsBloc
                            //             .allConnectionList[index].objectId;
                            //         return;
                            //       },
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 3185)),
    );
    print("Result:$result");

    if (result != null) {
      connectionsBloc.isArchiveFirstLoading = true;
      connectionsBloc.searchString = result.toString();
      setState(() {
        //pageArchiveNumber = 1;
      });
      connectionsBloc.add(GetPeopleListEvent(
        isRefresh: true,
          componentID: componentID,
          componentInstanceID: componentInstanceID,
          searchText: connectionsBloc.searchString,
          filterType: filterType,
          contentid: widget.contentId));
    }
  }

  _scrollListener() {
    /*
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      connectionsBloc.add(GetPeopleListEvent(
          componentID: componentID,
          componentInstanceID: componentInstanceID,
          pageIndex: pageIndex + 1,
          filterType: filterType,
          contentid: widget.contentId));
      setState(() {
        //message = "reach the bottom";
      });
    }
    */
  }

  Widget customListTile(IconData icon, String title,{Function()? onTap} ){
    return BottomsheetOptionTile(
      iconData: icon,
      text: title,
      onTap: onTap,
    );

    //   Container(
    //   child: InkWell(
    //     onTap: onTap,
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal:16).copyWith(bottom: 30),
    //       child: Row(
    //         children: [
    //           Icon(
    //             icon,
    //             color: InsColor(appBloc).appIconColor,
    //           ),
    //           SizedBox(width: 13,),
    //           Text(title,
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .headline2
    //                 ?.apply(
    //                 color: InsColor(appBloc).appTextColor),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  void commonShowDialog(PeopleModel people){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          contentPadding: const EdgeInsets.all(8.0),
          content: Container(
            width:
            MediaQuery.of(context).size.width /
                2.5,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(16.0),
                    child: Text(
                        appBloc.localstr
                            .myconnectionsAlertsubtitleAreyousurewanttoremoveconnection,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.apply(
                            color: InsColor(
                                appBloc)
                                .appTextColor)),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new MaterialButton(
                child: Text(
                    appBloc.localstr
                        .mylearningAlertbuttonCancelbutton,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.apply(
                        color: InsColor(appBloc)
                            .appTextColor)),
                onPressed: () async {
                  Navigator.pop(context);
                }),
            new MaterialButton(
                child: Text(
                    appBloc.localstr
                        .myskillAlerttitleStringconfirm,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.apply(
                        color: InsColor(appBloc)
                            .appTextColor)),
                onPressed: () {
                  connectionsBloc.add(
                      AddConnectionEvent(
                          selectedObjectID:
                          people.objectId,
                          userName: people
                              .userDisplayname,
                          selectAction:
                          'RemoveConnection'));
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  _showOptions(PeopleModel people) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    if (people.connectionstateAccept != "" || people.connectionstate != "") {
      //return;
    }
    ChatUser user = new ChatUser(
        userId: people.connectionUserId.toString(),
        fullName: people.userDisplayname,
        profPic: people.memberProfileImage);

    print(people.toJson().toString());

    return (
      showModalBottomSheet<void>(
      context: context,
      shape: AppConstants().bottomSheetShapeBorder(),
      builder: (BuildContext context) {
        return AppConstants().bottomSheetContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetDragger(),
              SizedBox(height: 10,),
              if (people.connectionstate.trim() == "Already Connected")
                Column(
                  children: [
                    customListTile(Icons.remove_circle_outlined, appBloc.localstr.myconnectionsActionsheetRemoveconnectionoption,
                    onTap: (){
                      commonShowDialog(people);
                     }
                    ),
                    // ListTile(
                    //     leading: new Icon(
                    //       Icons.remove_circle_outlined,
                    //       color: InsColor(appBloc).appIconColor,
                    //     ),
                    //     title: Align(
                    //       alignment: Alignment(useMobileLayout ? -1.25 : -1.1, 0),
                    //       child: Text(appBloc.localstr.myconnectionsActionsheetRemoveconnectionoption,
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .headline2
                    //             ?.apply(
                    //                 color: InsColor(appBloc).appTextColor),
                    //       ),
                    //     ),
                    //     onTap: () => {
                    //           showDialog<String>(
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               return new AlertDialog(
                    //                 backgroundColor: Color(int.parse(
                    //                     "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    //                 contentPadding: const EdgeInsets.all(8.0),
                    //                 content: Container(
                    //                   width:
                    //                       MediaQuery.of(context).size.width /
                    //                           2.5,
                    //                   child: new Row(
                    //                     children: <Widget>[
                    //                       new Expanded(
                    //                         child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.all(16.0),
                    //                           child: Text(
                    //                               appBloc.localstr
                    //                                   .myconnectionsAlertsubtitleAreyousurewanttoremoveconnection,
                    //                               style: Theme.of(context)
                    //                                   .textTheme
                    //                                   .headline2
                    //                                   ?.apply(
                    //                                       color: InsColor(
                    //                                               appBloc)
                    //                                           .appTextColor)),
                    //                         ),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 actions: <Widget>[
                    //                   new FlatButton(
                    //                       child: Text(
                    //                           appBloc.localstr
                    //                               .mylearningAlertbuttonCancelbutton,
                    //                           style: Theme.of(context)
                    //                               .textTheme
                    //                               .subtitle2
                    //                               ?.apply(
                    //                                   color: InsColor(appBloc)
                    //                                       .appTextColor)),
                    //                       onPressed: () async {
                    //                         Navigator.pop(context);
                    //                       }),
                    //                   new FlatButton(
                    //                       child: Text(
                    //                           appBloc.localstr
                    //                               .myskillAlerttitleStringconfirm,
                    //                           style: Theme.of(context)
                    //                               .textTheme
                    //                               .subtitle2
                    //                               ?.apply(
                    //                                   color: InsColor(appBloc)
                    //                                       .appTextColor)),
                    //                       onPressed: () {
                    //                         connectionsBloc.add(
                    //                             AddConnectionEvent(
                    //                                 selectedObjectID:
                    //                                     people.objectId,
                    //                                 userName: people
                    //                                     .userDisplayname,
                    //                                 selectAction:
                    //                                     'RemoveConnection'));
                    //                         Navigator.pop(context);
                    //                         Navigator.pop(context);
                    //                         //Navigator.pop(context);
                    //                       })
                    //                 ],
                    //               );
                    //             },
                    //           ) //Navigator.pop(context);
                    //         }),
                    customListTile(Icons.message_rounded, 'Send Message',onTap: ()=>{
                      Navigator.pop(context),
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context) =>
                              MessagesList(toUser: user)))
                          .then((value) => {
                        connectionsBloc.add(
                            GetPeopleListEvent(
                                isRefresh: true,
                                componentID: componentID,
                                componentInstanceID: componentInstanceID,
                                searchText: connectionsBloc.searchString,
                                filterType: filterType,
                                contentid: widget.contentId))
                      })
                    })
                    // ListTile(
                    //     leading: new Icon(
                    //       Icons.message_rounded,
                    //       color: InsColor(appBloc).appIconColor,
                    //     ),
                    //     title: Align(
                    //         alignment:
                    //             Alignment(useMobileLayout ? -1.2 : -1.1, 0),
                    //         child: Text(c,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .headline2
                    //                 ?.apply(
                    //                     color: InsColor(appBloc)
                    //                         .appTextColor)) //Text(appBloc
                    //         //.localstr.myconnectionsActionsheetViewprofileoption),
                    //         ),
                    //     onTap: () => {
                    //           Navigator.pop(context),
                    //           Navigator.of(context)
                    //               .push(MaterialPageRoute(
                    //                   builder: (context) =>
                    //                       MessagesList(toUser: user)))
                    //               .then((value) => {
                    //                     connectionsBloc.add(
                    //                         GetPeopleListEvent(
                    //                           isRefresh: true,
                    //                             componentID: componentID,
                    //                             componentInstanceID: componentInstanceID,
                    //                             searchText: connectionsBloc.searchString,
                    //                             filterType: filterType,
                    //                             contentid: widget.contentId))
                    //                   })
                    //         })
                  ],
                )
              else if (people.connectionstate == "Request Pending")
                Column(
                  children: [
                    customListTile( Icons.add_circle,  appBloc.localstr.myconnectionsActionsheetAcceptconnectionoption,onTap: ()=>{
                      connectionsBloc.isAddLoading = true,
                      connectionsBloc.add(AddConnectionEvent(
                          selectedObjectID: people.objectId,
                          userName: people.userDisplayname,
                          selectAction: 'Accept')),
                      Navigator.pop(context)
                    }),
                    // ListTile(
                    //     leading: new Icon(
                    //       Icons.add_circle,
                    //       color: InsColor(appBloc).appIconColor,
                    //     ),
                    //
                    //     title: Align(
                    //       alignment:
                    //           Alignment(useMobileLayout ? -1.23 : -1.1, 0),
                    //       child: Text(
                    //           appBloc.localstr
                    //               .myconnectionsActionsheetAcceptconnectionoption,
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .headline2
                    //               ?.apply(color: InsColor(appBloc).appTextColor)),
                    //     ),
                    //     onTap: () => {
                    //           connectionsBloc.isAddLoading = true,
                    //           connectionsBloc.add(AddConnectionEvent(
                    //               selectedObjectID: people.objectId,
                    //               userName: people.userDisplayname,
                    //               selectAction: 'Accept')),
                    //           Navigator.pop(context)
                    //         }),
                    customListTile(Icons.remove_circle_outlined, 'Reject Connection',onTap: ()=>{
                      connectionsBloc.isAddLoading = true,
                      connectionsBloc.add(AddConnectionEvent(
                          selectedObjectID: people.objectId,
                          userName: people.userDisplayname,
                          selectAction: 'Ignore')),
                      Navigator.pop(context)
                    }),
                    // ListTile(
                    //     leading: new Icon(Icons.remove_circle_outlined,
                    //         color: InsColor(appBloc).appIconColor),
                    //     title: Align(
                    //         alignment:
                    //             Alignment(useMobileLayout ? -1.23 : -1.1, 0),
                    //         child: Text('Reject Connection',
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .headline2
                    //                 ?.apply(
                    //                     color: InsColor(appBloc)
                    //                         .appTextColor))), //appBloc.localstr
                    //     //.myconnectionsActionsheetAcceptconnectionoption),
                    //     onTap: () => {
                    //           connectionsBloc.isAddLoading = true,
                    //           connectionsBloc.add(AddConnectionEvent(
                    //               selectedObjectID: people.objectId,
                    //               userName: people.userDisplayname,
                    //               selectAction: 'Ignore')),
                    //           Navigator.pop(context)
                    //         })
                  ],
                )
              else if ((people.addToMyConnectionAction.length) > 0)
                  customListTile(Icons.add_circle,"Add to My Connection",onTap: ()=>{
                    connectionsBloc.isAddLoading = true,
                    connectionsBloc.add(AddConnectionEvent(
                        selectedObjectID: people.objectId,
                        userName: people.userDisplayname,
                        selectAction: 'AddConnection')),
                    Navigator.pop(context)
                  }),
                // ListTile(
                //     leading: new Icon(
                //       Icons.add_circle,
                //       color: InsColor(appBloc).appIconColor,
                //     ),
                //     title: Align(
                //       alignment: Alignment(useMobileLayout ? -1.2 : -1.1, 0),
                //       child: Text("Add to My Connection",
                //           style: Theme.of(context)
                //               .textTheme
                //               .headline2
                //               ?.apply(color: InsColor(appBloc).appTextColor)),
                //       //appBloc
                //       //.localstr.profileActionsheetAddtomyconnectionsoption),
                //     ),
                //     onTap: () => {
                //           connectionsBloc.isAddLoading = true,
                //           connectionsBloc.add(AddConnectionEvent(
                //               selectedObjectID: people.objectId,
                //               userName: people.userDisplayname,
                //               selectAction: 'AddConnection')),
                //           Navigator.pop(context)
                //         }),
              Visibility(
                visible: people.viewProfileAction.isEmpty ? false : true,
                child: customListTile( Icons.account_circle_rounded,'View Profile',onTap: ()=>{
                  Navigator.pop(context),
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) => Profile(
                        isFromProfile: false,
                        connectionUserId:
                        people.objectId.toString(),
                        people: people,
                      )))
                      .then((value) => {
                    connectionsBloc.add(GetPeopleListEvent(
                        isRefresh: true,
                        componentID: componentID,
                        componentInstanceID: componentInstanceID,
                        searchText: connectionsBloc.searchString,
                        filterType: filterType,
                        contentid: widget.contentId))
                  })
                })
                // ListTile(
                //     leading: new Icon(
                //       Icons.account_circle_rounded,
                //       color: InsColor(appBloc).appIconColor,
                //     ),
                //     title: Align(
                //         alignment:
                //             Alignment(useMobileLayout ? -1.2 : -1.09, 0),
                //         child: Text('View Profile',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headline2
                //                 ?.apply(
                //                     color: InsColor(appBloc)
                //                         .appTextColor)) //Text(appBloc
                //         //.localstr.myconnectionsActionsheetViewprofileoption),
                //         ),
                //     onTap: () => {
                //           Navigator.pop(context),
                //           Navigator.of(context)
                //               .push(MaterialPageRoute(
                //                   builder: (context) => Profile(
                //                         isFromProfile: false,
                //                         connectionUserId:
                //                             people.objectId.toString(),
                //                         people: people,
                //                       )))
                //               .then((value) => {
                //                     connectionsBloc.add(GetPeopleListEvent(
                //                       isRefresh: true,
                //                         componentID: componentID,
                //                         componentInstanceID: componentInstanceID,
                //                         searchText: connectionsBloc.searchString,
                //                         filterType: filterType,
                //                         contentid: widget.contentId))
                //                   })
                //         }),
              ),
              Visibility(
                visible: people.sendMessageAction.isEmpty ? false : true,
                child: customListTile(Icons.message_rounded, 'Send Message',onTap: ()=>{
                  Navigator.pop(context),
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) => Profile(
                        isFromProfile: false,
                        connectionUserId:
                        people.objectId.toString(),
                        people: people,
                      )))
                      .then((value) => {
                    connectionsBloc.add(GetPeopleListEvent(
                        isRefresh: true,
                        componentID: componentID,
                        componentInstanceID: componentInstanceID,
                        searchText: connectionsBloc.searchString,
                        filterType: filterType,
                        contentid: widget.contentId))
                  })
                })
                // ListTile(
                //     leading: new Icon(
                //       Icons.message_rounded,
                //       color: InsColor(appBloc).appIconColor,
                //     ),
                //     title: Align(
                //         alignment:
                //             Alignment(useMobileLayout ? -1.2 : -1.1, 0),
                //         child: Text('Send Message',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headline2
                //                 ?.apply(
                //                     color: InsColor(appBloc)
                //                         .appTextColor)) //Text(appBloc
                //         //.localstr.myconnectionsActionsheetViewprofileoption),
                //         ),
                //     onTap: () => {
                //           Navigator.pop(context),
                //           Navigator.of(context)
                //               .push(MaterialPageRoute(
                //                   builder: (context) => Profile(
                //                         isFromProfile: false,
                //                         connectionUserId:
                //                             people.objectId.toString(),
                //                         people: people,
                //                       )))
                //               .then((value) => {
                //                     connectionsBloc.add(GetPeopleListEvent(
                //                       isRefresh: true,
                //                         componentID: componentID,
                //                         componentInstanceID: componentInstanceID,
                //                         searchText: connectionsBloc.searchString,
                //                         filterType: filterType,
                //                         contentid: widget.contentId))
                //                   })
                //         }),
              ),
            ],
          ),
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class PeopleListCell extends StatelessWidget {
  final void Function()? onTap;
  final Function addConnectionTap;
  final PeopleModel people;
  final AppBloc appBloc;
  final String shortcurname;

  PeopleListCell(
      {Key? key,
      required this.people,
      this.onTap,
      required this.addConnectionTap,
      required this.shortcurname,
      required this.appBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${ApiEndpoints.strSiteUrl}${feedback.userProfilePathdata}');
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        decoration: BoxDecoration(
          color: InsColor(appBloc).appBGColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 2.0),
          ],
          border: Border.all(color: Color(0xFFE1E1E1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: people.memberProfileImage == "" ||
                      people.memberProfileImage == null
                  ? CircleAvatar(
                      radius: 45.h,
                      child: Text(
                        '$shortcurname',
                        style: TextStyle(
                            fontSize: 30.h,
                            fontWeight: FontWeight.w600,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                      ),
                      backgroundColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: people.memberProfileImage.contains('http')
                            ? '${people.memberProfileImage}'
                            : '${ApiEndpoints.strSiteUrl}${people.memberProfileImage}',
                        width: 50,
                        height: 50,
                        placeholder: (context, url) {
                          return Image.asset(
                            'assets/user.gif',
                            width: 60,
                            fit: BoxFit.fill,
                          );
                        },
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/user.gif',
                          width: 60,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              // child: CircleAvatar(
              //   radius: 30,
              //   backgroundColor: Color(0xffFDCF09),
              //   child: CircleAvatar(
              //     radius: 30,
              //     backgroundImage: NetworkImage(people.memberProfileImage
              //             .contains('http')
              //         ? '${people.memberProfileImage}'
              //         : '${ApiEndpoints.strSiteUrl}${people.memberProfileImage}'),
              //     backgroundColor: Colors.grey.shade100,
              //   ),
              // ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(people.userDisplayname,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.apply(color: AppColors.getAppTextColor())
                          // style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: Color(int.parse(
                          //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))
                          ),
                    ),
                    Visibility(
                      visible: people.mainOfficeAddress.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0,).copyWith(top: 5),
                        child: Text(people.mainOfficeAddress,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.apply(color: AppColors.getAppTextColor().withOpacity(0.54))),
                        // style: TextStyle(
                        //     color: Color(int.parse(
                        //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                      ),
                    ),
                    // Container(
                    //   //padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: Visibility(
                    //     visible: (people.interestAreas.length) > 0,
                    //     child: Container(
                    //         padding:
                    //             const EdgeInsets.symmetric(horizontal: 8.0),
                    //         decoration: BoxDecoration(
                    //             color: Color(int.parse("0xFFECF1F5")),
                    //             border: Border.all(
                    //               color: InsColor(appBloc)
                    //                   .appTextColor
                    //                   .withAlpha(0),
                    //             ),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(20))),
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(2.0),
                    //           child: Text(
                    //             (people.interestAreas).split("</span>").last,
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.w600,
                    //                 color: Color(int.parse("0xFF1D293F")),
                    //                 fontSize: 11),
                    //             softWrap: false,
                    //             overflow: TextOverflow.fade,
                    //           ),
                    //         )),
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: Text(getConnectionStatus(),
                    //       style: TextStyle(
                    //           color: getStatusColor(people.connectionstate == ""
                    //               ? people.connectionstateAccept
                    //               : people.connectionstate),
                    //           fontSize: 12)),
                    // )
                  ],
                ),
                //color: Colors.red,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.more_vert_rounded,
                    color: InsColor(appBloc).appIconColor),
                onPressed: () {
                  addConnectionTap(people.objectId, people.userDisplayname);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getConnectionStatus() {
    var status = (people.connectionstate == ""
        ? people.connectionstateAccept
        : people.connectionstate);
    if (people.connectedDays != '') {
      // status = status + '\n' + (people.connectedDays);
      status =(people.connectedDays);
    }
    return status;
  }
}

class PeopleGridCell extends StatelessWidget {
  final void Function()? onTap;
  final Function addConnectionTap;
  final PeopleModel people;
  final AppBloc appBloc;
  final String shortcurname;

  PeopleGridCell(
      {Key? key,
      required this.people,
      this.onTap,
      required this.addConnectionTap,
      required this.shortcurname,
      required this.appBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${ApiEndpoints.strSiteUrl}${feedback.userProfilePathdata}');
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            // height: 80,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: InsColor(appBloc).appBGColor,
              border: Border.all(color: AppColors.getFilterIconColor().withOpacity(0.54)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 2.0),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(child: Container()),
                      Center(
                        child: people.memberProfileImage == "" ||
                                people.memberProfileImage == null
                            ? CircleAvatar(
                                radius: 45.h,
                                child: Text(
                                  '$shortcurname',
                                  style: TextStyle(
                                      fontSize: 30.h,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.getAppTextColor()),
                                ),
                                backgroundColor:AppColors.getAppButtonBGColor()
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: people.memberProfileImage
                                          .contains('http')
                                      ? '${people.memberProfileImage}'
                                      : '${ApiEndpoints.strSiteUrl}${people.memberProfileImage}',
                                  width: 60,
                                  height: 60,
                                  placeholder: (context, url) {
                                    return Image.asset(
                                      'assets/user.gif',
                                      width: 60,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/user.gif',
                                    width: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            people.userDisplayname,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.apply(color: AppColors.getAppTextColor()),
                            // style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     color: Color(int.parse(
                            //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))
                          ),
                        ),
                        Visibility(
                          visible: people.mainOfficeAddress.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Text(
                             people.mainOfficeAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.apply(color: AppColors.getAppTextColor().withOpacity(.54)),
                              // style: TextStyle(
                              //     color: Color(int.parse(
                              //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),

                        Visibility(
                            visible: people.interestAreas.isNotEmpty,
                            child:Container(
                              alignment: Alignment.center,
                              // height: 40,
                                margin: EdgeInsets.only(top: 10).copyWith(left: 10,right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 1.0).copyWith(bottom: 0),
                                        // decoration: BoxDecoration(
                                        //     color: Color(int.parse("0xFFECF1F5")),
                                        //     border: Border.all(
                                        //       color: InsColor(appBloc)
                                        //           .appBGColor
                                        //           .withAlpha(0),
                                        //     ),
                                        //     borderRadius:
                                        //         BorderRadius.all(Radius.circular(20))),
                              child: Container(
                                // color: Colors.green,
                                decoration: BoxDecoration(
                                  color:   Color(int.parse("0xFFECF1F5")),
                                    border: Border.all(
                                      color: InsColor(appBloc)
                                          .appBGColor
                                          .withAlpha(0),),
                                    borderRadius:BorderRadius.all(Radius.circular(20))),
                                child: Html(data: people.interestAreas.replaceAll("Playground Expertise:", ""),shrinkWrap:true,style: {
                                  "body": Style(color: InsColor(appBloc).appTextColor,fontSize: FontSize.xSmall,maxLines: 1,alignment: Alignment.center,textOverflow: TextOverflow.ellipsis)
                                },),
                              ),
                            ) )
                        // Expanded(
                        //   //padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        //   child: Center(
                        //       child: Visibility(
                        //     visible: (people.interestAreas.length) > 0,
                        //     child: Container(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 8.0),
                        //         decoration: BoxDecoration(
                        //             color: Color(int.parse("0xFFECF1F5")),
                        //             border: Border.all(
                        //               color: InsColor(appBloc)
                        //                   .appBGColor
                        //                   .withAlpha(0),
                        //             ),
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(20))),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(2.0),
                        //           child: Text(
                        //             people.interestAreas,
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.w600,
                        //                 color: Color(int.parse("0xFF1D293F")),
                        //                 fontSize: 11),
                        //             softWrap: false,
                        //             overflow: TextOverflow.fade,
                        //           ),
                        //         )),
                        //   )),
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        //   child: Center(
                        //     child: Text(getConnectionStatus(),
                        //         style: TextStyle(
                        //             color: getStatusColor(
                        //                 people.connectionstate == ""
                        //                     ? people.connectionstateAccept
                        //                     : people.connectionstate),
                        //             fontSize: 13)),
                        //   ),
                        //   alignment: Alignment.center,
                        // ),
                      ],
                    ),
                    //color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              right: 5,
              top: 5,
              child: moreThreeDot())
        ],
      ),
    );
  }

  Widget moreThreeDot(){
    return  IconButton(
      icon: Icon(Icons.more_vert_rounded,
          color: InsColor(appBloc).appIconColor),
      onPressed: () {
        addConnectionTap(
            people.objectId, people.userDisplayname);
      },
    );
  }

  String getConnectionStatus() {
    var status = (people.connectionstate == "" ? people.connectionstateAccept : people.connectionstate);
    if (people.connectedDays != '') {
      status = status + '\n' + (people.connectedDays);
    }
    return status;
  }
}
