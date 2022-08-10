import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';

class InsSearchTextField extends StatelessWidget {
  final AppBloc appBloc;
  final String text;

  const InsSearchTextField({Key? key, required this.appBloc, this.text = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
          ),
        ],
      ),
    );
  }
}
