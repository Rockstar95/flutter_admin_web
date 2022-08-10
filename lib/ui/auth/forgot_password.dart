import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/bloc/auth_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/auth_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/auth_state.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repository_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/app_colors.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController ctrEamil = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;

  RegExp? regExp;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  late AuthBloc authBloc;
  late FToast flutterToast;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: AuthRepositoryBuilder.repository());
  }

  @override
  Widget build(BuildContext context) {
    //print("Forgot Password Build Called");

    flutterToast = FToast();
    flutterToast.init(context);
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    final width = MediaQuery.of(context).size.width;

    basicDeviceHeightWidth(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (_, stateVal) {
        if (stateVal is ForgotPasswordState) {
          switch (stateVal.status) {
            case Status.LOADING:
              break;
            case Status.ERROR:
              break;
            case Status.COMPLETED:
              return (stateVal.data != null && stateVal.data)
                  ? doNavigate()
                  : displayErrMsg(isActiveUser: stateVal.isActiveUser);
            default:
          }
        }
      },
      builder: (_, stateVal) => BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        builder: (_, state) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              appBloc.localstr.forgotpasswordHeaderForgotpasswordtitlelabel,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.getAppHeaderTextColor()
              ),
            ),
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.getAppHeaderColor(),
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color:AppColors.getAppBGColor(),
                padding: EdgeInsets.symmetric(
                    horizontal: useMobileLayout ? (20) : (width * 0.2),
                    vertical: useMobileLayout ? (20) : (width * 0.1)),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appBloc.localstr.forgotpasswordLabelGuidencetextlabel,
                      style: TextStyle(
                          fontSize: useMobileLayout ? 15 : 20,
                          color:AppColors.getAppTextColor()),
                    ),
                    SizedBox(
                      height: 55.h,
                    ),
                    RichText(text: TextSpan(text: "Email",
                        style: TextStyle(
                            color: AppColors.getAppTextColor().withOpacity(0.6),
                            fontSize: 15.h,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .5
                        ),)),
                    SizedBox(height: 5,),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: TextFormField(
                        validator: validateEmail,
                        controller: ctrEamil,
                        onSaved: (val) => ctrEamil.text = val ?? '',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: appBloc.localstr.forgotpasswordTextfieldEmailtextfieldplaceholder,
                            hintStyle: TextStyle(
                                color: state.themeData.primaryColorLight),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getBorderColor().withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getAppTextColor().withOpacity(0.7))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getBorderColor())),

                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Color(int.parse(
                            //         "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                            //   ),
                            // ),
                            suffixIcon: (_validate &&
                                    !(regExp?.hasMatch(ctrEamil.text) ?? false))
                                ? Icon(Icons.info,
                                    color: Colors.red,
                                    size: ScreenUtil().setWidth(20))
                                : null),
                        // describes the field number
                        style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          // style for the fields
                          fontSize: 14.h,
                        ),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55.h,
                        child: MaterialButton(
                          disabledColor: AppColors.getAppButtonBGColor()
                              .withOpacity(0.5),
                          color: AppColors.getAppButtonBGColor(),
                          child: Text(
                              appBloc.localstr
                                  .forgotpasswordButtonResetpasswordbutton,
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
                      height: 55.h,
                    ),
                    Center(
                      child: stateVal.status == Status.LOADING
                          ? AbsorbPointer(
                              child: SpinKitCircle(
                                color: Colors.grey,
                                size: 70.h,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h),);
  }

  String? validateEmail(String? value) {
    print(value);
    regExp = new RegExp(pattern);

    if (value?.length == 0) {
      return appBloc.localstr.forgotpasswordAlertsubtitleEnterusernameoremail;
    } else if (!regExp!.hasMatch(value ?? "")) {
      return appBloc.localstr.forgotpasswordAlertsubtitleEmailenteredisinvalid;
    } else {
      return null;
    }
  }

  void validate() {
    if (_formKey.currentState?.validate() ?? false) {
      // No any error in validation
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      authBloc.add(ForgotPasswordEvent(
          email: ctrEamil.text.trim(), localStr: appBloc.localstr));
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  doNavigate() async {
    flutterToast.showToast(
      child: CommonToast(
          displaymsg: appBloc.localstr
              .forgotpasswordAlertsubtitlePasswordresetlinksenttoyourregisteredemail),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    Navigator.of(context).pop();
  }

  displayErrMsg({bool isActiveUser = false}) async {
    flutterToast.showToast(
      child: CommonToast(
        displaymsg: isActiveUser ? appBloc.localstr.forgotpasswordAlertsubtitleFaliedtosendresetlinkcontactsiteadmin : appBloc.localstr.forgotpasswordAlertsubtitleYouraccountisdeactivated,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
