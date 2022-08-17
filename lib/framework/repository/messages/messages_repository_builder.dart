import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';

import 'messages_repository_public.dart';

class MessagesRepositoryBuilder {
  static MessagesRepository repository() {
    return MessagesRepositoryPublic();
  }
}

abstract class MessagesRepository {
  Future<Response?> getChatConnectionUserList();

  Future<List<Map<String, dynamic>>> getChatHistory(
      {String fromUserId, String toUserId, bool markAsRead});

  Future<Response?> postChatMessage(
      {String fromUserId,
      String toUserId,
      String message,
      required DateTime dateTime,
      bool markAsRead,
      String chatRoom});

  Future<Response?> uploadMessageFileData({
    Uint8List? fileBytes,
    String fileName,
    String toUserId,
    MessageType msgType,
    String chatRoom,
  });
}
