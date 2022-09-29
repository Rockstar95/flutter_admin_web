import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/bloc/preference_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/preference/event/preference_event.dart';
import 'package:flutter_admin_web/framework/bloc/preference/model/payment_response.dart';
import 'package:flutter_admin_web/framework/bloc/preference/state/preference_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/preference/preference_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../../configs/constants.dart';

class PaymentHistoryScreen extends StatefulWidget {
  PaymentHistoryScreen();

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late PreferenceBloc preferenceBloc;

  String _timezone = '';

  //List<String> _langKnown = ['English', 'Thai'];
  String _currentLang = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    preferenceBloc = PreferenceBloc(
        preferenceRepository: PreferenceRepositoryBuilder.repository());

    preferenceBloc.isFirstLoading = true;

    preferenceBloc.add(GetPaymentHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Purchase History",
              style: TextStyle(
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
            actions: <Widget>[],
          ),
          body: BlocConsumer<PreferenceBloc, PreferenceState>(
            bloc: preferenceBloc,
            listener: (context, state) {
              if (state.status == Status.ERROR) {
                if (state.message == "401") {
                  AppDirectory.sessionTimeOut(context);
                }
              }
            },
            builder: (context, state) {
              if (preferenceBloc.isFirstLoading == true) {
                return Container(
                  child: Center(
                    child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70)
                    ),
                  ),
                );
              }

              if (preferenceBloc.paymentList.length == 0) {
                return Container(
                  child: Center(
                    child: Text(
                      appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.apply(color: InsColor(appBloc).appTextColor),
                    ),
                  ),
                );
              }

              return Container(
                child: ListView.builder(
                  itemCount: preferenceBloc.paymentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: PaymentHistoryCell(
                        payment: preferenceBloc.paymentList[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PaymentHistoryCell extends StatelessWidget {
  final void Function()? onTap;
  final PaymentData payment;

  PaymentHistoryCell({Key? key, required this.payment, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${ApiEndpoints.strSiteUrl}${PaymentHistory.userProfilePathdata}');

    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: true);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 3.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 8,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Name :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        payment.itemName,
                        style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Date :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(payment.purchasedDate,
                          style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Total Price :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '${payment.currencySign} ${payment.price.toString()}',
                        style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Payment Type :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(payment.paymentType,
                          style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                    )
                  ],
                ),
                //color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
