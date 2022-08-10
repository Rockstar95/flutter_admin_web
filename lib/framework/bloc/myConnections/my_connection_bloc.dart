import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/connection_dynamic_tab_response.dart';
import 'package:flutter_admin_web/framework/bloc/myConnections/model/people_list_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/repository/myConnections/myConnection_repository_builder.dart';

part 'my_connection_event.dart';
part 'my_connection_state.dart';

class MyConnectionBloc extends Bloc<MyConnectionEvent, MyConnectionState> {
  MyConnectionRepository myConnectionRepository;

  bool isFirstLoading = true;
  bool showLoader = true;
  bool isAddLoading = true;

  bool isArchiveFirstLoading = true;
  String searchString = "";

  int pageIndex = 1;
  bool hasMoreUsers = true, isLoadingUsers = false;
  int peopleCount = 0;
  List<PeopleModel> allConnectionList = [];
  List<ConnectionDynamicTab> dynamicTabList = [];

  MyConnectionBloc({required this.myConnectionRepository})
      : super(MyConnectionState.completed(null)) {
    on<GetDynamicTabsEvent>(onEventHandler);
    on<GetPeopleListEvent>(onEventHandler);
    on<AddConnectionEvent>(onEventHandler);
    on<RemoveConnectionEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MyConnectionEvent event, Emitter emit) async {
    print("MyConnectionBloc onEventHandler called for ${event.runtimeType}");
    Stream<MyConnectionState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MyConnectionState authState) {
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
  MyConnectionState get initialState => MyConnectionState.completed('data');

  @override
  Stream<MyConnectionState> mapEventToState(MyConnectionEvent event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is GetDynamicTabsEvent) {
        yield GetDynamicTabsState.loading('Please wait');
        Response? apiResponse =
            await myConnectionRepository.getDynamicTabEvent();
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          var jsonArray =
              new List<dynamic>.from(jsonDecode(apiResponse?.body ?? "[]"));
          dynamicTabList = jsonArray.map((e) => new ConnectionDynamicTab.fromJson(e)).toList();
          dynamicTabList.sort((a,b) => a.mobileDisplayName.compareTo(b.mobileDisplayName));
          print("REsponse:${apiResponse?.body.toString() ?? ""}");
          yield GetDynamicTabsState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield GetDynamicTabsState.error('401');
        } else {
          yield GetDynamicTabsState.error('Something went wrong');
        }
      }

      if (event is GetPeopleListEvent) {
        yield MyConnectionState.loading('Please wait');
        showLoader = true;

        print("GetPeopleListEvent isRefresh:${event.isRefresh}");
        if(event.isRefresh) {
          pageIndex = 1;
          hasMoreUsers = true;
          isFirstLoading = true;
          showLoader = true;
          this.allConnectionList.clear();
        }
        isLoadingUsers = true;

        Response? apiResponse = await myConnectionRepository.getPeopleListResponseEvent(
          componentID: event.componentID,
          componentInstanceID: event.componentInstanceID,
          pageIndex: pageIndex,
          pageSize: apiCallPageSize,
          filterType: event.filterType,
          tabID: "",
          //event.tabID,
          searchText: event.searchText,
          contentId: event.contentid,
          location: "",
          //event.location,
          company: "",
          //event.company,
          skillLevels: "",
          //event.skilllevels,
          firstname: "",
          //event.firstname,
          lastname: "",
          //event.lastname,
          skillCats: "",
          //event.skillcats,
          skills: "",
          //event.skills,
          jobRoles: "",
        ); //event.jobroles);

        isLoadingUsers = false;
        pageIndex++;

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          showLoader = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          PeopleListResponse response = PeopleListResponse.fromJson(Map.castFrom(valueMap));
          this.peopleCount = response.peopleCount;
          this.allConnectionList.addAll(response.peopleList);
          print("List Length:${response.peopleList.length}");
          /*
          final ids = this.allConnectionList.map((e) => e.objectId).toSet();
          List<PeopleModel> tempList = [];
          for (var id in ids) {
            tempList.add(this
                .allConnectionList
                .firstWhere((element) => element.objectId == id));
          }
          this.allConnectionList += tempList;
          print("asdasd" + ids.toString());
          */

          hasMoreUsers = response.peopleList.length == apiCallPageSize;

          yield MyConnectionState.completed(response);
        }
        else if (apiResponse?.statusCode == 401) {
          yield MyConnectionState.error('401');
          hasMoreUsers = false;
        }
        else {
          yield MyConnectionState.error('Something went wrong');
          hasMoreUsers = false;
        }
      }

      if (event is AddConnectionEvent) {
        yield AddConnectionState.loading('Please wait');
        showLoader = true;
        Response? apiResponse = await myConnectionRepository.addConnectionResponseEvent(
          selectedObjectID: event.selectedObjectID,
          selectAction: event.selectAction,
          userName: event.userName,
        );
        print("AddConnectionResponse Status:${apiResponse?.statusCode}, Body:${apiResponse?.body}");

        if (apiResponse?.statusCode == 200) {
          isAddLoading = false;
          showLoader = false;
          print("AddConnectionEvent Response:${apiResponse?.body.toString() ?? "{}"}");
          yield AddConnectionState.completed(message: jsonDecode(apiResponse?.body ?? "{}")['Message'] ?? "");
        }
        else if (apiResponse?.statusCode == 401) {
          yield AddConnectionState.error('401');
        }
        else {
          yield AddConnectionState.error('Something went wrong');
        }
      }
    } catch (e) {
      print("Error in MyConnectionBloc.mapEventToState():$e");
      isFirstLoading = false;
      showLoader = false;
    }
  }
}
