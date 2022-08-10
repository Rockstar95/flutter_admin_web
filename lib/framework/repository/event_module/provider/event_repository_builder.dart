import 'package:flutter_admin_web/framework/repository/event_module/contract/event_module_repository.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository.dart';

class EventRepositoryBuilder {
  static EventModuleRepository repository() {
    return EventInfoRepository();
  }
}
