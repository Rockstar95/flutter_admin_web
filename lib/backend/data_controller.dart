import 'package:flutter_admin_web/backend/classroom_events/classroom_events_controller.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:provider/provider.dart';

class DataController {
  void clearControllersData() {
    Provider.of<ClassroomEventsController>(NavigationController().mainNavigatorKey.currentContext!, listen: false).clearControllersData();
  }
}