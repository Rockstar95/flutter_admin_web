import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/share_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/share_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/share_state.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/app_colors.dart';

class ShareWithConnections extends StatefulWidget {
  final bool isFromForum;
  final bool isFromQuesion;
  final String contentName;
  final String contententId;

  const ShareWithConnections(
    this.isFromForum,
    this.isFromQuesion,
    this.contentName,
    this.contententId,
  );

  @override
  State<ShareWithConnections> createState() => _ShareWithConnectionsState();
}

class _ShareWithConnectionsState extends State<ShareWithConnections> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  ShareBloc get shareBloc => BlocProvider.of<ShareBloc>(context);
  var _controller = TextEditingController();

  int selectCount = 0;
  late FToast flutterToast;

  @override
  void initState() {
    super.initState();
    shareBloc.add(GetConnectionListEvent(searchTxt: ""));
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            selectCount == 0 ? "Share With Connections" : "$selectCount Selected",
            style: TextStyle(
                fontSize: 18,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if (selectCount != 0) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShareMainScreen(
                          false,
                          widget.isFromForum,
                          widget.isFromQuesion,
                          widget.contententId,
                          widget.contentName)));
                } else {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: "Please Select Atleast One Connction"),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                }
              },
              child: Icon(
                Icons.check,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
              ),
            ),
            SizedBox(
              width: 10.h,
            ),
          ],
        ),
        body: mainBody(),
      ),
    );
  }

  Widget mainBody(){
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                TextField(
                  controller: _controller,
                  cursorColor:AppColors.getAppButtonBGColor(),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12.h),
                    color: AppColors.getAppTextColor(),
                  ),
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(
                      color:AppColors.getAppTextColor()
                          .withOpacity(0.7),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: AppColors.getBorderColor(),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                          color: AppColors.getBorderColor(),
                          width: 2),
                    ),
                    hintText: 'Search ...',
                  ),
                  onSubmitted: (val) {
                    shareBloc.add(GetConnectionListEvent(
                        searchTxt: val.toString()));
                  },
                  onChanged: (val) {
                    shareBloc.add(GetConnectionListEvent(
                        searchTxt: val.toString()));
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(
                //       'CONNECTIONS',
                //       style: TextStyle(
                //           color: Color(int.parse(
                //               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                //           fontWeight: FontWeight.bold,
                //           fontSize: 12.h,
                //           letterSpacing: 2),
                //     ),
                //   ],
                // ),
              ],
            ),
            Expanded(
              flex: 7,
              child: connectionListView(),
            )
          ],
        ),
      ),
    );
  }

  Widget connectionListView(){
    return BlocConsumer<ShareBloc, ShareState>(
      bloc: shareBloc,
      listener: (context, state) {
        if (state is SelectConnectiontState) {
          if (state.status == Status.COMPLETED) {
            setState(() {
              selectCount = state.list.length;
            });
          }
        }
      },
      builder: (context, state) {
        if (state.status == Status.LOADING) {
          return Container(
            child: Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.h,
                ),
              ),
            ),
          );
        } else if (state.status == Status.COMPLETED) {
          return shareBloc.connectionlist.length == 0
              ? Center(
                child: Text(
                    appBloc.localstr.commoncomponentLabelNodatalabel,
                    style: TextStyle(
                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 24),
                    ),
                  )
              : ListView.builder(
                shrinkWrap: true,
                //physics: ScrollPhysics(),
                itemCount: shareBloc.connectionlist.length,
                itemBuilder: (context, pos) {
                  bool isSelected = false;
                  for (int i = 0; i < shareBloc.selectedconnectionlist.length; i++) {
                    if (shareBloc.selectedconnectionlist[i] == shareBloc.connectionlist[pos].userId.toString()) {
                      isSelected = true;
                    }
                  }
                  return listViewDataTile(pos,isSelected);
                });
        } else {
          return noDataView();
        }
      },
    );
  }

  Widget listViewDataTile(int pos, bool isSelected){
    return Container(
      margin:
      EdgeInsets.symmetric(vertical: 4.h),
      // height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 14.h,horizontal: 5.h),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(5.h),
          border: Border.all(
              color: AppColors.getBorderColor())),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 10.h),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    shareBloc
                        .connectionlist[
                    pos]
                        .usersImage
                        .length ==
                        0
                        ? 'https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg'
                        : (shareBloc
                        .connectionlist[
                    pos]
                        .usersImage
                        .startsWith(
                        "http")
                        ? shareBloc
                        .connectionlist[
                    pos]
                        .usersImage
                        : "${ApiEndpoints.strSiteUrl}${shareBloc.connectionlist[pos].usersImage}"),
                    width: 50.h,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 15.h,
                ),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      shareBloc
                          .connectionlist[pos]
                          .userName,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15.h),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      shareBloc
                          .connectionlist[
                      pos]
                          .addressCountry ==
                          null
                          ? ""
                          : shareBloc
                          .connectionlist[pos]
                          .addressCountry,
                      style: TextStyle(
                          color: AppColors.getAppTextColor().withOpacity(0.54)),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black
                      : AppColors.getAppTextColor(),
                  borderRadius:
                  BorderRadius.circular(
                      20.h)),
              child: GestureDetector(
                onTap: () {
                  shareBloc.add(
                      SelectConnectionEvent(
                          seletedEmail: shareBloc
                              .connectionlist[pos]
                              .userId
                              .toString()));
                },
                child: isSelected
                    ? Icon(
                        Icons.remove,
                        color: Colors.white,size: 18,)
                    : Icon(
                      Icons.add,
                      color: Colors.white,size: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget noDataView(){
    return Container(
      child: Center(
        child: Text(
            appBloc
                .localstr.commoncomponentLabelNodatalabel,
            style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                fontSize: 24)),
      ),
    );
  }
}
