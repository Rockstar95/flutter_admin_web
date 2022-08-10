import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/bloc/dynamic_signup_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/auth/event/dynamic_signup_event.dart';
import 'package:flutter_admin_web/framework/bloc/auth/state/dynamic_signup_state.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/auth/model/res_dynamic_signup.dart';
import 'package:flutter_admin_web/framework/repository/auth/provider/auth_repository_builder.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/ui/auth/login_page.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/app_colors.dart';

class DynamicSignUp extends StatefulWidget {
  final int membershipId;
  final String productId;

  const DynamicSignUp({Key? key, this.membershipId = 0, this.productId = ""})
      : super(key: key);

  @override
  _DynamicSignUpState createState() => _DynamicSignUpState();
}

class _DynamicSignUpState extends State<DynamicSignUp> {
  late DynamicSignUpBloc dynamicSignUpBloc;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  late FToast flutterToast;
  String confirmPwd = "";

  String userEmailID = ""; //'upendranath@instancy.com';
  String userPassword = ""; // = 'abcxyz';

  bool isPassVisible = false;
  bool isConfPassVisible = false;

  late RegExp regExp;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool checkedValue = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  var newTempUserId;

  bool isLoading = false;

  void deliverProduct({PurchaseDetails? purchaseDetails}) async {
    String paymentGateway = "";
    if(!kIsWeb) {
      if(Platform.isAndroid) {
        paymentGateway = "Android";
      }
      else if(Platform.isIOS) {
        paymentGateway = "IOS";
      }
    }

    dynamicSignUpBloc.add(PaymentProcessEvent(
      tempUserId: newTempUserId,
      token: purchaseDetails?.purchaseID ?? "",
      paymentGateway: paymentGateway,
    ));
  }

  void handlePurchaseError(IAPError? error) {
    print("handlePurchaseError called:$error");
    if(error != null) {
      MyToast.showToast(context, "Error in Buying Content : '${error.message}'");
    }
    else {
      MyToast.showToast(context, "Error in Buying Content");
    }
  }

