import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/bloc/discussion_main_home_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/event/discussion_main_home_event.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/state/discussion_main_home_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Discussion/discussion_main_home_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

class DiscussionForumLikes extends StatefulWidget {
  final ForumList forumList;

  DiscussionForumLikes({Key? key, required this.forumList}) : super(key: key);

  @override
  _DiscussionForumLikesState createState() => _DiscussionForumLikesState();
}

class _DiscussionForumLikesState extends State<DiscussionForumLikes>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Color _iconColor = Colors.black;
  TabController? _tabController;
  List<Tab> tabList = [];

  late DiscussionMainHomeBloc discussionMainHomeBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  FToast? flutterToast;

  @override
  void initState() {
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabAllDiscussion,
    // ));
    // tabList.add(new Tab(
    //   text: appBloc.localstr.discussionTabMyDiscussion,
    // ));
    discussionMainHomeBloc = DiscussionMainHomeBloc(
        discussionMainHomeRepositry:
            DiscussionMainHomeRepositoryBuilder.repository());

    discussionMainHomeBloc.add(
        GetDiscussionForumLikeListEvent(forumId: widget.forumList.forumID));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Likes',
          style: TextStyle(
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
            Divider(
              height: 2,
              color: Colors.black87,
            ),
            new Column(
              children: [
                new Expanded(
                  child: mainWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainWidget() {
    return BlocConsumer<DiscussionMainHomeBloc, DiscussionMainHomeState>(
        bloc: discussionMainHomeBloc,
        listener: (context, state) {
          if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.LOADING &&
              discussionMainHomeBloc.isFirstLoading == true) {
            return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.0,
                ),
              ),
            );
          } else if (discussionMainHomeBloc.discussionForumLikeList.length ==
              0) {
            return noDataFound(true);
          } else {
            return new Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              padding: EdgeInsets.all(10.0),
              child: new ListView.separated(
                  itemCount:
                      discussionMainHomeBloc.discussionForumLikeList.length,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                  itemBuilder: (context, index) {
                    return new Container(
                      child: new Column(
                        children: [
                          new Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: discussionMainHomeBloc
                                          .discussionForumLikeList[index]
                                          .userThumb
                                          .contains('http')
                                      ? '${discussionMainHomeBloc.discussionForumLikeList[index].userThumb}'
                                      : '${ApiEndpoints.strSiteUrl}${discussionMainHomeBloc.discussionForumLikeList[index].userThumb}',
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
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/user.gif',
                                    width: 60,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: new Text(
                                        discussionMainHomeBloc
                                            .discussionForumLikeList[index]
                                            .userName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.apply(
                                                color: InsColor(appBloc)
                                                    .appTextColor),
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 5.0),
                                      child: new Text(
                                        discussionMainHomeBloc
                                            .discussionForumLikeList[index]
                                            .userDesg,
                                        style: new TextStyle(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                            fontSize: 10.0),
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 5.0),
                                      child: new Text(
                                        discussionMainHomeBloc
                                            .discussionForumLikeList[index]
                                            .userAddress,
                                        style: new TextStyle(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                            fontSize: 10.0),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        });
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
