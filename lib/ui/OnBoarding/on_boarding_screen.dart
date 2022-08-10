import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/ui/OnBoarding/helper/dots_indicator.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';

class OnBoardingScreen extends StatefulWidget {
  final List<String> imageList;

  OnBoardingScreen({required this.imageList});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _controller;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    _controller = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //basicDeviceHeightWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState themeState) {
          return Container(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: SafeArea(
              child: Scaffold(
                //backgroundColor: Colors.white,
                backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.h,
                      child: MaterialButton(
                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        child: Text(
                            appBloc.localstr.loginButtonSigninbutton != null
                                ? appBloc.localstr.loginButtonSigninbutton
                                : "SignIn",
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                            )),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginCommonPage()), (_) => false);
                        },
                      )),
                ),
                body: widget.imageList.length > 0
                    ? Column(
                        children: <Widget>[
                          Expanded(
                              child: Stack(
                            children: <Widget>[
                              PageView.builder(
                                physics: new AlwaysScrollableScrollPhysics(),
                                controller: _controller,
                                itemBuilder: (context, position) {
                                  return Center(
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageList[position],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                itemCount: widget.imageList.length, // Can be null
                              ),
                              new Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: widget.imageList.length > 1
                                          ? DotsIndicator(
                                              color: Colors.black,
                                              controller: _controller,
                                              itemCount: widget.imageList.length,
                                              onPageSelected: (int page) {
                                                _controller.animateToPage(
                                                  page,
                                                  duration: _kDuration,
                                                  curve: _kCurve,
                                                );
                                              },
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      )
                    : Center(
                        child: Text("No image Available "),
                      ),
              ),
            ),
          );
        });
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h));
  }
}