  Future<void> handlePurchase(PurchaseDetails? purchaseDetails) async {
    if(purchaseDetails == null) {
      MyToast.showToast(context, "Purchase Failed");
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      MyToast.showToast(context, "Purchase Pending");
    }
    else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handlePurchaseError(purchaseDetails.error);
      }
      else if (purchaseDetails.status == PurchaseStatus.purchased) {
        deliverProduct(purchaseDetails: purchaseDetails);
      }
    }
  }

  /// InApp purchase implementation
  Future<void> _buyProduct(String productId) async {
    print("Product Id:$productId");

    if(productId.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Map<String, ProductDetails> map = await InAppPurchaseController().getProductDetails([productId]);
      print("Product Details Map:$map");

      if(map[productId] != null) {
        ProductDetails productDetails = map[productId]!;

        PurchaseDetails? purchaseDetails = await InAppPurchaseController().buyProduct(productDetails, isConsumable: false);
        await handlePurchase(purchaseDetails);
      }
      else {
        MyToast.showToast(context, "Product Details Not Available");
      }

      setState(() {
        isLoading = false;
      });
    }
    else {
      deliverProduct();
    }
  }

  @override
  void initState() {
    regExp = new RegExp(pattern);

    //initConnection();
    // initPlatformState();

    dynamicSignUpBloc = DynamicSignUpBloc(
      signUpRepository: AuthRepositoryBuilder.signUpRepository(),
      attributechoices: [],
      profileconfigdata: [],
      termsofWebPage: [],
      resDyanicSignUp: ResDyanicSignUp(
          profileconfigdata: [], termsofusewebpage: [], attributechoices: []),
    );
    dynamicSignUpBloc.add(GetDynamicFields());

    print("Product Id:${widget.productId}");

    super.initState();
  }

  @override
  Future<void> dispose() async {

    // await FlutterInappPurchase.instance.endConnection;
    //  if (_purchaseUpdatedSubscription != null) {
    //    _purchaseUpdatedSubscription.cancel();
    //    _purchaseUpdatedSubscription = null;
    //  }
    //  if (_purchaseErrorSubscription != null) {
    //    _purchaseErrorSubscription.cancel();
    //    _purchaseErrorSubscription = null;
    //  }
    //  setState(() {
    //  //  this._items = [];
    //    this._purchases = [];
    //  });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    basicDeviceHeightWidth(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState themeState) {
        return BlocConsumer<DynamicSignUpBloc, DynamicSignUpState>(
          bloc: dynamicSignUpBloc,
          listener: (context, state) async {
            print("DynamicSignUpBloc Listener Called for state:${state.runtimeType}");

            if (state is SignUpState) {
              if (state.isSuccess) {
                doShowMsg(state.message, false);
              }
              else {
                flutterToast.showToast(
                  child: CommonToast(displaymsg: state.message),
                  gravity: ToastGravity.CENTER,
                  toastDuration: Duration(seconds: 2),
                );
              }
            }

            if (state is SaveProfileState) {
              if (state.isSuccess) {
                /*
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg:
                          'InApp Purchase inProgress / Bypassing Payment'),
                  gravity: ToastGravity.CENTER,
                  toastDuration: Duration(seconds: 2),
                );
*/

                if(state.isMembership) {
                  newTempUserId = state.newTempUserId;

                  _buyProduct(widget.productId);
                }
                else {
                  doShowMsg(state.message, true);
                }
              }
              else {
                flutterToast.showToast(
                  child: CommonToast(displaymsg: state.message),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 2),
                );
              }
            }

            if (state is PaymentProcessState) {
              if (state.isSuccess) {
                doShowMsg(state.message, true);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  appBloc.localstr.signupHeaderSignupheaderlabel,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                ),
                elevation: 0,
                backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(
                      int.parse(
                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                    ),
                  ),
                ),
                actions: [
                  /*InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TempInAppPurchasePage()));
                    },
                    child: Text("Temp In App Purchase", style: TextStyle(color: Colors.black),),
                  ),*/
                ],
              ),
              body: SafeArea(
                  child: (dynamicSignUpBloc.profileconfigdata.isNotEmpty)
                      ? Container(
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                          child: Stack(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: ScrollablePositionedList.builder(
                                      itemCount: 1 + dynamicSignUpBloc.profileconfigdata.length,
                                      itemBuilder: (context, index) {
                                        if(index == 0) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h).copyWith(bottom: 30.h),
                                            child: Text(
                                              "Please fill in this form to create an account.",
                                              style: TextStyle(
                                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }
                                        index--;
                                        return getWidget(index, dynamicSignUpBloc.profileconfigdata, themeState, dynamicSignUpBloc);
                                      },
                                      itemScrollController: itemScrollController,
                                      itemPositionsListener: itemPositionsListener,
                                    ),
                                  ),
                                  dynamicSignUpBloc.isLoading
                                      ? Center(
                                          child: AbsorbPointer(
                                            child: SpinKitCircle(
                                              color: Colors.grey,
                                              size: 70.h,
                                            ),
                                          ),
                                        )
                                      : SizedBox(height: 1)
                                ],
                              ),
                             /*(dynamicSignUpBloc.isRegistered != null && !(dynamicSignUpBloc.isRegistered)) ? Center(
                               child: AbsorbPointer(
                                 child: SpinKitCircle(
                                   color: Colors.orange,
                                   size: 70.h,
                                 ),
                               ),
                             ): SizedBox(height: 1,)*/
                            ],
                          ),
                        )
                      : getProgressIndicator(),
              ),
              bottomNavigationBar: Container(
                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: <Widget>[
                      dynamicSignUpBloc.profileconfigdata.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.h,
                              child: MaterialButton(
                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                child: Text(
                                  appBloc.localstr.signupButtonSignup,
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                  ),
                                ),
                                onPressed: () {
                                  // for (var prod in provider.products)
                                  //   if (provider.hasPurchased(prod.id) !=
                                  //       null) {
                                  //   } else {
                                  //     if (Platform.isIOS &&
                                  //         prod.id == widget.productId) {
                                  //       _buyProduct(prod);
                                  //     } else if (Platform.isAndroid &&
                                  //         prod.id == widget.productId) {
                                  //       _buyProduct(prod);
                                  //     }
                                  //   }
                                  // return;

                                  //  _getProduct();

                                  String signUpVal = "";
                                  if((_formKey.currentState?.validate() ?? false) && validate(dynamicSignUpBloc.resDyanicSignUp.profileconfigdata)) {
                                    for (int i = 0;
                                        i <
                                            dynamicSignUpBloc.resDyanicSignUp
                                                .profileconfigdata.length;
                                        i++) {
                                      String fieldval =
                                          ''' '${dynamicSignUpBloc.resDyanicSignUp.profileconfigdata[i].valueName}' ''';

                                      var dividerVal = appBloc.uiSettingModel.enableMembership == 'True'
                                          ? ':'
                                          : '=';
                                      signUpVal = signUpVal + '${dynamicSignUpBloc.resDyanicSignUp.profileconfigdata[i].datafieldname.toLowerCase()}$dividerVal${fieldval.trim()},';
                                    }

                                    setState(() {
                                      if (appBloc.uiSettingModel.enableMembership == 'True') {
                                        if(widget.membershipId != -1 && widget.productId.isEmpty) {
                                          MyToast.showToast(context, "Payment Credentials Not Available");
                                          return;
                                        }

                                        dynamicSignUpBloc.add(
                                          SaveProfileEvent(
                                            membershipDurationId: widget.membershipId,
                                            value: signUpVal.substring(0, signUpVal.length - 1),
                                          ),
                                        );
                                      }
                                      else {
                                        dynamicSignUpBloc.add(SignupEvent(value: signUpVal.substring(0, signUpVal.length - 1)));
                                      }
                                    });

//                               print("i am goood to go.....'${dynamicSignUpBloc.resDyanicSignUp.profileconfigdata[i].datafieldname}  ${dynamicSignUpBloc.resDyanicSignUp.profileconfigdata[i].valueName}");
                                  }
                                },
                              ),
                            )
                          : SizedBox(height: 1,),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget getProgressIndicator() {
    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: Center(
        child: AbsorbPointer(
          child: SpinKitCircle(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ),
            size: 70.h,
          ),
        ),
      ),
    );
  }

  basicDeviceHeightWidth(double w, double h) {
    //ScreenUtil.init(BoxConstraints(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h), designSize: Size(w, h));
  }

  List<Widget> _getListings(DynamicSignUpBloc dynamicSignUpBloc, ChangeThemeState themeState) {
    List<Widget> listings = [];
    List<Profileconfigdatum> profileConfigData = dynamicSignUpBloc.resDyanicSignUp.profileconfigdata;
    int i = 0;
    for (i = 0; i < profileConfigData.length; i++) {
      listings.add(getWidget(i, profileConfigData, themeState, dynamicSignUpBloc));
    }
    return listings;
  }

  Widget getWidget(int i, List<Profileconfigdatum> profileConfigData, ChangeThemeState themeState, DynamicSignUpBloc dynamicSignUpBloc) {
    Widget fieldWidget = Container();

    Profileconfigdatum item = profileConfigData[i];

    // controller
    int uiControlTypeId = item.uicontroltypeid;

    // comparing Attribut
    int attributeConfigId = item.attributeconfigid;
    bool termsExists = false;

    // this is for labelField , EditTextHint ,
    String displayText = item.displaytext;
    if (attributeConfigId == 522) {
      termsExists = true;
    }
    else if([1, 9, 15, 4, 10, 11, 2, 984].contains(uiControlTypeId)) {
      TextInputType keyboardType;
      bool isPassword = false;
      bool isRequired = false;
      isRequired = item.isrequired;

      bool isEmail = false;

      if (attributeConfigId == 6 || attributeConfigId == -1) {
        keyboardType = TextInputType.visiblePassword;
        isPassword = true;
      }
      else if([18, 1438, 1439, 16].contains(attributeConfigId)) {
        keyboardType = TextInputType.number;
      }
      else if (attributeConfigId == 15) {
        keyboardType = TextInputType.emailAddress;
        isEmail = true;
      }
      else {
        keyboardType = TextInputType.text;
      }

      fieldWidget = Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              //color: Colors.red,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(text: TextSpan(text: displayText,
                          style: TextStyle(
                            color: AppColors.getAppTextColor(),
                            fontSize: 14,
                          ),
                          children: [
                        TextSpan(text: isRequired ? " *":"",style: TextStyle(color: Colors.red)),
                      ] )),
                      // Flexible(
                      //   child: Container(
                      //     /*decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.green)
                      //     ),*/
                      //     child: Text(
                      //       //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                      //       isRequired ? displayText + " *" : displayText,
                      //       style: TextStyle(
                      //         color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          /*decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)
                          ),*/
                          child: TextFormField(
                            style: TextStyle(
                              color: AppColors.getAppTextColor(),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLength: item.maxlength,
                            obscureText: isPassword && isPassVisible,
                            keyboardType: keyboardType,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                              counterStyle: TextStyle(
                                fontSize: 11.h,
                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: displayText,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: AppColors.getTextFieldHintColor(),
                              ),
                              //constraints: BoxConstraints(maxHeight: 58.h,),
                              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              suffixIcon: isPassword ? InkWell(
                                onTap: (){
                                  isPassVisible = !isPassVisible;
                                  setState((){});
                                },
                                child: Icon(isPassVisible ? FontAwesomeIcons.eyeSlash:FontAwesomeIcons.eye,size: 20,color: Colors.grey,),
                              ) : null,
                            ),
                            validator: isEmail ? (String? value) {
                              if(value?.isNotEmpty ?? false) {
                                if(RegExp(r"([0-9a-zA-Z].*?@([0-9a-zA-Z].*\.\w{2,4}))").hasMatch(value!)) {
                                  return null;
                                }
                                else {
                                  return "Invalid Email";
                                }
                              }
                              else {
                                return "Email Cannot be empty";
                              }
                            } : null,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                            onFieldSubmitted: (val) {
                              item.valueName = val;
                              dynamicSignUpBloc.profileconfigdata[i] = item;
                              _formKey.currentState?.validate();
                            },
                            onChanged: (val) {
                              print("val.....$val");
                              item.valueName = val;
                              dynamicSignUpBloc.profileconfigdata[i] = item;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  (attributeConfigId == 6)
                      ? Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      text: appBloc.localstr.signupconfirmpasswordTitleConfirmpasswordtitle,
                                      children: [
                                        if(isRequired) TextSpan(
                                          text: " *",
                                          style: TextStyle(
                                            color: AppColors.getMandatoryStarColor(),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                          color: AppColors.getAppTextColor(),
                                          fontSize: 14,
                                      ),
                                    ),
                                    //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    style: TextStyle(
                                        color: Color(
                                          int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                        ),
                                        fontWeight: FontWeight.w400),
                                    maxLength: item.maxlength,
                                    obscureText: isConfPassVisible,
                                    keyboardType: keyboardType,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                      counterStyle: TextStyle(
                                        fontSize: 11.h,
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: appBloc.localstr.signupconfirmpasswordTitleConfirmpasswordtitle,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.getTextFieldHintColor(),
                                      ),
                                      //constraints: BoxConstraints(maxHeight: 58.h,),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.getTextFieldBorderColor())),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                      suffixIcon: InkWell(
                                        onTap: (){
                                          isConfPassVisible = !isConfPassVisible;
                                          setState((){});
                                        },
                                        child: Icon(isConfPassVisible ? FontAwesomeIcons.eyeSlash:FontAwesomeIcons.eye,size: 20,color: Colors.grey,),
                                      ),
                                    ),
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    onSubmitted: (val) {
                                      confirmPwd = val;
                                      dynamicSignUpBloc.profileconfigdata[i] = item;
                                    },
                                    onChanged: (val) {
                                      print("val.....$val");
                                      confirmPwd = val;
                                      dynamicSignUpBloc.profileconfigdata[i] = item;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      );
    }
    else if ([3, 18].contains(uiControlTypeId)) {
      print("......i am from bloc..val.....${item.valueName}");
      bool isRequired = item.isrequired;

      fieldWidget = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                          isRequired ? displayText + " *" : displayText,
                          style: TextStyle(
                              color: themeState.themeData.primaryColor,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<Attributechoice>(
                    dropdownColor: Color(
                      int.parse(
                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                    ),
                    value: item.selectedSpinerObj,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: themeState.themeData.primaryColor, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    onChanged: (Attributechoice? data) {
                      item.selectedSpinerObj = data ?? Attributechoice();
                      item.valueName = data?.choicevalue ?? "";
                      profileConfigData[i] = item;
                      dynamicSignUpBloc.add(UpdateListFromUiEvent(
                          profileconfigdata: profileConfigData));
                    },
                    items: item.spinnerItems
                        .map<DropdownMenuItem<Attributechoice>>(
                            (Attributechoice value) {
                      return DropdownMenuItem<Attributechoice>(
                          value: value,
                          child: Text(
                            value.choicetext,
                            style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                            ),
                          ));
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    else if (uiControlTypeId == 8) {
      bool isRequired = item.isrequired;
      fieldWidget = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          //displayText + " " + i.toString() + ".....uiControl = $uiControlTypeId"+"...ConfigId = $attributeConfigId",
                          isRequired ? displayText + " *" : displayText,
                          style: TextStyle(
                              color: themeState.themeData.primaryColor,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
    else if (attributeConfigId == 4) {
      fieldWidget = getTnC(dynamicSignUpBloc.termsofWebPage);
    }
    else {
      fieldWidget = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20.0), child: Container()),
          ),
        ],
      );
    }

//
//
    if (termsExists && dynamicSignUpBloc.termsofWebPage.length != 0) {
      fieldWidget = getTnC(
        dynamicSignUpBloc.termsofWebPage,
      );
    }

    return fieldWidget;
  }

  bool validate(List<Profileconfigdatum> profileconfigdata) {
    bool isValidate = false;

//    profileconfigdata.forEach((element) {});

    for (var element in profileconfigdata) {
      print('profileconfig ${element.displaytext}, isrequired:${element.isrequired}, valuename:${element.valueName}');
      if (element.isrequired && element.attributeconfigid == 15 && element.valueName != null) {
        if (regExp.hasMatch(element.valueName)) {
          isValidate = true;
          userEmailID = element.valueName;
        } else {
          isValidate = false;
          showToast(appBloc.localstr.signupAlertsubtitleInvalidemail);
          break;
        }
      }
      else if (!element.isrequired && element.attributeconfigid == 15) {
        if (element.valueName != null && element.valueName.length > 0) {
          if (regExp.hasMatch(element.valueName)) {
            isValidate = true;
          } else {
            isValidate = false;
            showToast(appBloc.localstr.signupAlertsubtitleInvalidemail);
            break;
          }
        } else {
          isValidate = true;
        }
      }
      else if (element.isrequired && element.attributeconfigid == 6 && element.valueName != null) {
        if (confirmPwd != element.valueName) {
          isValidate = false;
          showToast(appBloc.localstr.signupAlertsubtitlePassworddonotmatch);
        } else {
          isValidate = true;
          userPassword = element.valueName;
        }
      }
      else if (element.isrequired && element.valueName.isEmpty) {
        isValidate = false;
        showToast(element.displaytext + " is required");
        break;
      }
      else if ((dynamicSignUpBloc.termsofWebPage != null || dynamicSignUpBloc.termsofWebPage.length > 0) && element.attributeconfigid == 522) {
        if (checkedValue) {
          isValidate = true;
        } else {
          isValidate = false;
          showToast(appBloc.localstr.signupAlertsubtitlePleaseaccepttermsandconditions);
          break;
        }
      }
      if (element.attributeconfigid == 15) {
        if (element.valueName != null && element.valueName.length > 0) {
          if (regExp.hasMatch(element.valueName)) {
            userEmailID = element.valueName;
          }
        }
      }
      if (element.isrequired && element.attributeconfigid == 6 && element.valueName != null) {
        userPassword = element.valueName;
      }
    }

    print('userPassword $userPassword');
    print('userEmailID $userEmailID');

    return isValidate;
  }

  showToast(String item) async {
    flutterToast.showToast(
      child: disToast(item),
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget disToast(String displaytext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            .withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
          ),
          SizedBox(
            width: 12.0,
          ),
          Text("$displaytext",
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
        ],
      ),
    );
  }

  void doShowMsg(String message, bool autologin) async {
    flutterToast.showToast(
      child: CommonToast(displaymsg: message),
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    print('after payment doShowMsg userPassword $userPassword');
    print('after payment doShowMsg userEmailID $userEmailID');

    autologin
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(
                  userID: userEmailID,
                  userPwd: userPassword,
                  isAutologin: autologin,
                )))
        : Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget getTnC(List<Termsofusewebpage> termsofWebPage) {
    print('termsofweb ${termsofWebPage.length}');
    if (termsofWebPage != null || termsofWebPage.length != 0) {
      return CheckboxListTile(
        activeColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        checkColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'By creating an account, you agree to  our',
              style: TextStyle(fontSize: 14.h, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text:
                        '\n${appBloc.localstr.signupButtonTermsandconditions}',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 14.h),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = ApiEndpoints.strSiteUrl +
                            termsofWebPage[0].termsofusewebpage;
                        print('urldata $url');
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(
                            url,
                          );
                        }
                      })
              ]),
        ),
        value: checkedValue,
        onChanged: (newValue) {
          setState(() {
            checkedValue = newValue ?? false;
          });
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      );
    } else {
      return Container();
    }
  }
}
