import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(deviceData.screenHeight * 0.025),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: deviceData.screenWidth * 0.058,
        ),
      ),
    );
  }
}
