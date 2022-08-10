part of 'messages_bloc.dart';

abstract class MessagesState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  MessagesState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MessagesState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MessagesState.error(data, {this.displayMessage = true}) : super.error(data);

  List<Object> get props => [];
}

class InitialMessagesState extends MessagesState {
  InitialMessagesState.completed(data) : super.completed(data);
}

class UserListState extends MessagesState {
  UserListState.loading(data) : super.loading(data);

  UserListState.completed() : super.completed('');

  UserListState.error(data) : super.error(data);
}

class ChatHistoryState extends MessagesState {
  ChatHistoryState.loading(data) : super.loading(data);

  ChatHistoryState.completed() : super.completed('');

  ChatHistoryState.error(data) : super.error(data);
}

class SendMessageState extends MessagesState {
  SendMessageState.loading(data) : super.loading(data);

  SendMessageState.completed() : super.completed('');

  SendMessageState.error(data) : super.error(data);
}

class SendAttachmentState extends MessagesState {
  SendAttachmentState.loading(data) : super.loading(data);

  SendAttachmentState.completed() : super.completed('');

  SendAttachmentState.error(data) : super.error(data);
}

class MessagesLoadSucceed extends MessagesState {
  String message = "";

  MessagesLoadSucceed.loading(data) : super.loading(data);

  MessagesLoadSucceed.completed({this.message = ""}) : super.completed(message);

  MessagesLoadSucceed.error(data) : super.error(data);
}

class UserSearchState extends MessagesState {
  String message = "";

  UserSearchState.loading(data) : super.loading(data);

  UserSearchState.completed({this.message = ""}) : super.completed(message);

  UserSearchState.error(data) : super.error(data);
}
