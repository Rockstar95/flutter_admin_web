import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';

import '../common/app_colors.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key? key,
    required this.controller,
    required this.appBloc,
  }) : super(key: key);

  final TextEditingController controller;
  final AppBloc appBloc;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Container(
      width: deviceData.screenWidth * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(deviceData.screenWidth * 0.05),
        ),
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        textInputAction: TextInputAction.newline,
        cursorColor: AppColors.getAppTextColor(),
        style: TextStyle(
          color: InsColor(appBloc).appTextColor,
          fontSize: deviceData.screenHeight * 0.018,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: InsColor(appBloc).appBGColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
                Radius.circular(deviceData.screenWidth * 0.05)),
          ),
          hintText: "Type your message",
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
