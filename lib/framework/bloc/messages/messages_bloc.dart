import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_user_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/messages/messages_repository_builder.dart';
import 'package:flutter_admin_web/ui/messages/messages_header.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:meta/meta.dart';

import 'chat_message_response.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesRepository messagesRepository;

  final int firstMessagesLength = 15;
  final int moreMessagesLength = 5;
  List<Message> allMessages = [];
  List<ChatUser> allUsersList = [];
  List<ChatUser> usersList = [];
  String friendId = "";
  bool isFirstLoading = true;
  bool isAttachmentUploading = false;
  String searchString = '';

  MessagesBloc({required this.messagesRepository, myConnectionRepository})
      : super(InitialMessagesState.completed("data")) {
    on<GetAllUserListEvent>(onEventHandler);
    on<GetChatHistoryEvent>(onEventHandler);
    on<SendMessageEvent>(onEventHandler);
    on<SendAttachmentEvent>(onEventHandler);
    on<MoreMessagesFetched>(onEventHandler);
    on<SearchUserEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MessagesEvent event, Emitter emit) async {
    print("MessagesBloc onEventHandler called for ${event.runtimeType}");
    Stream<MessagesState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MessagesState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  InitialMessagesState get initialState =>
      InitialMessagesState.completed('data');

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event,) async* {
    if (event is GetAllUserListEvent) {
      yield* handleUserListEvent(event);
    }
    else if (event is GetChatHistoryEvent) {
      yield* handleChatHistoryEvent(event);
    }
    else if (event is MoreMessagesFetched) {
      yield* handleMoreMessagesFetchedEvent(event);
    }
    else if (event is SendMessageEvent) {
      yield* handleMessageSentEvent(event);
    }
    else if (event is SendAttachmentEvent) {
      yield* handleAttachmentSentEvent(event);
    }
    else if (event is SearchUserEvent) {
      yield* handleUserSearchEvent(event);
    }
  }

  Stream<MessagesState> handleUserListEvent(GetAllUserListEvent event) async* {
    if (!await Functions.getNetworkStatus(duration: Duration(milliseconds: 100))) {
      //yield MessagesLoadFailed(NetworkException());
    }
    else {
      try {
        isFirstLoading = true;
        yield UserListState.loading(null);
        
        //yield MessagesState.loading('Please wait');
        Response? apiResponse = await messagesRepository.getChatConnectionUserList();
        var strUserID = await sharePrefGetString(sharedPref_userid);
        var strSiteID = await sharePrefGetString(sharedPref_siteid);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          MyPrint.logOnConsole("GetAllUserListEvent Response:${apiResponse?.body.toString() ?? ""}");

          ChatUserResponse userResponse = ChatUserResponse.fromJson(jsonDecode(apiResponse?.body ?? "{}"));
          allUsersList = userResponse.table.toSet().toList();
          List<ChatUser> tempList = [];
          for (var item in userResponse.table) {
            if (!tempList.map((e) => e.userId).contains(item.userId)) {
              tempList.add(item);
            }
          }

          allUsersList = tempList;

          this.allUsersList = this
              .allUsersList
              .where((item) => (((item.myconid.toString() == strUserID && item.connectionStatus == 1) || ([8, 12, 16].contains(item.roleId))) && item.siteId.toString() == strSiteID && item.userStatus == 1))
              .toList();
          // .filter(item => {
          // return ((item.Myconid == this.intUserID && item.ConnectionStatus == 1) || (item.RoleID == 12 || item.RoleID == 8 || item.RoleID == 16) && item.SiteID == this.intSiteID && item.UserStatus == 1)
          // })
          //this.userChatList = this.removeDuplicates(this.userChatList, 'UserID')
          // this.userChatList.forEach(element => {
          // element.ConnectionId = 'default', element.isOnline = false;
          // this.OverAllCount = this.OverAllCount + element.UnReadCount;
          // });

          //this.userChatList = sortBy(this.userChatList, [function (o) { return o.RankNo; }]);
          this.allUsersList.sort((a, b) {
            return a.rankNo.compareTo(b.rankNo);
          });
          // List<String> groupList = [];
          // for (var element in tempList) {
          //   (groupList[element.role] ??= '').add(element.role);
          // }

          this.usersList = allUsersList;
          //print("Response" + tempList.length.toString());
          yield UserListState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield UserListState.error('401');
        }
        else {
          yield UserListState.error('Something went wrong');
        }
      }
      catch (e, s) {
        print("Error $e");
        MyPrint.printOnConsole(s);
        isFirstLoading = false;
      }
    }
  }

  Stream<MessagesState> handleChatHistoryEvent(GetChatHistoryEvent event) async* {
    if (!await Functions.getNetworkStatus(
        duration: Duration(milliseconds: 100))) {
      //yield MessagesLoadFailed(NetworkException());
    } else {
      try {
        yield ChatHistoryState.loading('Please wait');
        List<Map<String, dynamic>> apiResponse =
            await messagesRepository.getChatHistory(
                toUserId: event.toUserId, markAsRead: event.markAsRead);
        //if (apiResponse.statusCode == 200) {
        isFirstLoading = false;
        //print("REsponse" + apiResponse.data.toString());
        // ChatMessageResponse chatResponse =
        //     ChatMessageResponse.fromJson(apiResponse);

        /*
        print("Response" + apiResponse.toString());
        CollectionReference _fireStore =
            FirebaseFirestore.instance.collection('messages');
        await _fireStore.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print(doc.data());
            // messages.add(doc.data());
          });
        });
        _fireStore.snapshots().listen((querySnapshot) {
          allMessages = apiResponse.map((i) => Message.fromJson(i)).toList();
          print('passing');
        });
        */
        allMessages = apiResponse.map((i) => Message.fromJson(i)).toList();
        // allMessages = chatResponse.table1.reversed.toList();
        yield ChatHistoryState.completed();
        // } else if (apiResponse.statusCode == 401) {
        //   yield ChatHistoryState.error('401');
        // } else {
        //   yield ChatHistoryState.error('Something went wrong');
        // }
      } catch (e) {
        print("Error $e");
        isFirstLoading = false;
      }
    }
  }

  // Stream<MessagesState> handleChatHistoryEvent(
  //     GetChatHistoryEvent event) async* {
  //   if (!await Functions.getNetworkStatus(
  //       duration: Duration(milliseconds: 100))) {
  //     //yield MessagesLoadFailed(NetworkException());
  //   } else {
  //     try {
  //       yield ChatHistoryState.loading('Please wait');
  //       Response apiResponse = await messagesRepository.getChatHistory(
  //           toUserId: event.toUserId, markAsRead: event.markAsRead);
  //       if (apiResponse.statusCode == 200) {
  //         isFirstLoading = false;
  //         //print("REsponse" + apiResponse.data.toString());
  //
  //         ChatMessageResponse chatResponse =
  //             ChatMessageResponse.fromJson(apiResponse.data);
  //         print("Response" + chatResponse.table1.toString());
  //         allMessages = chatResponse.table1.reversed.toList();
  //         yield ChatHistoryState.completed();
  //       } else if (apiResponse.statusCode == 401) {
  //         yield ChatHistoryState.error('401');
  //       } else {
  //         yield ChatHistoryState.error('Something went wrong');
  //       }
  //     } catch (e) {
  //       print("Error $e");
  //       isFirstLoading = false;
  //     }
  //   }
  // }

  Stream<MessagesState> handleMessageSentEvent(SendMessageEvent event) async* {
    if (!await Functions.getNetworkStatus(
        duration: Duration(milliseconds: 100))) {
      //yield MessagesLoadFailed(NetworkException());
    }
    else {
      try {
        yield SendMessageState.loading('Please wait');

        Response? apiResponse = await messagesRepository.postChatMessage(
          toUserId: event.toUserId,
          message: event.message,
          dateTime: DateTime.now(),
          markAsRead: event.markAsRead,
          chatRoom: event.chatRoom,
        );
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          print("Responsde" + apiResponse.toString());

          // ChatMessageResponse chatResponse =
          //     ChatMessageResponse.fromJson(apiResponse.data);
          // allMessages = chatResponse.table1;
          yield SendMessageState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield SendMessageState.error('401');
        }
        else {
          yield SendMessageState.error('Something went wrong');
        }
      } catch (e) {
        print("Error $e");
        isFirstLoading = false;
      }
    }
  }

  Stream<MessagesState> handleAttachmentSentEvent(SendAttachmentEvent event) async* {
    if (!await Functions.getNetworkStatus(
        duration: Duration(milliseconds: 100))) {
      //yield MessagesLoadFailed(NetworkException());
    } else {
      try {
        yield SendAttachmentState.loading('Please wait');

        isAttachmentUploading = true;
        Response? apiResponse = await messagesRepository.uploadMessageFileData(
            filePath: event.filePath,
            fileName: event.fileName,
            toUserId: event.toUserId,
            msgType: event.msgType,
            chatRoom: event.chatRoom);

        isAttachmentUploading = false;
        yield SendAttachmentState.completed();
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          print("Response" + apiResponse.toString());

          // ChatMessageResponse chatResponse =
          //     ChatMessageResponse.fromJson(apiResponse.data);
          // allMessages = chatResponse.table1;
          yield SendAttachmentState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield SendAttachmentState.error('401');
        } else {
          yield SendAttachmentState.error('Something went wrong');
        }
      } catch (e) {
        print("Error $e");
        isFirstLoading = false;
      }
    }
  }

  Stream<MessagesState> handleUserSearchEvent(SearchUserEvent event) async* {
    if (!await Functions.getNetworkStatus(
        duration: Duration(milliseconds: 100))) {
      //yield MessagesLoadFailed(NetworkException());
    } else {
      try {
        yield UserSearchState.loading('Please wait');

        if (searchString == '') {
          usersList = allUsersList;
        } else {
          usersList = allUsersList
              .where((element) => element.fullName.contains(event.searchStr))
              .toList();
        }

        yield UserSearchState.completed();
      } catch (e) {
        print("Error $e");
        yield UserSearchState.error('Something went wrong');
      }
    }
  }

  // Stream<ChatHistoryState> handleChatHistoryEvent(
  //     GetChatHistoryEvent event) async* {
  //   if (!await Functions.getNetworkStatus(
  //       duration: Duration(milliseconds: 100))) {
  //     //yield MessagesLoadFailed(NetworkException());
  //   } else {
  //     try {
  //       yield ChatHistoryState.loading('Please wait');
  //       Response apiResponse = await messagesRepository.getChatHistory(
  //           toUserId: event.toUserId, markAsRead: event.markAsRead);
  //       if (apiResponse.statusCode == 200) {
  //         isFirstLoading = false;
  //         //print("REsponse" + apiResponse.data.toString());
  //
  //         ChatMessageResponse chatResponse =
  //             ChatMessageResponse.fromJson(apiResponse.data);
  //         print("Response" + chatResponse.table1.toString());
  //         allMessages = chatResponse.table1.reversed.toList();
  //         yield ChatHistoryState.completed();
  //       } else if (apiResponse.statusCode == 401) {
  //         yield ChatHistoryState.error('401');
  //       } else {
  //         yield ChatHistoryState.error('Something went wrong');
  //       }
  //     } catch (e) {
  //       print("Error $e");
  //       isFirstLoading = false;
  //     }
  //   }
  // }
  // Stream<MessagesState> handleMessageSentEvent(SendMessageEvent event) async* {
  //   if (!await Functions.getNetworkStatus(
  //       duration: Duration(milliseconds: 100))) {
  //     //yield MessagesLoadFailed(NetworkException());
  //   } else {
  //     try {
  //       yield SendMessageState.loading('Please wait');
  //       Response apiResponse = await messagesRepository.postChatMessage(
  //           toUserId: event.toUserId,
  //           message: event.message,
  //           dateTime: DateTime.now(),
  //           markAsRead: event.markAsRead);
  //       if (apiResponse.statusCode == 200) {
  //         isFirstLoading = false;
  //         print("Responsde" + apiResponse.toString());
  //
  //         // ChatMessageResponse chatResponse =
  //         //     ChatMessageResponse.fromJson(apiResponse.data);
  //         // allMessages = chatResponse.table1;
  //         yield SendMessageState.completed();
  //       } else if (apiResponse.statusCode == 401) {
  //         yield SendMessageState.error('401');
  //       } else {
  //         yield SendMessageState.error('Something went wrong');
  //       }
  //     } catch (e) {
  //       print("Error $e");
  //       isFirstLoading = false;
  //     }
  //   }
  // }

  // Stream<MessagesState> handleMessagesStartFetchingEvent(
  //     MessagesStartFetching event) async* {
  //   //yield MessagesLoading();
  //   if (!await Functions.getNetworkStatus(
  //       duration: Duration(milliseconds: 100))) {
  //     //yield MessagesLoadFailed(NetworkException());
  //   } else {
  //     try {
  //       friendId = event.user.userId;
  //       _streamSubscription?.cancel();
  //       final messagesStream = storageRepository.fetchFirstMessages(
  //           userId: userId, friendId: friendId, maxLength: firstMessagesLength);
  //       _streamSubscription = messagesStream.listen((messages) async {
  //         messages ??= [];
  //         // messages have length of 1 then next listen they have length more than 1
  //         // this behavior I cant explain now
  //         if (allMessages.length < 1 || allMessages.length < messages.length) {
  //           allMessages = messages;
  //         } else {
  //           allMessages = messages + allMessages.sublist(messages.length - 1);
  //         }
  //         if (allMessages.length > 0 && allMessages[0].senderId != userId) {
  //           storageRepository.markMessageSeen(userId, event.user.userId);
  //         }
  //         add(NewMessagesFetched(allMessages));
  //       });
  //     } on Failure catch (failure) {
  //       yield MessagesLoadFailed(failure);
  //     }
  //   }
  // }

  Stream<MessagesState> handleMoreMessagesFetchedEvent(MoreMessagesFetched event) async* {
    //yield MoreMessagesLoading();
    // if (!await Functions.getNetworkStatus()) {
    //   yield MoreMessagesFailed(NetworkException());
    // } else {
    //   try {
    //     final nextMessages = await storageRepository.fetchNextMessages(
    //       userId: userId,
    //       friendId: friendId,
    //       maxLength: moreMessagesLength,
    //       firstMessagesLength: event.messagesLength,
    //     );
    //     allMessages.addAll(nextMessages);
    //
    //     if (nextMessages.length < moreMessagesLength) {
    //       yield MessagesLoadSucceed(allMessages, event.scrollposition, true);
    //     } else {
    //       yield MessagesLoadSucceed(allMessages, event.scrollposition, false);
    //     }
    //   } on Failure catch (failure) {
    //     yield MoreMessagesFailed(failure);
    //   }
    // }
  }

  @override
  Future<void> close() {
    //_streamSubscription?.cancel();
    return super.close();
  }
}
