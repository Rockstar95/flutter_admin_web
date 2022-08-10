import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/add_answer_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/add_question_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/answers_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/skill_category_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/user_questions_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/askTheExpert/model/view_comment_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/filterby_model.dart';
import 'package:flutter_admin_web/framework/common/api_state.dart';

class AskTheExpertState extends ApiState {
  final bool displayMessage;

  /// Pass data to the base API class
  AskTheExpertState.completed(data, {this.displayMessage = true})
      : super.completed(data);

  AskTheExpertState.loading(data, {this.displayMessage = true})
      : super.loading(data);

  AskTheExpertState.error(data, {this.displayMessage = true})
      : super.error(data);

  List<Object> get props => [];
}

class IntitialAskTheExpertState extends AskTheExpertState {
  IntitialAskTheExpertState.completed(data) : super.completed(data);
}

class UserQuestiondsListState extends AskTheExpertState {
  UserQuestiondsListResponse userQuestiondsListResponse;

  UserQuestiondsListState.loading(data,
      {required this.userQuestiondsListResponse})
      : super.loading(data);

  UserQuestiondsListState.completed({required this.userQuestiondsListResponse})
      : super.completed(userQuestiondsListResponse);

  UserQuestiondsListState.error(data,
      {required this.userQuestiondsListResponse})
      : super.error(data);
}

class OpenFileExplorerState extends AskTheExpertState {
  String fileName;

  OpenFileExplorerState.loading(data, {this.fileName = ""})
      : super.loading(data);

  OpenFileExplorerState.completed({this.fileName = ""})
      : super.completed(fileName);

  OpenFileExplorerState.error(data, {this.fileName = ""}) : super.error(data);
}

class AddQuestionState extends AskTheExpertState {
  AddQuestionResponse addQuestionResponse;

  AddQuestionState.loading(data, {required this.addQuestionResponse})
      : super.loading(data);

  AddQuestionState.completed({required this.addQuestionResponse})
      : super.completed(addQuestionResponse);

  AddQuestionState.error(data, {required this.addQuestionResponse})
      : super.error(data);
}

class AnswersListState extends AskTheExpertState {
  AnswersResponse? answersResponse;

  AnswersListState.loading(data, {this.answersResponse}) : super.loading(data);

  AnswersListState.completed({this.answersResponse})
      : super.completed(answersResponse);

  AnswersListState.error(data, {this.answersResponse}) : super.error(data);
}

class UpAndDownVoteState extends AskTheExpertState {
  String data;

  UpAndDownVoteState.loading({this.data = ""}) : super.loading(data);

  UpAndDownVoteState.completed({this.data = ""}) : super.completed(data);

  UpAndDownVoteState.error({this.data = ""}) : super.error(data);
}

class AddAnswerCommentState extends AskTheExpertState {
  String data;

  AddAnswerCommentState.loading({this.data = ""}) : super.loading(data);

  AddAnswerCommentState.completed({this.data = ""}) : super.completed(data);

  AddAnswerCommentState.error({this.data = ""}) : super.error(data);
}

class GetFilterMenusState extends AskTheExpertState {
  Map<String, String> filterMenus;

  GetFilterMenusState.loading(data, {required this.filterMenus})
      : super.loading(data);

  GetFilterMenusState.completed({required this.filterMenus})
      : super.completed(filterMenus);

  GetFilterMenusState.error(data, {required this.filterMenus})
      : super.error(data);
}

class GetSkillCategoryState extends AskTheExpertState {
  SkillCategoryResponse skillCategoryResponse;

  GetSkillCategoryState.loading(data, {required this.skillCategoryResponse})
      : super.loading(data);

  GetSkillCategoryState.completed({required this.skillCategoryResponse})
      : super.completed(skillCategoryResponse);

  GetSkillCategoryState.error(data, {required this.skillCategoryResponse})
      : super.error(data);
}

class GetCategoriesState extends AskTheExpertState {
  List<FilterByModel> filterByList;

  GetCategoriesState.loading(data, {required this.filterByList})
      : super.loading(data);

  GetCategoriesState.completed({required this.filterByList})
      : super.completed(filterByList);

  GetCategoriesState.error(data, {required this.filterByList})
      : super.error(data);
}

class GetCommentsState extends AskTheExpertState {
  ViewCommentResponse viewCommentResponse;

  GetCommentsState.loading(data, {required this.viewCommentResponse})
      : super.loading(data);

  GetCommentsState.completed({required this.viewCommentResponse})
      : super.completed(viewCommentResponse);

  GetCommentsState.error(data, {required this.viewCommentResponse})
      : super.error(data);
}

class LikeDislikeState extends AskTheExpertState {
  String data;

  LikeDislikeState.loading({this.data = ""}) : super.loading(data);

  LikeDislikeState.completed({this.data = ""}) : super.completed(data);

  LikeDislikeState.error({this.data = ""}) : super.error(data);
}

class DeleteCommentState extends AskTheExpertState {
  String data;

  DeleteCommentState.loading({this.data = ""}) : super.loading(data);

  DeleteCommentState.completed({this.data = ""}) : super.completed(data);

  DeleteCommentState.error({this.data = ""}) : super.error(data);
}

class DeleteQuestionState extends AskTheExpertState {
  String data;

  DeleteQuestionState.loading({this.data = ""}) : super.loading(data);

  DeleteQuestionState.completed({this.data = ""}) : super.completed(data);

  DeleteQuestionState.error({this.data = ""}) : super.error(data);
}

class ViewQuestionState extends AskTheExpertState {
  String data;

  ViewQuestionState.loading({this.data = ""}) : super.loading(data);

  ViewQuestionState.completed({this.data = ""}) : super.completed(data);

  ViewQuestionState.error({this.data = ""}) : super.error(data);
}

class AddAnswerState extends AskTheExpertState {
  AddAnswerResponse data;

  AddAnswerState.loading({required this.data}) : super.loading(data);

  AddAnswerState.completed({required this.data}) : super.completed(data);

  AddAnswerState.error({required this.data}) : super.error(data);
}

class DeleteUserResponseState extends AskTheExpertState {
  String data;

  DeleteUserResponseState.loading({this.data = ""}) : super.loading(data);

  DeleteUserResponseState.completed({this.data = ""}) : super.completed(data);

  DeleteUserResponseState.error({this.data = ""}) : super.error(data);
}
