import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/bloc/communities_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/event/communities_event.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/model/learningcommunitiesresponse.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/state/communities_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/repository/learningcommunities/communities_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/splash/splash_screen.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

import '../common/app_colors.dart';
import '../common/bottomsheet_drager.dart';

class LearningCommunitiesScreen extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;

  LearningCommunitiesScreen({required this.nativeMenuModel});

  @override
  _LearningCommunitiesScreenState createState() =>
      _LearningCommunitiesScreenState();
}

class _LearningCommunitiesScreenState extends State<LearningCommunitiesScreen> with SingleTickerProviderStateMixin {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late CommunitiesBloc communitiesBloc;

  TextEditingController allCommunitySearchController = TextEditingController();
  TextEditingController myCommunitySearchController = TextEditingController();

  List<PortalListing> myPortallisting = [];

  List<Tab> tabList = [];

  late TabController _tabController;

  void _showBottomSheet(context, PortalListing portallisting) async {
    String userId = await sharePrefGetString(sharedPref_LoginUserID);
    String password = await sharePrefGetString(sharedPref_LoginPassword);

    Widget? joinCommunityButton, gotoCommunityButton;

    if(portallisting.actionGOTO.isEmpty) {
      joinCommunityButton = ListTile(
        leading: Icon(
          Icons.group_add,
          color: AppColors.getAppTextColor(),
        ),
        title: Text(
          'Join Community',
          style: TextStyle(color: AppColors.getAppTextColor()),
        ),
        onTap: () async => {
          communitiesBloc.add(LoginorGotoSubsiteEvent(
            portallisting: portallisting,
            localStr: appBloc.localstr,
            password: password,
            email: userId,
          )),
          Navigator.pop(context),
        },
      );
    }

    if(portallisting.labelAlreadyaMember == 'true') {
      gotoCommunityButton = ListTile(
        leading: Icon(
          FontAwesomeIcons.share,
          color: AppColors.getAppTextColor(),
        ),
        title: Text(
          'Go to Community',
          style: TextStyle(color: AppColors.getAppTextColor()),
        ),
        onTap: () => {
          communitiesBloc.add(LoginorGotoSubsiteEvent(
            portallisting: portallisting,
            localStr: appBloc.localstr,
            password: password,
            email: userId,
          )),
          Navigator.pop(context),
          print('subSiteUrl' + portallisting.learnerSiteURL),
        },
      );
    }

    MyPrint.printOnConsole("joinCommunityButton:$joinCommunityButton");
    MyPrint.printOnConsole("gotoCommunityButton:$gotoCommunityButton");
    if(joinCommunityButton == null && gotoCommunityButton == null) {
      MyPrint.printOnConsole("Both Options Are not Available");
      return;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: AppColors.getAppBGColor(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BottomSheetDragger(),
                joinCommunityButton ?? SizedBox(),
                gotoCommunityButton ?? SizedBox(),
              ],
            ),
          );
        },
    );
  }

  void prepareMycommunitiesData() {
    myPortallisting.clear();
    /*communitiesBloc.learningCommunitiesresponse.portalListing != null
      ? communitiesBloc.learningCommunitiesresponse.portalListing
          .forEach((element) {
          if (element.labelAlreadyaMember == 'true') {
            myPortallisting.add(element);
          }
        })
      : noDataFound(true);*/
    communitiesBloc.learningCommunitiesresponse.portalListing.forEach((element) {
      if (element.labelAlreadyaMember == 'true') {
        myPortallisting.add(element);
      }
    });
  }

  void getCommunitiesdata() {
    communitiesBloc.add(GetLearningCommunitiesEvent(nativeMenuModel: widget.nativeMenuModel));
  }

  Future<bool> showCommunityJoinedDialog(PortalListing portallisting) async {
    bool? isNavigate = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20).copyWith(top: 40),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You have successfully joined",
              style: TextStyle(
                color: AppColors.getAppTextColor(),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20,),
            Divider(height: 1, color: AppColors.getAppTextColor().withOpacity(0.5),),
            SizedBox(height: 20,),
            Text(
              portallisting.name,
              style: TextStyle(
                color: AppColors.getAppTextColor().withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20,),
            Divider(height: 1, color: AppColors.getAppTextColor().withOpacity(0.5),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonPrimarySecondaryButton(
                  text: "Cancel",
                  isPrimary: false,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                SizedBox(width: 10,),
                CommonPrimarySecondaryButton(
                  text: "Continue",
                  isPrimary: true,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.getAppBGColor(),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );

    MyPrint.printOnConsole("isNavigate From Dialog:$isNavigate");

    return isNavigate ?? false;
  }

  @override
  void initState() {
    communitiesBloc = CommunitiesBloc(
        communitiesRepository: CommunitiesRepositoryBuilder.repository());

    communitiesBloc.isFirstLoading = true;

    tabList.add(new Tab(
      text: 'All Communities',
    ));

    tabList.add(new Tab(
      text: 'My Communities',
    ));

    _tabController = new TabController(length: tabList.length, vsync: this);

    getCommunitiesdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: Container(
        color: AppColors.getAppBGColor(),
        child: _homeBody(context, itemWidth, itemHeight),
      ),
    );
  }

  Widget _homeBody(BuildContext context, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColors.getAppHeaderColor(),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(int.parse("0xFF1D293F")),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.getAppHeaderTextColor(),
              tabs: tabList,
            ),
          ),
          Expanded(
            child: BlocConsumer<CommunitiesBloc, CommunitiesState>(
                bloc: communitiesBloc,
                builder: (context, state) {
                  if (state.status == Status.LOADING) {
                    return Center(
                      child: AbsorbPointer(
                        child: SpinKitCircle(
                          color: Colors.grey,
                          size: 70,
                        ),
                      ),
                    );
                  }
                  if (state.status == Status.COMPLETED) {
                    // if (state is GetCommunitiesResponseState) {
                    prepareMycommunitiesData();
                    return Container(
                      color: AppColors.getAppBGColor(),
                      height: double.maxFinite,
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          allCommunities(),
                          myCommunities(),
                        ],
                      ),
                    );
                    // }
                  }
                  else if (state.status == Status.ERROR) {
                    return noDataFound();
                  }
                  // if (state is LoginorGotoSubsiteState) {
                  //   if (state.status == Status.COMPLETED) {
                  //     Future.delayed(Duration(seconds: 1)).then((value) async {
                  //       var subSiteUrl =
                  //           await sharePref_getString(sharedPrefSubSiteSiteUrl);
                  //       sharePref_saveString(sharedPref_siteURL, subSiteUrl);
                  //
                  //       print('subSiteUrl' + subSiteUrl);
                  //       Navigator.of(context).pushAndRemoveUntil(
                  //           MaterialPageRoute(
                  //               builder: (context) => SplashScreen(true)),
                  //           (Route<dynamic> route) => false);
                  //     });
                  //   }
                  // }
                  return Container();
                },
                listener: (context, state) {
                  if (state is GetCommunitiesResponseState) {
                    if (state.status == Status.LOADING) {

                    }
                    else if (state.status == Status.ERROR) {

                    }
                    else if (state.status == Status.COMPLETED) {}
                  }
                  if (state is LoginorGotoSubsiteState) {
                    if (state.status == Status.COMPLETED) {
                      Future.delayed(Duration(seconds: 1)).then((value) async {
                        bool isNavigate = true;
                        if(state.portalListing != null) {
                          isNavigate = await showCommunityJoinedDialog(state.portalListing!);
                          MyPrint.printOnConsole("isNavigate To Community:$isNavigate");
                        }

                        if(isNavigate) {
                          var subSiteUrl = await sharePrefGetString(sharedPrefSubSiteSiteUrl);
                          sharePrefSaveString(sharedPref_siteURL, subSiteUrl);

                          print('subSiteUrl' + subSiteUrl);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen(true)),
                            (Route<dynamic> route) => false,
                          );
                        }
                      });
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget allCommunities() {
    return getCommunitiesListView(
      list: communitiesBloc.learningCommunitiesresponse.portalListing,
      showTextField: true,
      textEditingController: allCommunitySearchController,
    );
  }

  Widget myCommunities() {
    return getCommunitiesListView(
      list: myPortallisting,
      showTextField: true,
      textEditingController: myCommunitySearchController,
    );
  }

  Widget getCommunitiesListView({List<PortalListing> list = const <PortalListing>[], TextEditingController? textEditingController, bool showTextField = true}) {
    List<PortalListing> communitiesList = [];
    if(showTextField && (textEditingController?.text.isNotEmpty ?? false)) {
      String keyword = textEditingController!.text.toLowerCase();

      communitiesList.addAll(list.where((element) {
        return element.name.toLowerCase().contains(keyword) || element.description.toLowerCase().contains(keyword);
      }).toList());
    }
    else {
      communitiesList.addAll(list);
    }

    Widget? textFieldWidget;
    if(showTextField) {
      textFieldWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: InsSearchTextField(
          onTapAction: () {},
          controller: textEditingController,
          appBloc: appBloc,
          onSubmitAction: (value) {},
          onChanged: (String value) {
            setState(() {});
          },
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          textFieldWidget ?? SizedBox(),
          Expanded(
            child: communitiesList.isNotEmpty ? RefreshIndicator(
              onRefresh: () async {
                getCommunitiesdata();
              },
              color: AppColors.getAppHeaderTextColor(),
              child: ResponsiveWidget(
                mobile: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: communitiesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return communityCard(communitiesList[index]);
                  },
                ),
                tab: GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width / 600,
                  ),
                  itemCount: communitiesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return communityCard(communitiesList[index]);
                  },
                ),
                web: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: myPortallisting.length,
                  itemBuilder: (BuildContext context, int index) {
                    return communityCard(myPortallisting[index]);
                  },
                ),
              ),
            ) : noDataFound(),
          ),
        ],
      ),
    );
  }

  //region Community Card
  Widget communityCard(PortalListing portallisting) {
    String labelAlreadyaMember = portallisting.labelAlreadyaMember;
    return Card(
      color: AppColors.getAppBGColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(150),
                    child: CachedNetworkImage(
                      imageUrl: portallisting.picture.startsWith('http')
                          ? portallisting.picture
                          : portallisting.learnerSiteURL + portallisting.picture,
                      width: MediaQuery.of(context).size.width,
                      //placeholder: (context, url) => CircularProgressIndicator(),
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
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.getColorFromString("#4373E9"),
                          //color: AppColors.getMenuTextColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(5),
                            bottom: ScreenUtil().setWidth(5),
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(10)),
                        child: Text(
                          labelAlreadyaMember == 'true' ? 'Member' : 'Not a Member',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(10),
                            color: Colors.white,
                            //color: AppColors.getMenuHeaderBGColor(),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  portallisting.learningProviderName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: InsColor(appBloc).appTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, portallisting);
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: InsColor(appBloc).appIconColor,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              portallisting.description,
              textAlign: TextAlign.left,
              maxLines: 3,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: InsColor(appBloc).appTextColor),
            ),
          ),
          getCommunityCardPrimaryActionButton(portallisting)
        ],
      ),
    );
  }

  Widget getCommunityCardPrimaryActionButton(PortalListing portallisting) {
    bool isCommunityJoined = portallisting.actionGOTO.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () async {
          String userId = await sharePrefGetString(sharedPref_LoginUserID);
          String password = await sharePrefGetString(sharedPref_LoginPassword);

          communitiesBloc.add(LoginorGotoSubsiteEvent(
            portallisting: portallisting,
            localStr: appBloc.localstr,
            password: password,
            email: userId,
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.getAppButtonBGColor(),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCommunityJoined ? Icons.video_library : Icons.group_add, color: AppColors.getAppButtonTextColor(), size: 20,),
              SizedBox(width: 10,),
              Text(
                isCommunityJoined ? "Go to Community" : "Join Community",
                style: TextStyle(color: AppColors.getAppButtonTextColor(), fontSize: 14,),
              )
            ],
          ),
        ),
      ),
    );
  }
  //endregion

  Widget noDataFound() {
    return Center(
      child: Text(
        appBloc.localstr.commoncomponentLabelNodatalabel,
        style: TextStyle(color: AppColors.getAppTextColor(), fontSize: 24),
      ),
    );
  }
}
