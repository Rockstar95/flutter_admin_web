import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/feedback/feedback_repositry_public.dart';

class FeedbackRepositoryBuilder {
  static FeedbackRepository repository() {
    return FeedbackRepositoryPublic();
  }
}

abstract class FeedbackRepository {
  Future<Response?> feedbackSubmit({
    bool isUrl,
    String feedbackTitle,
    String imageFileName,
    String feedbackDesc,
    String currentUrl,
    Uint8List? image,
    String currentUserId,
    String date2,
    String currentSiteId,
  });

  Future<Response?> getFeedbackResponseEvent(String isAdmin);

  Future<Response?> deleteFeedbackEvent({int id});
}
