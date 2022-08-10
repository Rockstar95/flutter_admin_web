import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/event/my_competencies_event.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/job_role_skills_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/pref_category_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/model/user_skill_list_response.dart';
import 'package:flutter_admin_web/framework/bloc/competencies/state/my_competencies_state.dart';
import 'package:flutter_admin_web/framework/repository/competencies/my_competencies_repositry_builder.dart';

class MyCompetenciesBloc
    extends Bloc<MyCompetenciesEvent, MyCompetenciesState> {
  String type = "";
  bool isFirstLoading = false;
  JobRoleSkillsResponse jobRoleSkillsResponse =
      JobRoleSkillsResponse.fromJson({});
  PrefCategoryListResponse prefCategoryListResponse =
      PrefCategoryListResponse.fromJson({});
  UserSkillListResponse userSkillListResponse =
      UserSkillListResponse.fromJson({});
  JobRoleResponse jobRoleResponse = JobRoleResponse.fromJson({});
  MyCompetenciesRepository myCompetenciesRepository;

  MyCompetenciesBloc({required this.myCompetenciesRepository})
      : super(MyCompetenciesState.completed(null)) {
    on<JobRoleSkillsEvent>(onEventHandler);
    on<PrefCatListEvent>(onEventHandler);
    on<UserSkillsEvent>(onEventHandler);
    on<UserSkillsEvaluationEvent>(onEventHandler);
    on<GetJobRoleEvent>(onEventHandler);
    on<AddJobRoleEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(MyCompetenciesEvent event, Emitter emit) async {
    print("MyCompetenciesBloc onEventHandler called for ${event.runtimeType}");
    Stream<MyCompetenciesState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (MyCompetenciesState authState) {
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
  MyCompetenciesState get initialState => MyCompetenciesState.completed('data');

  @override
  Stream<MyCompetenciesState> mapEventToState(
      MyCompetenciesEvent event) async* {
    try {
      if (event is JobRoleSkillsEvent) {
        isFirstLoading = true;
        yield JobRoleSkillsState.loading('Please wait');
        Response? apiResponse = await myCompetenciesRepository.jobRolSkills(
            componentID: event.componentID,
            componentInstanceID: event.componentInstanceID,
            jobRoleID: event.jobRoleID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          jobRoleSkillsResponse =
              jobRoleSkillsResponseFromJson(apiResponse?.body ?? "{}");
          yield JobRoleSkillsState.completed();
        } else if (apiResponse?.statusCode == 401) {
          JobRoleSkillsState.error('401');
        } else {
          JobRoleSkillsState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is PrefCatListEvent) {
        isFirstLoading = true;
        yield PrefCatListState.loading('Please wait');
        Response? apiResponse = await myCompetenciesRepository.prefCatList(
            componentID: event.componentID,
            componentInstanceID: event.componentInstanceID,
            jobRoleID: event.jobRoleID);
        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;
          prefCategoryListResponse =
              prefCategoryListResponseFromJson(apiResponse?.body ?? "{}");
          yield PrefCatListState.completed();
        } else if (apiResponse?.statusCode == 401) {
          PrefCatListState.error('401');
        } else {
          PrefCatListState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      } else if (event is UserSkillsEvent) {
        isFirstLoading = true;
        yield UserSkillState.loading('Please wait');
        Response? apiResponse = await myCompetenciesRepository.userSkills(
            componentID: event.componentID,
            componentInstanceID: event.componentInstanceID,
            prefCatId: event.prefCatId,
            jobRoleID: event.jobRoleID);
        if (apiResponse?.statusCode == 200) {
          userSkillListResponse =
              userSkillListResponseFromJson(apiResponse?.body ?? "{}");
          yield UserSkillState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield UserSkillState.error('401');
        } else {
          yield UserSkillState.error('Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      } else if (event is UserSkillsEvaluationEvent) {
        isFirstLoading = true;
        yield UserSkillEvaluationState.loading('Please wait');
        Response? apiResponse =
            await myCompetenciesRepository.updateUserEvaluation(
                componentID: event.componentID,
                componentInsID: event.componentInsID,
                jobRoleID: event.jobRoleID,
                prefCategoryID: event.prefCategoryID,
                skillSetValue: event.skillSetValue);
        if (apiResponse?.statusCode == 200) {
          yield UserSkillEvaluationState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield UserSkillEvaluationState.error('401');
        } else {
          yield UserSkillEvaluationState.error('Something went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      } else if (event is GetJobRoleEvent) {
        yield JobRoleState.loading('Please wait');
        Response? apiResponse = await myCompetenciesRepository.getJobRoleData(
            componentID: event.componentID,
            componentInstanceID: event.componentInsID,
            isParent: event.isParent);
        if (apiResponse?.statusCode == 200) {
          jobRoleResponse = jobRoleResponseFromJson(apiResponse?.body ?? "{}");
          yield JobRoleState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield JobRoleState.error('401');
        } else {
          yield JobRoleState.error('Somthing went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      } else if (event is AddJobRoleEvent) {
        isFirstLoading = true;
        yield AddJobRoleState.loading('Please wait');
        Response? apiResponse = await myCompetenciesRepository.addJobRole(
            jobRoleIDs: event.jobRoleId, tagName: event.tagName);
        if (apiResponse?.statusCode == 200) {
          yield AddJobRoleState.completed();
        } else if (apiResponse?.statusCode == 401) {
          yield AddJobRoleState.error('401');
        } else {
          yield AddJobRoleState.error('Somthing went wrong');
        }
        print('apiResponse ${apiResponse?.body}');
      }
    } catch (e) {
      print("Error in MyCompetenciesBloc.mapEventToState():$e");

      isFirstLoading = false;
    }
  }
}
