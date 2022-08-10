import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget getCommonLoading({double size = 70, Color color = Colors.grey}) {
  return Container(
    child: Center(
      child: AbsorbPointer(
        child: SpinKitCircle(
          color: color,
          size: size,
        ),
      ),
    ),
  );
}