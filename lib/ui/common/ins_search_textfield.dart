import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';

import 'app_colors.dart';

class InsSearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final AppBloc appBloc;
  final Widget? suffixIcon;
  final void Function() onTapAction;
  final void Function(String)? onChanged;
  final void Function(String) onSubmitAction;

  const InsSearchTextField({
    Key? key,
    this.controller,
    required this.appBloc,
    this.suffixIcon,
    required this.onSubmitAction,
    required this.onTapAction,
    this.onChanged,
  })
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDADCE0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onTap: onTapAction,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: appBloc.localstr.commoncomponentLabelSearchlabel,
                            hintStyle: TextStyle(color: AppColors.getAppTextColor().withOpacity(0.7)),
                          ),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: AppColors.getAppTextColor(),
                          ),
                          controller: controller,
                          onSubmitted: (value) {
                            onSubmitAction(value);
                          },
                        ),
                      ),
                    ),
                    suffixIcon == null
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: suffixIcon
                          )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
