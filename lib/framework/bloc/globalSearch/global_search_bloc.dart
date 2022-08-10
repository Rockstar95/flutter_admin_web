import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_component_response.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_result_response.dart';
import 'package:flutter_admin_web/framework/repository/globalSearch/globalSearch_repository_builder.dart';

import 'global_search_event.dart';
import 'global_search_state.dart';

class GlobalSearchBloc extends Bloc<GlobalSearchEvent, GlobalSearchState> {
  GlobalSearchRepository globalSearchRepository;

  bool isFirstLoading = true;
  String searchString = "";

  //Map<String, List<SearchComponent>> searchComponents;
  List<SearchResultModel> searchResultList = [];
  bool clearSearchResult = false;

  // ignore: close_sinks
  //static final GlobalSearchBloc _instance = GlobalSearchBloc(globalSearchRepository: globalSearchRepository);

  //static GlobalSearchBloc get instance => _instance;

  Map<String, List<SearchComponent>> _searchComponents = {};

  Map<String, List<SearchComponent>> get searchComponents => _searchComponents;

  GlobalSearchBloc({required this.globalSearchRepository})
      : super(GlobalSearchState.completed(null)) {
    on<GetSearchComponentListEvent>(onEventHandler);
    on<GetGlobalSearchResultsEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(GlobalSearchEvent event, Emitter emit) async {
    print("GlobalSearchBloc onEventHandler called for ${event.runtimeType}");
    Stream<GlobalSearchState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (GlobalSearchState authState) {
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
  GlobalSearchState get initialState => GlobalSearchState.completed('data');

  @override
  Stream<GlobalSearchState> mapEventToState(GlobalSearchEvent event) async* {
    try {
      if (event is GetSearchComponentListEvent) {
        yield GetSearchComponentState.loading('Please wait');
        isFirstLoading = true;

        Response? apiResponse = await globalSearchRepository.getSearchComponentListEvent();

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          log("GetSearchComponentListEvent Response:$valueMap");

          SearchComponentResponse response = SearchComponentResponse.fromJson(Map.castFrom(valueMap));
          var groupList = <String, List<SearchComponent>>{};
          for (var element in response.searchComponents) {
            element.check = true;
            (groupList[element.siteName] ??= []).add(element);
          }
          print("Check groupList" + groupList.toString());
          this.setSearchComponents(groupList); //= groupList;
          yield GetSearchComponentState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetSearchComponentState.error('401');
        }
        else {
          yield GetSearchComponentState.error('Something went wrong');
        }
      }

      if (event is GetGlobalSearchResultsEvent) {
        yield GetGlobalSearchResultsState.loading('Please wait');
        isFirstLoading = true;
        Response? apiResponse = await globalSearchRepository.getGlobalSearchResultsEvent(
          fType: event.fType,
          fValue: event.fValue,
          pageIndex: event.pageIndex,
          searchStr: event.searchStr,
          componentId: event.componentID,
          componentInsId: event.componentInsID,
          objComponentList: event.objComponentList,
          componentSiteID: event.searchComponent.siteId,
        );

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          Map valueMap = json.decode(apiResponse?.body ?? "{}");
          log("GetGlobalSearchResultsEvent Response:$valueMap");
          SearchResultResponse response = SearchResultResponse.fromJson(Map.castFrom(valueMap));
          if (response.courseList.length > 0) {
            if (response.courseList.length > 3) {
              searchResultList.add(SearchResultModel(
                  searchComponent: event.searchComponent,
                  courseList: response.courseList.sublist(0, 3)));
            }
            else {
              searchResultList.add(SearchResultModel(
                  searchComponent: event.searchComponent,
                  courseList: response.courseList));
            }
          }

          print("searchResultList Count " + searchResultList.map((e) => e.searchComponent.displayName).toString());
          print("Menu Id" + event.searchComponent.displayName);
          print("Response" + response.courseCount.toString());
          yield GetGlobalSearchResultsState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetGlobalSearchResultsState.error('401');
        }
        else {
          yield GetGlobalSearchResultsState.error('Something went wrong');
        }
      }
    } catch (e, s) {
      print("Error in GlobalSearchBloc.mapEventToState():$e");
      print(s);

      isFirstLoading = false;
    }
  }

  void setSearchComponents(Map<String, List<SearchComponent>> value) {
    _searchComponents = value;
  }
}

class SearchResultModel {
  SearchComponent searchComponent;
  List<CourseList> courseList = [];

  SearchResultModel({required this.searchComponent, required this.courseList});
}
