import 'package:flutter/material.dart';

class CommonToast extends StatelessWidget {
  final String displaymsg;

  CommonToast({this.displaymsg = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border.all(
          color: Colors.black.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          displaymsg,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
