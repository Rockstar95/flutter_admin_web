import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/states/app_state.dart';
import 'package:flutter_admin_web/framework/bloc/auth/bloc/auth_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/auth_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/auth_state.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/membership_plan_response.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Setting/site_setting.dart';
import 'package:flutter_admin_web/ui/auth/dynamic_signup_page.dart';
import 'package:flutter_admin_web/ui/auth/forgot_password.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/home/ActBase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/constants.dart';
import '../../framework/helpers/providermodel.dart';
import 'membership_signup.dart';

class LoginPage extends StatefulWidget {
  final Function? refresh;
  final dynamic userID;
  final dynamic userPwd;
  final bool isAutologin;

  LoginPage({
    this.refresh,
    this.userID,
    this.userPwd,
    this.isAutologin = false,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String strTAG = "ActLogin";

  bool _passwordVisible = true;
  bool isloading = false;
  bool isError = false;

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _homeScreenText = "Waiting for token...";
  TextEditingController ctrPassword = TextEditingController();
  TextEditingController ctrEamil = TextEditingController();

  FocusNode reqFocusEmail = FocusNode();
  FocusNode reqFocusPwd = FocusNode();

  late RegExp regExp;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  late AuthBloc authBloc;

  bool isSwitched = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  // _requestNotificationPermission() async {
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   print('User granted permission: ${settings.authorizationStatus}');
  // }

  refresh() {
    if (widget.refresh != null) widget.refresh!();
    setState(() {
//all the reload processes
    });
  }

  getThemetype() async {
    var switchStr = await sharePrefGetString(savedTheme);

    switchStr == "true" ? isSwitched = true : isSwitched = false;
    print("setDarkTheme $isSwitched");
  }

  _showMembershipPlansDialog(BuildContext context, List<MemberShipPlanResponse> membershipList, String currency) async {
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

        authBloc.memberShipPlansList
            .firstWhere(
                (element) => element.memberShipId == membershipRes.memberShipId)
            .radioData = plans;
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

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, minHeight: h, maxWidth: w, maxHeight: h), designSize: Size(w, h),);
  }

