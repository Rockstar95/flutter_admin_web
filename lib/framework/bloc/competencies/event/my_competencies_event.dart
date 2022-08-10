import 'package:equatable/equatable.dart';

abstract class MyCompetenciesEvent extends Equatable {
  const MyCompetenciesEvent();
}

class JobRoleSkillsEvent extends MyCompetenciesEvent {
  final int componentID;
  final int componentInstanceID;
  final int jobRoleID;

  JobRoleSkillsEvent(
      {this.componentID = 0, this.componentInstanceID = 0, this.jobRoleID = 0});

  @override
  List<Object> get props => [componentID, componentInstanceID, jobRoleID];
}

class PrefCatListEvent extends MyCompetenciesEvent {
  final int componentID;
  final int componentInstanceID;
  final int jobRoleID;

  PrefCatListEvent(
      {this.componentID = 0, this.componentInstanceID = 0, this.jobRoleID = 0});

  @override
  List<Object> get props => [componentID, componentInstanceID, jobRoleID];
}

class UserSkillsEvent extends MyCompetenciesEvent {
  final int componentID;
  final int componentInstanceID;
  final int prefCatId;
  final int jobRoleID;

  UserSkillsEvent({
    this.componentID = 0,
    this.componentInstanceID = 0,
    this.prefCatId = 0,
    this.jobRoleID = 0,
  });

  @override
  List<Object> get props =>
      [componentID, componentInstanceID, prefCatId, jobRoleID];
}

class UserSkillsEvaluationEvent extends MyCompetenciesEvent {
  final int componentID;
  final int componentInsID;
  final int jobRoleID;
  final int prefCategoryID;
  final String skillSetValue;

  UserSkillsEvaluationEvent(
      {this.componentID = 0,
      this.componentInsID = 0,
      this.jobRoleID = 0,
      this.prefCategoryID = 0,
      this.skillSetValue = ""});

  @override
  List<Object> get props =>
      [componentID, componentInsID, jobRoleID, prefCategoryID, skillSetValue];
}

class GetJobRoleEvent extends MyCompetenciesEvent {
  final int componentID;
  final int componentInsID;
  final bool isParent;

  GetJobRoleEvent({
    this.componentID = 0,
    this.componentInsID = 0,
    this.isParent = false,
  });

  @override
  List<Object> get props => [componentID, componentInsID, isParent];
}

class AddJobRoleEvent extends MyCompetenciesEvent {
  final int jobRoleId;
  final String tagName;

  AddJobRoleEvent({
    this.jobRoleId = 0,
    this.tagName = "",
  });

  @override
  List<Object> get props => [jobRoleId, tagName];
}
