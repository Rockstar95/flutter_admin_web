import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/bloc/auth_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/auth_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/auth_state.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Setting/site_setting.dart';
import 'package:flutter_admin_web/ui/auth/dynamic_signup_page.dart';
import 'package:flutter_admin_web/ui/auth/login_page.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/home/ActBase.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/constants.dart';
import '../../framework/helpers/providermodel.dart';
import '../common/outline_button.dart';
import 'membership_signup.dart';

class LoginCommonPage extends StatefulWidget {
  @override
  _LoginCommonPageState createState() => _LoginCommonPageState();
}

class _LoginCommonPageState extends State<LoginCommonPage> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  late AuthBloc authBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  bool isSwitched = false;

  void refresh() {
    setState(() {});
  }

  Future<void> getThemetype() async {
    var switchStr = await sharePrefGetString(savedTheme);

    switchStr == "true" ? isSwitched = true : isSwitched = false;
    print("setDarkTheme $isSwitched");
  }

  Future<void> _showMembershipPlansDialog(BuildContext context, List<MemberShipPlanResponse> membershipList, String currency) async {
    for (var membershipRes in membershipList) {
      setState(() {
        var plans = membershipRes.memberShipPlans.map((e) {
          return RadioModel(
            false,
            (double.tryParse(e.amount) ?? 0) > 0 ? "$currency ${e.amount}/${e.durationValue} ${e.durationType}" : e.durationType,
            e.memberShipDurationId,
            Platform.isAndroid ? (e.googleSubscriptionID) : (Platform.isIOS ? e.appleSubscriptionID : ""),
          );
        }).toList();

        authBloc.memberShipPlansList.firstWhere((element) => element.memberShipId == membershipRes.memberShipId).radioData = plans;
      });
    }
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Size size = MediaQuery.of(context).size;
            var memItems = planItems(membershipList, currency);
            return AlertDialog(
              scrollable: true,
              backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              //contentPadding: const EdgeInsets.all(16.0),
              content: Container(
                child: Column(
                  children: List.generate(memItems.length, (i) {
                    return memItems[i];
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void setlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', 'true');
    print('isloggedin ${prefs.getString('login')}');
  }

  bool getSocialLoginEnabled() {
    List<bool> socialLogins = [
      appBloc.uiSettingModel.isLinkedIn,
      appBloc.uiSettingModel.isFaceBook,
      appBloc.uiSettingModel.isGoogle,
      appBloc.uiSettingModel.isTwitter,
    ];

    return socialLogins.contains(true);
  }

  void onSignUpTap() {
    if (appBloc.uiSettingModel.enableMembership == 'True') {
      appBloc.uiSettingModel.enableInAppPurchase == 'True'
          ? _showMembershipPlansDialog(context, authBloc.memberShipPlansList, '\$')
          : Navigator.of(context).push(MaterialPageRoute(builder: (context) => MembershipSignUpWebView()));
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (context) => ProviderModel(), child: DynamicSignUp(),)));
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepositoryBuilder.repository());
    authBloc.add(GetMembershipDetailsEvent());

    getThemetype();
  }

  @override
  Widget build(BuildContext context) {
    print("Login Common Page");

    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (_, stateval) {
        if (stateval is AuthInitializedState) {
          print('statedata $stateval');
        }
        else {
          if (stateval.status == Status.COMPLETED && !(stateval is GetMembershipDetailsState)) {
            setlogin();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => ActBase()),
                (Route<dynamic> route) => false);
          }
          else if (stateval.status == Status.ERROR) {
            // Fluttertoast flutterToast = Fluttertoast(context);
            // flutterToast.showToast(
            //   child: CommonToast(
            //       displaymsg: appBloc.localstr.loginAlerttitleSigninfailed),
            //   gravity: ToastGravity.BOTTOM,
            //   toastDuration: Duration(seconds: 2),
            // );
          }
        }
      },
      builder: (_, stateval) => BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        builder: (_, state) => Scaffold(
          body: Stack(
            children: <Widget>[
              getMainBody(context, state),
              getLoadingWidget(stateval),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLoadingWidget(AuthState stateval) {
    return Center(
      child: stateval.status == Status.LOADING
          ? AbsorbPointer(
              child: AppConstants().getLoaderWidget(iconSize: 70))
          : Container(),
    );
  }

  Widget getMainBody(BuildContext context, ChangeThemeState state) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    final width = MediaQuery.of(context).size.width;

    print("appBloc.uiSettingModel.appDarkLogoURl:${appBloc.uiSettingModel.appDarkLogoURl}");
    print("appBloc.uiSettingModel.appLogoURl:${appBloc.uiSettingModel.appLogoURl}");
    print("IsSwitched:$isSwitched");

    /*appBloc.uiSettingModel.setIsLinkedIn(true);
    appBloc.uiSettingModel.setIsFaceBook(true);
    appBloc.uiSettingModel.setIsGoogle(true);
    appBloc.uiSettingModel.setIsTwitter(true);*/

    print("isLinkedIn:${appBloc.uiSettingModel.isLinkedIn}");
    print("isFaceBook:${appBloc.uiSettingModel.isFaceBook}");
    print("isGoogle:${appBloc.uiSettingModel.isGoogle}");
    print("isTwitter:${appBloc.uiSettingModel.isTwitter}");

    bool isSocialLoginEnabled = getSocialLoginEnabled();

    return Container(
      color: AppColors.getAppBGColor(),
      padding: EdgeInsets.symmetric(horizontal: useMobileLayout ? (20) : (width * 0.2)),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.h,),
                getSplashLogo(),
                SizedBox(height: 30.h,),
                getSignInButton(),
                SizedBox(height: 10.h,),
                getSignUpButton(),
                SizedBox(height: 25.h,),
                if(isSocialLoginEnabled) ...getSocialSignUpSection(state: state),
                SizedBox(),
              ],
            ),
          ),
          getSignUpLink(isSocialLoginEnabled),
        ],
      ),
    );
  }

  Widget getSplashLogo() {
    return SizedBox(
      height: 86.h,
      width: 276.h,
      child: CachedNetworkImage(
          placeholder: (context, url) => Image.asset(
                kSplashLogo,
              ),
          errorWidget: (context, url, _) => Image.asset(
            kSplashLogo,
          ),
          imageUrl: MyUtils.getSecureUrl(isSwitched
              ? appBloc.uiSettingModel.appDarkLogoURl
              : appBloc.uiSettingModel.appLogoURl),
      ),
    );
  }

  Widget getSignInButton() {
    return Container(
              width: MediaQuery.of(context).size.width,
              height: 55.h,
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage(
                              refresh: refresh,
                              isAutologin: false,
                            )));
                  },
                  child: Text(
                    appBloc.localstr.loginButtonSigninbutton != null
                        ? appBloc.localstr.loginButtonSigninbutton
                        : "",
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.isNotEmpty ? appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase() : "FFFFFF"}"))),
                  ),
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.isNotEmpty ? appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase() : "FFFFFF"}"))));
  }

  Widget getSignUpButton() {
    if(appBloc.uiSettingModel.selfRegistrationAllowed.toLowerCase() == 'true') {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 55.h,
        child: OutlineButton(
          onPressed: () async {
            onSignUpTap();
          },
          child: Text(
            appBloc.localstr.signupButtonSignup != null
                ? appBloc.localstr.signupButtonSignup
                : "",
            style: TextStyle(
              color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ),
            ),
          ),
          border: Border.all(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
        ),
      );
    }
    else {
      return SizedBox();
    }
  }

  Iterable<Widget> getSocialSignUpSection({required ChangeThemeState state}) sync* {
    List<bool> socialLogins = [
      appBloc.uiSettingModel.isLinkedIn,
      appBloc.uiSettingModel.isFaceBook,
      appBloc.uiSettingModel.isGoogle,
      appBloc.uiSettingModel.isTwitter,
    ];
    if(socialLogins.contains(true)) {
      yield Text(
        'or',
        style: TextStyle(color: AppColors.getAppButtonBGColor()),
      );

      yield SizedBox(height: 25.h,);

      if(appBloc.uiSettingModel.isFaceBook) {
        yield getSocialLoginButton(
          state: state,
          title: "Continue with Facebook",
          image: "assets/images/fb_icon.png",
          onTap: () {
            authBloc.add(FBSignin(localStr: appBloc.localstr));
          }
        );
      }
      if(appBloc.uiSettingModel.isGoogle) {
        yield getSocialLoginButton(
          state: state,
          title: "Continue with Google",
          image: "assets/images/google_icon.png",
          onTap: () {
            authBloc.add(GSignIn(localStr: appBloc.localstr));
          }
        );
      }
      if(appBloc.uiSettingModel.isTwitter) {
        yield getSocialLoginButton(
          state: state,
          title: "Continue with Twitter",
          image: "assets/images/twitter_icon.png",
          onTap: () {

          }
        );
      }
      if(appBloc.uiSettingModel.isLinkedIn) {
        yield getSocialLoginButton(
          state: state,
          title: "Continue with LinkedIn",
          image: "assets/images/linked_in.png",
          onTap: () {
            authBloc.add(FBSignin(localStr: appBloc.localstr));
          }
        );
      }
    }
  }

  Widget getSocialLoginButton({required ChangeThemeState state, required String title, required String image, required void Function() onTap}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 55.h,
        child: OutlineButton(
          onPressed: () {
            onTap();
          },
          child: Stack(
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(image),
                  ],
                ),
              ),
              Center(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
              ),
            ],
          ),
          border: Border.all(color: state.themeData.primaryColorLight),
        ),
    );
  }

  Widget getSignUpLink(bool isSocialLoginEnabled) {
    if(isSocialLoginEnabled && appBloc.uiSettingModel.selfRegistrationAllowed.toLowerCase() == 'true') {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                color: AppColors.getAppTextColor(),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                onSignUpTap();
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: AppColors.getAppButtonBGColor(),
                ),
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

  List<Widget> planItems(List<MemberShipPlanResponse> membershipList, String currency) {
    List<Widget> newItems = [];

    for (var membershipRes in membershipList) {
      newItems.add(Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: InsColor(appBloc).appBtnBgColor),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
        //height: 300,
        //width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Container(
                alignment: Alignment.center,
                height: 30,
                color: InsColor(appBloc).appBtnBgColor,
                child: Text(membershipRes.displayText,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"),
                        ))),
              ),
              Container(
                child: Html(
                    shrinkWrap: true,
                    data: "" + membershipRes.memberShipShortDesc + "",
                    style: {
                      "body": Style(
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5),
                          fontSize: FontSize(ScreenUtil().setSp(14))),
                    }),
              )
            ]),
            Column(
              children: List.generate(membershipRes.radioData.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      authBloc.memberShipPlansList
                          .firstWhere((element) =>
                      element.memberShipId ==
                          membershipRes.memberShipId)
                          .radioData
                          .forEach((element) => element.isSelected = false);
                      authBloc.memberShipPlansList
                          .firstWhere((element) =>
                      element.memberShipId ==
                          membershipRes.memberShipId)
                          .radioData[index]
                          .isSelected = true;
                      var data = authBloc.memberShipPlansList
                          .firstWhere((element) =>
                      element.memberShipId ==
                          membershipRes.memberShipId)
                          .radioData[index];
                      print(data.memberShipDurationID);
                      var productId = '';
                      if (data.productId == 'Gold 1') {
                        //Temporary until productId from server response
                        productId = 'com.instancy.goldyearplan';
                      } else if (data.productId.toLowerCase() == 'silver') {
                        productId = 'com.instancy.silveronemonth';
                      }
                      Navigator.pop(context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ChangeNotifierProvider(
                      //           create: (context) => ProviderModel(),
                      //           child: Paymentinfo(),
                      //         )));

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ProviderModel(),
                            child: DynamicSignUp(
                              membershipId: data.memberShipDurationID,
                              productId: data.productId,
                            ),
                          )));
                    });
                  },
                  child: RadioItem(membershipRes.radioData[index], appBloc),
                );
              }),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: <Widget>[
            //       Expanded(
            //         child: OutlineButton(
            //           borderSide: BorderSide(
            //               color: Color(int.parse(
            //                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
            //           child: Text(
            //               appBloc.localstr.achievementsAlertbuttonCancelbutton,
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   color: Color(int.parse(
            //                       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
            //           onPressed: () {
            //             Navigator.pop(context);
            //           },
            //         ),
            //       ),
            //       SizedBox(
            //         width: 5,
            //       ),
            //       Expanded(
            //         child: MaterialButton(
            //           disabledColor: Color(int.parse(
            //                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            //               .withOpacity(0.5),
            //           color: Color(int.parse(
            //               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            //           child: Text(appBloc.localstr.detailsButtonUpdatebutton,
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   color: Color(int.parse(
            //                       "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
            //           onPressed: () async {
            //             var selectedPlan = planData
            //                 .firstWhere((element) => element.isSelected);
            //             if (selectedPlan.memberShipDurationID != null) {
            //               var url = ApiEndpoints.membershipRenewRedirectUrl(
            //                   selectedPlan.memberShipDurationID.toString());
            //               print(url);
            //               await launch(url);
            //             }
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ));
    }
    //newItems.removeAt(0);
    return newItems;
  }

// List<Widget> planItemsWidget(
//     List<MemberShipPlanResponse> membershipList, String currency) {
//   List<Widget> newItems = [];
//
//   for (var membershipRes in membershipList) {
//     newItems.add(Container(
//       height: 300,
//       width: 300,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           SizedBox(height: 16),
//           Expanded(
//               flex: 1,
//               child:
//                   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Text(membershipRes.displayText,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(
//                           int.parse(
//                               "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//                         )))
//               ])),
//           SizedBox(height: 8),
//           Divider(thickness: 1, indent: 0),
//           SizedBox(height: 8),
//           Expanded(
//             flex: 9,
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: membershipRes.radioData.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return new InkWell(
//                     onTap: () {
//                       setState(() {
//                         authBloc.memberShipPlansList
//                             .firstWhere((element) =>
//                                 element.memberShipId ==
//                                 membershipRes.memberShipId)
//                             .radioData
//                             .forEach((element) => element.isSelected = false);
//                         authBloc.memberShipPlansList
//                             .firstWhere((element) =>
//                                 element.memberShipId ==
//                                 membershipRes.memberShipId)
//                             .radioData[index]
//                             .isSelected = true;
//                         var data = authBloc.memberShipPlansList
//                             .firstWhere((element) =>
//                                 element.memberShipId ==
//                                 membershipRes.memberShipId)
//                             .radioData[index];
//                         print(data.memberShipDurationID);
//                         var productId = '';
//                         if (data.productId == 'Gold') {
//                           //Temporary until productId from server response
//                           productId = 'com.instancy.goldyearplan';
//                         } else if (data.productId.toLowerCase() == 'silver') {
//                           productId = 'com.instancy.silveronemonth';
//                         }
//                         Navigator.pop(context);
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => ChangeNotifierProvider(
//                                   create: (context) => ProviderModel(),
//                                   child: DynamicSignUp(
//                                     membershipId: data.memberShipDurationID,
//                                     productId: productId,
//                                   ),
//                                 )));
//                       });
//                     },
//                     child: new RadioItem(
//                         membershipRes.radioData[index], appBloc),
//                   );
//                 }),
//           ),
//           Divider(
//               color: Color(
//             int.parse(
//                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
//           ))
//           // Expanded(
//           //   flex: 2,
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //     children: <Widget>[
//           //       Expanded(
//           //         child: OutlineButton(
//           //           borderSide: BorderSide(
//           //               color: Color(int.parse(
//           //                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
//           //           child: Text(
//           //               appBloc.localstr.achievementsAlertbuttonCancelbutton,
//           //               style: TextStyle(
//           //                   fontSize: 14,
//           //                   color: Color(int.parse(
//           //                       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
//           //           onPressed: () {
//           //             Navigator.pop(context);
//           //           },
//           //         ),
//           //       ),
//           //       SizedBox(
//           //         width: 5,
//           //       ),
//           //       Expanded(
//           //         child: MaterialButton(
//           //           disabledColor: Color(int.parse(
//           //                   "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
//           //               .withOpacity(0.5),
//           //           color: Color(int.parse(
//           //               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
//           //           child: Text(appBloc.localstr.detailsButtonUpdatebutton,
//           //               style: TextStyle(
//           //                   fontSize: 14,
//           //                   color: Color(int.parse(
//           //                       "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
//           //           onPressed: () async {
//           //             var selectedPlan = planData
//           //                 .firstWhere((element) => element.isSelected);
//           //             if (selectedPlan.memberShipDurationID != null) {
//           //               var url = ApiEndpoints.membershipRenewRedirectUrl(
//           //                   selectedPlan.memberShipDurationID.toString());
//           //               print(url);
//           //               await launch(url);
//           //             }
//           //           },
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // )
//         ],
//       ),
//     ));
//   }
//   //newItems.removeAt(0);
//   return newItems;
// }
}
