import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/review_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/review_state.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/contract/mylearning_repositry.dart';

class ReviewBloc extends Bloc<ReviewEVent, ReviewState> {
  MyLearningRepository myLearningRepository;

  ReviewBloc({
    required this.myLearningRepository,
  }) : super(ReviewState.completed(null)) {
    on<GetCurrentUserReviewEvent>(onEventHandler);
    on<AddUserReviewEvent>(onEventHandler);
    on<DeleteReviewEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ReviewEVent event, Emitter emit) async {
    print("ReviewBloc onEventHandler called for ${event.runtimeType}");
    Stream<ReviewState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ReviewState authState) {
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
  ReviewState get initialState => IntitialReviewState.completed("Intitalized");

  @override
  Stream<ReviewState> mapEventToState(event) async* {
    try {
      if (event is GetCurrentUserReviewEvent) {
        print("Enter GetCurrentUserReviewEvent");
        yield GetCurrentUserReviewState.loading('Loading...please wait');
        try {
          Response? response = await myLearningRepository
              .getUserRatingsOfTheContent(event.contentId, event.skippedRows);

          print("GetCurrentUserReviewEvent response :- ${response.toString()}");
          print(
              "GetCurrentUserReviewEvent responseCode :- ${response?.statusCode}");

          if (response?.statusCode == 200) {
            GetReviewResponse getReviewResponse =
                getReviewResponseFromJson(response?.body ?? "{}");
            yield GetCurrentUserReviewState.completed(
              review: getReviewResponse,
            );
          } else {
            print("object bloc else part ${response?.statusCode} ");
            yield GetCurrentUserReviewState.error("${response?.statusCode}");
          }
        } catch (e, s) {
          print("log $e");
          print(s);
          yield GetCurrentUserReviewState.error("Error  $e");
        }
      } else if (event is AddUserReviewEvent) {
        print("Enter AddUserReviewEvent");
        yield AddReviewState.loading('Loading...please wait');
        try {
          Response? response =
              await myLearningRepository.addRatingsOfTheContent(
                  event.contentId, event.strReview, event.strRating);

          print("AddUserReviewEvent response :- ${response.toString()}");
          print("AddUserReviewEvent responseCode :- ${response?.statusCode}");

          if (response?.statusCode == 204) {
            if (response.toString() != null) {
              yield AddReviewState.completed(isAdded: "Review Updated");
            } else {
              yield AddReviewState.error("Server Error");
            }
          } else {
            print("object bloc else part ${response?.statusCode} ");
            yield AddReviewState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("log $e");
          yield AddReviewState.error("Error  $e");
        }
      } else if (event is DeleteReviewEvent) {
        print("Enter DeleteReviewEvent");
        yield AddReviewState.loading('Loading...please wait');
        try {
          Response? response = await myLearningRepository
              .deleteRatingsOfTheContent(event.contentId);

          print("DeleteReviewEvent response :- ${response.toString()}");
          print("DeleteReviewEvent responseCode :- ${response?.statusCode}");

          if (response?.statusCode == 200) {
            if (response.toString() != null) {
              yield AddReviewState.completed(isAdded: "Review Deleted");
            } else {
              yield AddReviewState.error("Server Error");
            }
          } else {
            print("object bloc else part ${response?.statusCode} ");
            yield AddReviewState.error("${response?.statusCode}");
          }
        } catch (e) {
          print("log $e");
          yield AddReviewState.error("Error  $e");
        }
      }
    } catch (e) {
      print("Error in ReviewBloc.mapEventToState():$e");
    }
  }
}
