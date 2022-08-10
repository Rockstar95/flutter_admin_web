import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';

class AppController {
  void checkRelatedContent({required BuildContext context, required DummyMyCatelogResponseTable2 table2, bool isTrackList = true}) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);

    if (AppDirectory.isValidString(table2.viewprerequisitecontentstatus ?? "")) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6 + " \"" +
          table2.viewprerequisitecontentstatus + "\" " + appBloc.localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: Text(
            appBloc.localstr.detailsAlerttitleStringalert,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(alertMessage),
          backgroundColor: AppColors.getAppBGColor(),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5)),
          actions: <Widget>[
            new FlatButton(
              child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
              textColor: Colors.blue,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventTrackList(
          table2,
          isTrackList,
          [],
        ),
      ));
    }
  }
}