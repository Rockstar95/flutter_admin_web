import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';

class RoundedSquareProgressIndicator extends StatelessWidget {
  const RoundedSquareProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: true);

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(int.parse('0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),)),
      ),
      child: SpinKitCircle(
        color: Color(int.parse('0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),),
        size: 50.h,
      ),
    );
  }
}
