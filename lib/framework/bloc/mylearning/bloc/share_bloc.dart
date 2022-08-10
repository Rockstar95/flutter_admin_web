import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/share_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/connection_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/share_state.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/contract/mylearning_repositry.dart';

class ShareBloc extends Bloc<ShareEVent, ShareState> {
  MyLearningRepository myLearningRepository;

  List<ConnectionElement> connectionlist = [];
  List<ConnectionElement> mainconnectionlist = [];
  List<String> selectedconnectionlist = [];

  ShareBloc({
    required this.myLearningRepository,
  }) : super(ShareState.completed(null)) {
    on<GetConnectionListEvent>(onEventHandler);
    on<SelectConnectionEvent>(onEventHandler);
    on<SendMailToPeopleEvent>(onEventHandler);
    on<SendviaMailInmylearn>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ShareEVent event, Emitter emit) async {
    print("ShareBloc onEventHandler called for ${event.runtimeType}");
    Stream<ShareState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ShareState authState) {
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
  ShareState get initialState => IntitialShareStateState.completed("data");

  @override
  Stream<ShareState> mapEventToState(event) async* {
    try {
      if (event is GetConnectionListEvent) {
        yield GetConnectiontListState.loading("Loading Data...");
        if (event.searchTxt.length == 0) {
          connectionlist.clear();
          mainconnectionlist.clear();
          selectedconnectionlist.clear();
          Response? response =
              await myLearningRepository.getMyConnectionListForShareContent(
                  event.searchTxt);

          print(
              "GetMyconnectionListForShareContent statusCode ${response?.statusCode}");
          print("GetMyconnectionListForShareContent ${response.toString()}");

          if (response?.statusCode == 200) {
            ConnectionResponse connectionResponse =
                connectionResponseFromJson(response?.body ?? "{}");
            mainconnectionlist = connectionResponse.table;
            print(
                "GetMyconnectionListForShareContent ${connectionResponse.table.length}");
            connectionlist = connectionResponse.table;

            yield GetConnectiontListState.completed(list: connectionlist);
            yield GetConnectiontListState.completed(list: mainconnectionlist);
          } else {
            yield GetConnectiontListState.error(
                response?.statusCode.toString());
          }
        } else {
          connectionlist = mainconnectionlist
              .where((food) => food.userName
                  .toLowerCase()
                  .contains(event.searchTxt.toLowerCase()))
              .toList();

          /*  mainconnectionlist.forEach((element) {
            print("om ${element.userName} --- ${event.searchTxt}");
            if(element.userName.toLowerCase().startsWith(event.searchTxt.toLowerCase())){
              connectionlist.add(element);
            }
          });*/
          yield GetConnectiontListState.completed(list: connectionlist);
        }
      }
      else if (event is SelectConnectionEvent) {
        if (!selectedconnectionlist.contains(event.seletedEmail)) {
          selectedconnectionlist.add(event.seletedEmail);
        } else {
          selectedconnectionlist.remove(event.seletedEmail);
        }

        yield SelectConnectiontState.completed(list: selectedconnectionlist);
      }
      else if (event is SendMailToPeopleEvent) {
        yield SendMailToPeopleState.loading("Loading Data...");
        connectionlist.clear();
        Response? response = await myLearningRepository.sendMailToPeople(
            event.toEmail,
            event.subject,
            event.message,
            event.emailList,
            event.isPeople,
            event.isFromForm,
            event.isFromQuestion,
            event.contentid);

        print("SendMailToPeopleEvent statusCode ${response?.statusCode}");
        print("SendMailToPeopleEvent ${response?.body}");

        if (response?.statusCode == 200) {
          yield SendMailToPeopleState.completed(isSucces: true);
        } else {
          yield SendMailToPeopleState.error(response?.statusCode.toString());
        }
      }
      else if (event is SendviaMailInmylearn) {
        try {
          yield SendviaMailToMyLearn.loading("Loading Data...");
          connectionlist.clear();
          Response? response = await myLearningRepository.sendViaEmailMyLearn(
              event.UserMails,
              event.Subject,
              event.Message,
              event.isattachDocument,
              event.Contentid);

          print("SendviaMail statusCode ${response?.statusCode}");
          print("SendviaMail ${response.toString()}");

          if (response?.statusCode == 200) {
            yield SendviaMailToMyLearn.completed(isSucces: true);
          } else {
            yield SendviaMailToMyLearn.error(response?.statusCode.toString());
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e, s) {
      print("Error in ShareBloc.mapEventToState():$e");
      print(s);
    }
  }
}
