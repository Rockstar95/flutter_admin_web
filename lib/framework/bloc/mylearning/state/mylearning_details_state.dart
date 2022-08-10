import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';
import 'package:flutter_admin_web/framework/repository/general/model/content_status_response.dart';

class MyLearningDetailsState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  MyLearningDetailsState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  MyLearningDetailsState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  MyLearningDetailsState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialDetailsState extends MyLearningDetailsState {
  IntitialDetailsState.completed(data) : super.completed(data);
}

class GetLearningDetailsState extends MyLearningDetailsState {
  MyLearningDetailsResponse data =
      MyLearningDetailsResponse(recordingDetails: RecordingDetails());

  GetLearningDetailsState.loading(data) : super.loading(data);

  GetLearningDetailsState.completed({required this.data})
      : super.completed(data);

  GetLearningDetailsState.error(data) : super.error(data);
}

class GetReviewsDetailstate extends MyLearningDetailsState {
  GetReviewResponse review = GetReviewResponse(userRatingDetails: []);

  GetReviewsDetailstate.loading(data) : super.loading(data);

  GetReviewsDetailstate.completed({required this.review})
      : super.completed(review);

  GetReviewsDetailstate.error(data) : super.error(data);
}

class SetCompleteState extends MyLearningDetailsState {
  bool isCompleted = false;

  SetCompleteState.loading(data) : super.loading(data);

  SetCompleteState.completed({this.isCompleted = false})
      : super.completed(isCompleted);

  SetCompleteState.error(data) : super.error(data);
}

class GetCertificateState extends MyLearningDetailsState {
  String isCompleted = "";

  GetCertificateState.loading(data) : super.loading(data);

  GetCertificateState.completed({this.isCompleted = ""})
      : super.completed(isCompleted);

  GetCertificateState.error(data) : super.error(data);
}

class GetContentStatusState extends MyLearningDetailsState {
  Contentstatus contentstatus = Contentstatus();
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();

  GetContentStatusState.loading(data) : super.loading(data);

  GetContentStatusState.completed(
      {required this.contentstatus, required this.table2})
      : super.completed(contentstatus);

  GetContentStatusState.error(data) : super.error(data);
}
