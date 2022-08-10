import 'package:flutter/material.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';

class CommonPrimarySecondaryButton extends StatelessWidget {
   CommonPrimarySecondaryButton({
     Key? key,
     this.onPressed,
     this.text = "",
     this.isPrimary = false,
     this.icon,
     this.iconSize = 24,
     this.textSize = 14,
   }) : super(key: key);

   final Function()? onPressed;
   final String text;
   final bool isPrimary;
   final IconData? icon;
   final double iconSize, textSize;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
        side: BorderSide(color: isPrimary?Colors.transparent : AppColors.getAppButtonBGColor()),
      ),
      color: isPrimary ? AppColors.getAppButtonBGColor() : Colors.white,
      onPressed:onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getIcon(),
          Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white:AppColors.getAppButtonBGColor(),
              fontSize: textSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget getIcon() {
    if(icon != null) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: Icon(icon, size: iconSize, color: isPrimary ? Colors.white:AppColors.getAppButtonBGColor(),),
      );
    }
    else {
      return SizedBox();
    }
  }
}
