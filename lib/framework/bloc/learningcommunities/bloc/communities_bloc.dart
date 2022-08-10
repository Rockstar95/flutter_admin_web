import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/event/communities_event.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/model/learningcommunitiesresponse.dart';
import 'package:flutter_admin_web/framework/bloc/learningcommunities/state/communities_state.dart';
import 'package:flutter_admin_web/framework/repository/learningcommunities/communities_repositry_builder.dart';
import 'package:flutter_admin_web/utils/my_print.dart';

class CommunitiesBloc extends Bloc<CommunitiesEvent, CommunitiesState> {
  bool isFirstLoading = true;

  LearningCommunitiesResponse learningCommunitiesresponse =
      LearningCommunitiesResponse(portalListing: [], table: []);

  CommunitiesRepository communitiesRepository;

  CommunitiesBloc({required this.communitiesRepository})
      : super(CommunitiesState.completed(null)) {
    on<GetLearningCommunitiesEvent>(onEventHandler);
    on<LoginorGotoSubsiteEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(CommunitiesEvent event, Emitter emit) async {
    print("CommunitiesBloc onEventHandler called for ${event.runtimeType}");
    Stream<CommunitiesState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (CommunitiesState authState) {
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
  CommunitiesState get initialState =>
      IntitialCommunitiesState.completed('data');

  @override
  Stream<CommunitiesState> mapEventToState(CommunitiesEvent event) async* {
    try {
      if (event is GetLearningCommunitiesEvent) {
        yield GetCommunitiesResponseState.loading('Please wait');
        Response? apiResponse = await communitiesRepository.getLearningCommunitiesResponseRepo(
          nativeMenuModel: event.nativeMenuModel,
        );

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          LearningCommunitiesResponse templearningCommunitiesresponse = communitiesResponseFromJson(apiResponse?.body ?? "{}");
          learningCommunitiesresponse = templearningCommunitiesresponse;
          yield GetCommunitiesResponseState.completed(learningCommunitiesresponse: learningCommunitiesresponse);
        }
        else if (apiResponse?.statusCode == 401) {
          yield GetCommunitiesResponseState.error('401');
        }
        else {
          yield GetCommunitiesResponseState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is LoginorGotoSubsiteEvent) {
        yield LoginorGotoSubsiteState.loading('Loading...please wait');

        Response? response = await communitiesRepository.doSubSiteLogin(
          event.email,
          event.password,
          event.portallisting.learnerSiteURL,
          'true',
          event.portallisting.siteID.toString(),
        );

        if (response?.statusCode == 200) {
          print(response?.body);
          yield LoginorGotoSubsiteState.completed(response: response?.body ?? "{}", portalListing: event.portallisting);
        }
        else if (response?.statusCode == 401) {
          yield LoginorGotoSubsiteState.error("401");
        }
        else {
          yield LoginorGotoSubsiteState.error("Error");
        }
      }
    }
    catch (e, s) {
      print("Error in CommunitiesBloc.mapEventToState():$e");
      MyPrint.printOnConsole(s);
      isFirstLoading = false;
      yield LoginorGotoSubsiteState.error("Error  $e");
    }
  }
}
