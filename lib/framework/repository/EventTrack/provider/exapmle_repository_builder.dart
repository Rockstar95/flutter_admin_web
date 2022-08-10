import 'package:flutter_admin_web/framework/repository/EventTrack/contract/event_track_repository.dart';
import 'package:flutter_admin_web/framework/repository/EventTrack/provider/event_track_api_repository.dart';

class EventTrackRepositoryBuilder {
  static EventTrackListRepository repository() {
    return EventTrackListApiRepository();
  }
}
