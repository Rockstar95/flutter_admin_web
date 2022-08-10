import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';

abstract class AskTheExpertEvent extends Equatable {
  const AskTheExpertEvent();
}

class GetUserQuestionsListEvent extends AskTheExpertEvent {
  final int componentInsID;
  final int componentID;
  final String sortBy;
  final int intSkillID;
  final int pageIndex;
  final int pageSize;
  final String searchText;

  const GetUserQuestionsListEvent(
      {this.componentInsID = 0,
      this.componentID = 0,
      this.sortBy = "",
      this.intSkillID = 0,
      this.pageIndex = 0,
      this.pageSize = 0,
      this.searchText = ""});

  @override
  List<Object> get props => [
        componentInsID,
        componentID,
        sortBy,
        intSkillID,
        pageIndex,
        pageSize,
        searchText
      ];
}

class OpenFileExplorerTopicEvent extends AskTheExpertEvent {
  final FileType pickingType;

  const OpenFileExplorerTopicEvent(this.pickingType);

  @override
  // TODO: implement props
  List<Object> get props => [pickingType];
}

class AddQuestionEvent extends AskTheExpertEvent {
  final String userEmail;
  final String userName;
  final int questionTypeID;
  final String userQuestion;
  final String userQuestionDesc;
  final String useruploadedImageName;
  final String filePath;
  final String fileName;
  final String skills;
  final String seletedSkillIds;
  final int editQueID;
  final bool isRemoveEditimage;

  AddQuestionEvent(
      this.userEmail,
      this.userName,
      this.questionTypeID,
      this.userQuestion,
      this.userQuestionDesc,
      this.useruploadedImageName,
      this.filePath,
      this.fileName,
      this.skills,
      this.seletedSkillIds,
      this.editQueID,
      this.isRemoveEditimage);

  @override
  // TODO: implement props
  List<Object> get props => [
        userEmail,
        userName,
        questionTypeID,
        userQuestion,
        userQuestionDesc,
        useruploadedImageName,
        filePath,
        fileName,
        skills,
        seletedSkillIds,
        editQueID,
        isRemoveEditimage
      ];
}

class AnswersListEvent extends AskTheExpertEvent {
  final int componentInsID;
  final int componentID;
  final int intQuestionID;

  AnswersListEvent(this.componentInsID, this.componentID, this.intQuestionID);

  @override
  // TODO: implement props
  List<Object> get props => [componentInsID, componentID, intQuestionID];
}

class UpAndDownVoteEvent extends AskTheExpertEvent {
  final String strObjectID;
  final int intTypeID;
  final bool blnIsLiked;

  UpAndDownVoteEvent(this.strObjectID, this.intTypeID, this.blnIsLiked);

  @override
  // TODO: implement props
  List<Object> get props => [strObjectID, intTypeID, blnIsLiked];
}

class AddAnswerCommentEvent extends AskTheExpertEvent {
  final int questionID;
  final int responseID;
  final String commentID;
  final String comment;
  final String userCommentImage;
  final int commentStatus;
  final bool isRemoveCommentImage;
  final String filePath;
  final String fileName;

  AddAnswerCommentEvent(
      this.questionID,
      this.responseID,
      this.commentID,
      this.comment,
      this.userCommentImage,
      this.commentStatus,
      this.isRemoveCommentImage,
      this.filePath,
      this.fileName);

  @override
  // TODO: implement props
  List<Object> get props => [
        questionID,
        responseID,
        commentID,
        comment,
        userCommentImage,
        commentStatus,
        isRemoveCommentImage,
        filePath,
        fileName
      ];
}

class GetFilterMenus extends AskTheExpertEvent {
  final LocalStr localStr;
  final List<NativeMenuModel> listNativeModel;
  final String moduleName;

  GetFilterMenus(
      {required this.listNativeModel,
      required this.localStr,
      this.moduleName = ""});

  @override
  List<Object> get props => [listNativeModel, localStr, moduleName];
}

class GetSkillCategoryEvent extends AskTheExpertEvent {
  GetSkillCategoryEvent();

  @override
  List<Object> get props => [];
}

class SelectCategoriesEvent extends AskTheExpertEvent {
  final String seletedCategoryID;

  SelectCategoriesEvent({this.seletedCategoryID = ""});

  @override
  List<Object> get props => [
        seletedCategoryID,
      ];
}

class ViewCommentEvent extends AskTheExpertEvent {
  final int commentID;
  final int responseID;

  ViewCommentEvent({this.commentID = 0, this.responseID = 0});

  @override
  List<Object> get props => [commentID, responseID];
}

class LikeDisLikeEvent extends AskTheExpertEvent {
  final String strObjectID;
  final int intTypeID;
  final bool blnIsLiked;

  LikeDisLikeEvent({
    this.strObjectID = "",
    this.intTypeID = 0,
    this.blnIsLiked = false,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        strObjectID,
        intTypeID,
        blnIsLiked,
      ];
}

class DeleteCommentEvent extends AskTheExpertEvent {
  final int commentId;

  DeleteCommentEvent({
    this.commentId = 0,
  });

  @override
  // TODO: implement props
  List<Object> get props => [commentId];
}

class DeleteQuestionEvent extends AskTheExpertEvent {
  final int questionID;
  final String userUploadImage;

  DeleteQuestionEvent({
    this.questionID = 0,
    this.userUploadImage = "",
  });

  @override
  // TODO: implement props
  List<Object> get props => [questionID, userUploadImage];
}

class ViewQuestionEvent extends AskTheExpertEvent {
  final int questionID;

  ViewQuestionEvent({
    this.questionID = 0,
  });

  @override
  // TODO: implement props
  List<Object> get props => [questionID];
}

class AddAnswerEvent extends AskTheExpertEvent {
  final String userEmail;
  final String userName;
  final String response;
  final String userResponseImageName;
  final int responseID;
  final int questionID;
  final bool isRemoveEditImage;
  final String filePath;
  final String fileName;

  AddAnswerEvent(
      {this.userEmail = "",
      this.userName = "",
      this.response = "",
      this.userResponseImageName = "",
      this.responseID = 0,
      this.questionID = 0,
      this.isRemoveEditImage = false,
      this.filePath = "",
      this.fileName = ""});

  @override
  // TODO: implement props
  List<Object> get props => [
        userEmail,
        userName,
        response,
        userResponseImageName,
        responseID,
        questionID,
        isRemoveEditImage,
        filePath,
        fileName
      ];
}

class DeleteUserResponseEvent extends AskTheExpertEvent {
  final int responseId;
  final String userResponseImage;

  DeleteUserResponseEvent({
    this.responseId = 0,
    this.userResponseImage = "",
  });

  @override
  // TODO: implement props
  List<Object> get props => [responseId, userResponseImage];
}