  showLoading() {
    setState(() {
      isloading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      hideLoading();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ActBase()));
    });
  }

  hideLoading() {
    setState(() {
      isloading = false;
    });
  }

  void validate() {
    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
//      showLoading();

      FocusScope.of(context).unfocus();

      authBloc.add(CustomSignIn(
          email: ctrEamil.text,
          password: ctrPassword.text,
          localStr: appBloc.localstr));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void autoLogin(String userEmail, String userPassword) {
    authBloc.add(CustomSignIn(email: userEmail, password: userPassword, localStr: appBloc.localstr));
    // Future.delayed(Duration(seconds: 0)).then((value) {
    //   isFeedbackform
    //       ? appBloc.feedbackTitle = 'Enter New Feedback'
    //       : appBloc.feedbackTitle = 'Previous Feedback List';
    //   widget.updateTitle();
    // });
  }

  String? validateEmail(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc.localstr.loginAlertsubtitleUsernameorpasswordcannotbeempty;
    } else if (!regExp.hasMatch(value ?? "")) {
      return appBloc.localstr.loginAlertsubtitleInvalidusernameorpassword;
    } else {
      return null;
    }
  }

  String? validatePwd(String? value) {
    print(value);

    if (value?.length == 0) {
      return appBloc.localstr.loginAlertsubtitleUsernameorpasswordcannotbeempty;
    } else {
      return null;
    }
  }

  void setlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', 'true');
    print('isloggedin ${prefs.getString('login')}');
  }

  @override
  void initState() {
    regExp = RegExp(pattern);
    authBloc = AuthBloc(authRepository: AuthRepositoryBuilder.repository());
    authBloc.add(GetMembershipDetailsEvent());
    //_requestNotificationPermission();
    // _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
    //   if (message != null) {
    //     // Navigator.pushNamed(context, '/message',
    //     //      MessageArguments(message, true));
    //   }
    // });

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      setState(() {
        _homeScreenText = token ?? "";
      });
      print("fcm token $_homeScreenText");
    });

    if (widget.isAutologin) {
      autoLogin(widget.userID, widget.userPwd);
    }
    getThemetype();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //basicDeviceHeightWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    print(
        "App bloc loginButtonSignupbutton ${appBloc.localstr.loginButtonSignupbutton}");
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<AppBloc, AppState>(
      bloc: appBloc,
      builder: (context, state) => BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        // ignore: missing_return
        listener: (context, authstate) async {
          print("AuthBloc Listener Called for state:${authstate.runtimeType}, with status:${authstate.status} in Login Page");

          if (authstate is CustomSignInState) {
            if (authstate.status == Status.LOADING) {
              /*return Center(
                child: AbsorbPointer(
                  child: SpinKitCircle(
                    color: Colors.grey,
                    size: 70.h,
                  ),
                ),
              );*/
            }
            else if (authstate.status == Status.COMPLETED) {
              setlogin();
              if(!kIsWeb) {
                if (Platform.isAndroid) {
                  authBloc.add(FcmRegisterEvent(
                      deviceType: 'Android',
                      deviceToken: _homeScreenText,
                      siteURL: ApiEndpoints.strSiteUrl));
                }
                else if (Platform.isIOS) {
                  authBloc.add(FcmRegisterEvent(
                      deviceType: 'iOS',
                      deviceToken: _homeScreenText,
                      siteURL: ApiEndpoints.strSiteUrl));
                }
              }

              appBloc.userid = await sharePrefGetString(sharedPref_userid);
              appBloc.imageUrl = await sharePrefGetString(sharedPref_image);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ActBase()),
                  (Route<dynamic> route) => false);
            }
            else if (authstate.status == Status.ERROR) {
              FToast flutterToast = FToast();
              flutterToast.init(context);
              flutterToast.showToast(
                child: CommonToast(
                  displaymsg: authstate.data,
                ),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              );
            }
          }
          print('statedataaa ${authstate.status} ${authstate.data}');
        },
        builder: (context, authstate) =>
            BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
          builder: (_, state) => Scaffold(
              backgroundColor: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
              ),
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SiteSetting(refresh, false)));
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: InsColor(appBloc).appIconColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: useMobileLayout ? (20) : (width * 0.2)),
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20)),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30.h,
                            ),
                            SizedBox(
                              height: 86.h,
                              width: 276.h,
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => Image.asset(
                                        kSplashLogo,
                                      ),
                                  imageUrl: isSwitched
                                      ? appBloc.uiSettingModel.appDarkLogoURl
                                      : appBloc.uiSettingModel.appLogoURl),
                            ),
                            SizedBox(
                              height: 55.h,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: _validate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.disabled,
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 17.h,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            focusNode: reqFocusEmail,
                                            controller: ctrEamil,
                                            textInputAction: TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: validateEmail,
                                            onSaved: (val) =>
                                                ctrEamil.text = val ?? "",
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                            onEditingComplete: () =>
                                                FocusScope.of(context)
                                                    .requestFocus(reqFocusPwd),
                                            decoration: InputDecoration(
                                                enabled: isloading ? false : true,
                                                hintText: appBloc.localstr
                                                    .loginTextfieldUsernametextfieldplaceholder,
                                                hintStyle: TextStyle(
                                                    color: state.themeData
                                                        .primaryColorLight),
                                                suffixIcon: (_validate &&
                                                        !regExp.hasMatch(
                                                            ctrEamil.text))
                                                    ? Icon(Icons.info,
                                                        color: Colors.red,
                                                        size: ScreenUtil()
                                                            .setWidth(20))
                                                    : null),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 17.h,
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                            focusNode: reqFocusPwd,
                                            controller: ctrPassword,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.done,
                                            obscureText: _passwordVisible,
                                            validator: validatePwd,
                                            onSaved: (val) =>
                                                ctrPassword.text = val ?? "",
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                            onEditingComplete: () =>
                                                FocusScope.of(context).unfocus(),
                                            decoration: InputDecoration(
                                              enabled: isloading ? false : true,
                                              hintText: appBloc.localstr
                                                  .loginTextfieldPasswordtextfieldplaceholder,
                                              hintStyle: TextStyle(
                                                  color: state.themeData
                                                      .primaryColorLight),
                                              suffixIcon: (_validate &&
                                                      ctrPassword.text.length < 6)
                                                  ? Icon(Icons.info,
                                                      color: Colors.red,
                                                      size: ScreenUtil()
                                                          .setWidth(20))
                                                  : IconButton(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                      icon: Icon(
                                                          _passwordVisible
                                                              ? Icons
                                                                  .visibility_off
                                                              : Icons.visibility,
                                                          semanticLabel:
                                                              _passwordVisible
                                                                  ? 'show password'
                                                                  : 'hide password',
                                                          size: 20.h),
                                                      onPressed: () {
                                                        setState(() {
                                                          _passwordVisible =
                                                              !_passwordVisible;
                                                        });
                                                      }),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 55.h,
                                          child: MaterialButton(
                                            disabledColor: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                .withOpacity(0.5),
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            child: Text(
                                                appBloc.localstr
                                                            .loginButtonSigninbutton !=
                                                        null
                                                    ? appBloc.localstr
                                                        .loginButtonSigninbutton
                                                    : "",
                                                style: TextStyle(
                                                    fontSize: 14.h,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                            onPressed: ctrEamil.text.isEmpty
                                                ? null
                                                : () {
                                                    validate();
                                                  },
                                          )),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //Navigator.pushNamed(context, forgot_pwd_route);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPassword()));
//                                    print("...i am clicked....");
//                                    appBloc.add(ChangeLanEvent(
//                                        lanCode: 'ar'));
                                        },
                                        child: Text(
                                          '${appBloc.localstr.loginButtonForgotpasswordbutton} ?',
                                          style: TextStyle(
                                              fontSize: 12.h,
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 55.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            appBloc.uiSettingModel.selfRegistrationAllowed.toLowerCase() == 'true'
                              ? Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                            fontSize: 14.h,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //Membership disabled
                                          /*if (appBloc.uiSettingModel
                                                  .EnableMembership ==
                                              'True') {
                                            appBloc.uiSettingModel
                                                        .enableInAppPurchase ==
                                                    'true'
                                                ? _showMembershipPlansDialog(
                                                    context,
                                                    authBloc
                                                        .memberShipPlansList,
                                                    '')
                                                : Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                MembershipSignUpWebView()));
                                          } else {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                        create: (context) =>
                                                            ProviderModel(),
                                                        child:
                                                            DynamicSignUp())));
                                          }*/

                                          if (appBloc.uiSettingModel.enableMembership == 'True') {
                                            appBloc.uiSettingModel.enableInAppPurchase == 'True'
                                                ? _showMembershipPlansDialog(context, authBloc.memberShipPlansList, '\$')
                                                : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MembershipSignUpWebView()));
                                          }
                                          else {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                      create: (context) =>
                                                          ProviderModel(),
                                                      child: DynamicSignUp(),
                                                    )));
                                          }

                                          //
                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ChangeNotifierProvider(
                                          //             create: (context) =>
                                          //                 ProviderModel(),
                                          //             child:
                                          //                 DynamicSignUp())));
                                        },
                                        child: Text(
                                          appBloc.localstr
                                                      .loginButtonSignupbutton ==
                                                  null
                                              ? ''
                                              : appBloc.localstr
                                                  .loginButtonSignupbutton,
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                              decoration: TextDecoration
                                                  .underline,
                                              fontSize: 14.h),
                                        ),
                                      ),
                                    ],
                                  ),
                              )
                              : Container(),
                          ],
                        )),
                    Center(
                      child: authstate.status == Status.LOADING
                          ? AbsorbPointer(
                              child: AppConstants().getLoaderWidget())
                          : Container(),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  List<Widget> planItems(List<MemberShipPlanResponse> membershipList, String currency) {
    List<Widget> newItems = [];

    for (var membershipRes in membershipList) {
      newItems.add(Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        //constraints: BoxConstraints(minHeight: 300),
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: InsColor(appBloc).appBtnBgColor),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
        //height: 300,
        //width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

// List<Widget> planItems(
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
//                         if (data.productId == 'Gold 1') {
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
