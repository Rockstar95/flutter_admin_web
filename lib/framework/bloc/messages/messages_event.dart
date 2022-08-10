part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class GetAllUserListEvent extends MessagesEvent {
  GetAllUserListEvent();

  List<Object> get props => [];
}

class GetChatHistoryEvent extends MessagesEvent {
  final toUserId;
  final markAsRead;

  GetChatHistoryEvent({this.toUserId, this.markAsRead});

  List<Object> get props => [this.toUserId, this.markAsRead];
}

class SendMessageEvent extends MessagesEvent {
  final message;
  final toUserId;
  final markAsRead;
  final chatRoom;

  SendMessageEvent(
      {@required this.message,
      @required this.toUserId,
      @required this.chatRoom,
      this.markAsRead})
      : assert(message != null, "field must equal value"),
        assert(toUserId != null, "field must equal value");

  List<Object> get props => [message, toUserId, markAsRead];
}

class SendAttachmentEvent extends MessagesEvent {
  final filePath;
  final fileName;
  final toUserId;
  final msgType;
  final chatRoom;

  SendAttachmentEvent(
      {@required this.filePath,
      @required this.fileName,
      @required this.chatRoom,
      this.toUserId,
      this.msgType})
      : assert(filePath != null, "field must equal value"),
        assert(fileName != null, "field must equal value"),
        assert(toUserId != null, "field must equal value"),
        assert(msgType != null, "field must equal value");

  List<Object> get props => [filePath, fileName, toUserId, msgType];
}

/*
class MessagesStartFetching extends MessagesEvent {
  final User user;
  MessagesStartFetching(this.user)
      : assert(user != null, "field must equal value");
  List<Object> get props => [user];
}

class NewMessagesFetched extends MessagesEvent {
  final List<Message> messages;
  const NewMessagesFetched(this.messages)
      : assert(messages != null, "field must equal value");
  @override
  List<Object> get props => [messages];
}
*/

class MoreMessagesFetched extends MessagesEvent {
  final int messagesLength;
  final double scrollposition;

  MoreMessagesFetched(this.scrollposition, this.messagesLength);

  List<Object> get props => [scrollposition];
}

class SearchUserEvent extends MessagesEvent {
  final String searchStr;

  SearchUserEvent(this.searchStr);
}
