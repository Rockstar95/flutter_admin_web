import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/profile/states/profile_state.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/profile/contract/profile_repository.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/fetchCounries.dart';
import 'package:flutter_admin_web/framework/repository/profile/model/profile_response.dart';
import 'package:flutter_admin_web/ui/common/log_util.dart';
import 'package:intl/intl.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository;

  List<Usereducationdatum> userEducationData = [];
  List<Userexperiencedatum> userExperienceData = [];
  List<ProfileDataField> profiledatafieldname = [];

  List<Datafilelist> userProfileData = [];
  List<Datafilelist> userContactData = [];
  List<Datafilelist> userBackOfficeData = [];

  List<Profilegroup> tempUserProfileData = [];
  List<Profilegroup> tempUserContactData = [];
  List<Profilegroup> tempUserBackOfficeData = [];

  List<ProfileEditList> editUserData = [];
  List<ProfileEditList> editContactData = [];
  List<ProfileEditList> editBackOfficeData = [];

  List<Userprivilege> userprivilige = [];

  bool postprivacyresponse = false;

  String imageUrl = "";
  String countryName = "";

  Map<String, String> profileDataMap = Map<String, String>();

  ProfileHeader profileHeader = ProfileHeader();
  ProfileResponse profileResponse = ProfileResponse();
  CountryResponse countryResponse = CountryResponse(table5: []);

  List<Table5> countryList = [];

  ProfileBloc({
    required this.profileRepository,
  })  : assert(profileRepository != null),
        super(ProfileState.completed(null)) {
    on<GetProfileInfo>(onEventHandler);
    on<GetConnectionsProfile>(onEventHandler);
    on<CreateExperience>(onEventHandler);
    on<RemoveExperience>(onEventHandler);
    on<UpdateExperience>(onEventHandler);
    on<CreateEducation>(onEventHandler);
    on<GetEducationTitle>(onEventHandler);
    on<RemoveEducation>(onEventHandler);
    on<UpdateEducation>(onEventHandler);
    on<UploadImage>(onEventHandler);
    on<UpdateProfile>(onEventHandler);
    on<InitProfile>(onEventHandler);
    on<FetchCountries>(onEventHandler);
    on<ClearTempData>(onEventHandler);
    on<AssignProfileVal>(onEventHandler);
    on<GetProfileHeaderEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(ProfileEvent event, Emitter emit) async {
    print("ProfileBloc onEventHandler called for ${event.runtimeType}");
    Stream<ProfileState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (ProfileState authState) {
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
  ProfileState get initialState => InitProfileState.completed();

  @override
  Stream<ProfileState> mapEventToState(event) async* {
    try {
      if (event is GetProfileInfo) {
        yield GetProfileInfoState.loading('Please wait');
        userprivilige.clear();

        ApiResponse? apiResponse = await profileRepository.getUserInfo();
        print('profileresponse_daata ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data != null) profileResponse = apiResponse!.data;

          userExperienceData = profileResponse.userexperiencedata;
          userEducationData = profileResponse.usereducationdata;
          profiledatafieldname = profileResponse.profiledatafieldname;
//          print('profileresponse_daata ${profileResponse.userprofilegroups}');

          imageUrl = profileResponse.userprofiledetails[0].picture;
          print('profileresponse_daata $imageUrl');
          userprivilige = profileResponse.userprivileges;
          print("Privilege Length 2:${profileResponse.userprivileges.length}");

          await savePrevilige(userprivilige);

          userProfileData.clear();
          userContactData.clear();
          userBackOfficeData.clear();

          tempUserProfileData.clear();
          tempUserContactData.clear();
          tempUserBackOfficeData.clear();

          editUserData.clear();
          editContactData.clear();
          editBackOfficeData.clear();

          mapProfileData(profileResponse.userprofiledetails[0]);
          distributeBlocData(profileResponse);

          yield GetProfileInfoState.completed(profileResponse: profileResponse);
        } else if (apiResponse?.status == 401) {
          yield GetProfileInfoState.error('401');
        } else {
          yield GetProfileInfoState.error('Something went wrong');
        }

//        print('profileSuccess $isSuccess');
      }
      else if (event is GetConnectionsProfile) {
        yield GetProfileInfoState.loading('Please wait');
        userprivilige.clear();

        ApiResponse? apiResponse =
            await profileRepository.getConnectionsProfile(event.userId);

        print('profileresponse_daata ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data != null) profileResponse = apiResponse!.data;
          userExperienceData = profileResponse.userexperiencedata;
          userEducationData = profileResponse.usereducationdata;
          profiledatafieldname = profileResponse.profiledatafieldname;
//          print('profileresponse_daata ${profileResponse.userprofilegroups}');

          imageUrl = profileResponse.userprofiledetails[0].picture;
          print('profileresponse_daata $imageUrl');
          userprivilige = profileResponse.userprivileges;
          await savePrevilige(userprivilige);

          userProfileData.clear();
          userContactData.clear();
          userBackOfficeData.clear();

          tempUserProfileData.clear();
          tempUserContactData.clear();
          tempUserBackOfficeData.clear();

          editUserData.clear();
          editContactData.clear();
          editBackOfficeData.clear();

          mapProfileData(profileResponse.userprofiledetails[0]);
          distributeBlocData(profileResponse);

          yield GetProfileInfoState.completed(profileResponse: profileResponse);
        } else if (apiResponse?.status == 401) {
          yield GetProfileInfoState.error('401');
        } else {
          yield GetProfileInfoState.error('Something went wrong');
        }

//        print('profileSuccess $isSuccess');
      }
      else if (event is CreateExperience) {
        yield CreateExperienceState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .createExperience(event.createExperienceRequest);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield CreateExperienceState.completed(isSuccess: apiResponse?.data);
          } else {
            yield CreateExperienceState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield CreateExperienceState.error('401');
        } else {
          yield CreateExperienceState.error('Something went wrong');
        }
      }
      else if (event is RemoveExperience) {
        yield RemoveExperienceState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .removeExperience(event.removeExperienceRequest);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield RemoveExperienceState.completed(isSuccess: apiResponse?.data);
          } else {
            yield RemoveExperienceState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield RemoveExperienceState.error('401');
        } else {
          yield RemoveExperienceState.error('Something went wrong');
        }
      }
      else if (event is UpdateExperience) {
        yield UpdateExperienceState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .updateExperience(event.updateExperienceRequest);
        print('issuccessval ${apiResponse?.data}');

        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield UpdateExperienceState.completed(isSuccess: apiResponse?.data);
          } else {
            yield UpdateExperienceState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield UpdateExperienceState.error('401');
        } else {
          yield UpdateExperienceState.error('Something went wrong');
        }
      }
      else if (event is GetEducationTitle) {
        yield GetEducationTitleState.loading('Please wait');
        ApiResponse? apiResponse =
            await profileRepository.getEducationTitleList();

        if (apiResponse?.status == 200) {
          yield GetEducationTitleState.completed(
              educationTitleList: apiResponse?.data);
        } else if (apiResponse?.status == 401) {
          yield GetEducationTitleState.error('401');
        } else {
          yield GetEducationTitleState.error('Something went wrong');
        }
      }
      else if (event is CreateEducation) {
        yield CreateEducationState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .createEducation(event.createEducationRequest);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield CreateEducationState.completed(isSuccess: apiResponse?.data);
          } else {
            yield CreateEducationState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield CreateEducationState.error('401');
        } else {
          yield CreateEducationState.error('Something went wrong');
        }
      }
      else if (event is RemoveEducation) {
        yield RemoveEducationState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .removeEducation(event.removeEducationRequest);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield RemoveEducationState.completed(isSuccess: apiResponse?.data);
          } else {
            yield RemoveEducationState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield RemoveEducationState.error('401');
        } else {
          yield RemoveEducationState.error('Something went wrong');
        }
      }
      else if (event is UpdateEducation) {
        yield UpdateEducationState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository
            .updateEducation(event.updateEducationRequest);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data ?? false) {
            this.add(GetProfileInfo());
            yield UpdateEducationState.completed(isSuccess: apiResponse?.data);
          } else {
            yield UpdateEducationState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield UpdateEducationState.error('401');
        } else {
          yield UpdateEducationState.error('Something went wrong');
        }
      }
      else if (event is UploadImage) {
        yield UploadImageState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository.uploadImage(
            event.imageBytes, event.fileName);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield UploadImageState.completed(isSuccess: apiResponse?.data);
          } else {
            yield UploadImageState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield UploadImageState.error('401');
        } else {
          yield UploadImageState.error('Something went wrong');
        }
      }
      else if (event is UpdateProfile) {
        yield UpdateProfileState.loading('Please wait');
        ApiResponse? apiResponse =
            await profileRepository.updateProfile(event.data);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          if (apiResponse?.data) {
            this.add(GetProfileInfo());
            yield UpdateProfileState.completed(isSuccess: apiResponse?.data);
          } else {
            yield UpdateProfileState.error('Something went wrong');
          }
        } else if (apiResponse?.status == 401) {
          yield UpdateProfileState.error('401');
        } else {
          yield UpdateProfileState.error('Something went wrong');
        }
      }
      else if (event is FetchCountries) {
        countryList.clear();
        yield FetchCountriesState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository.fetchCountries();
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          countryResponse = apiResponse?.data;
          for (Table5 table in countryResponse.table5) {
            if (table.attributeconfigid == 25) {
              countryList.add(table);
            }
          }

          assignDropDownValue(userContactData, editContactData);

          yield FetchCountriesState.completed(isSuccess: true);
        } else if (apiResponse?.status == 401) {
          yield FetchCountriesState.error('401');
        } else {
          yield FetchCountriesState.error('Something went wrong');
        }
      }
      else if (event is AssignProfileVal) {
//          editUserData.clear();
//          editContactData.clear();
//          editBackOfficeData.clear();
//          userProfileData.clear();
//          userContactData.clear();
//          userBackOfficeData.clear();
        seperateValue(tempUserProfileData, userProfileData, editUserData);
        seperateValue(tempUserContactData, userContactData, editContactData);
        seperateValue(
            tempUserBackOfficeData, userBackOfficeData, editBackOfficeData);
      }
      else if (event is GetProfileHeaderEvent) {
        yield GetProfileHeaderState.loading('Please wait');
        ApiResponse? apiResponse = await profileRepository.getProfileHeader(event.profileUserId);
        print('issuccessval ${apiResponse?.data}');
        if (apiResponse?.status == 200) {
          profileHeader = ProfileHeader.fromJson(jsonDecode(apiResponse?.data ?? "{}"));
          yield GetProfileHeaderState.completed(isSuccess: true);
        }
        else if (apiResponse?.status == 401) {
          yield GetProfileHeaderState.error('401');
        }
        else {
          yield GetProfileHeaderState.error('Something went wrong');
        }
      }
    }
    catch (e, s) {
      LogUtil().printLog(message: 'Error is ===> $e');
      print("Error in ProfileBloc.mapEventToState():$e");
      print(s);
    }
  }

  void mapProfileData(Userprofiledetail userprofiledetail) {
    profileDataMap = {
      "objectid": userprofiledetail.objectid.toString(),
      "accounttype": userprofiledetail.accounttype.toString(),
      "orgunitid": userprofiledetail.orgunitid.toString(),
      "siteid": userprofiledetail.siteid.toString(),
      "approvalstatus": userprofiledetail.approvalstatus.toString(),
      "firstname": userprofiledetail.firstname,
      "lastname": userprofiledetail.lastname,
      "email": userprofiledetail.email,
      "nvarchar6": userprofiledetail.nvarchar6,
      "jobroleid": userprofiledetail.jobroleid,
      "jobtitle": userprofiledetail.jobtitle.toString(),
      "businessfunction": userprofiledetail.businessfunction.toString(),
      // "languageselection": userprofiledetail.languageselection,
      "picture": userprofiledetail.picture,
      "userid": userprofiledetail.userid,
      "displayname": userprofiledetail.displayname,
      "organization": userprofiledetail.organization,
      "usersite": userprofiledetail.usersite,
      "supervisoremployeeid": userprofiledetail.supervisoremployeeid,
      "addressline1": userprofiledetail.addressline1,
      "addresscity": userprofiledetail.addresscity,
      "addressstate": userprofiledetail.addressstate,
      "addresszip": userprofiledetail.addresszip,
      "addresscountry": userprofiledetail.addresscountry,
      "phone": userprofiledetail.phone,
      "mobilephone": userprofiledetail.mobilephone,
      "imaddress": userprofiledetail.imaddress,
      "dateofbirth": userprofiledetail.dateofbirth,
      "gender": userprofiledetail.gender,
      "paymentmode": userprofiledetail.paymentmode,
      "nvarchar7": userprofiledetail.nvarchar7,
      "nvarchar8": userprofiledetail.nvarchar8,
      "nvarchar9": userprofiledetail.nvarchar9,
      "securepaypalid": userprofiledetail.securepaypalid,
      "nvarchar10": userprofiledetail.nvarchar10,
      "highschool": userprofiledetail.highschool,
      "college": userprofiledetail.college,
      "highestdegree": userprofiledetail.highestdegree,
      "primaryjobfunction": userprofiledetail.primaryjobfunction,
      "payeeaccountno": userprofiledetail.payeeaccountno,
      "payeename": userprofiledetail.payeename,
      "paypalaccountname": userprofiledetail.paypalaccountname,
      "paypalemail": userprofiledetail.paypalemail,
      "shipaddline1": userprofiledetail.shipaddline1,
      "shipaddcity": userprofiledetail.shipaddcity,
      "shipaddstate": userprofiledetail.shipaddstate,
      "shipaddzip": userprofiledetail.shipaddzip,
      "shipaddcountry": userprofiledetail.shipaddcountry,
      "shipaddphone": userprofiledetail.shipaddphone,
      "profileimagepath": userprofiledetail.profileimagepath,
      "objetId": userprofiledetail.objetId,
      "isProfilexist": userprofiledetail.isProfilexist.toString(),
      "nvarchar103": userprofiledetail.nvarchar103,
      "nvarchar105": userprofiledetail.nvarchar105,
    };
  }

  void distributeBlocData(ProfileResponse profileResponse) {
    if (profileResponse.userprofilegroups.isNotEmpty)
      for (Profilegroup item in profileResponse.userprofilegroups) {
        if (item.groupid == 1) {
          tempUserProfileData.add(item);
        } else if (item.groupid == 2) {
          tempUserContactData.add(item);
        } else if (item.groupid == 4) {
          tempUserBackOfficeData.add(item);
        } else {
          print('do nothing');
        }
      }

    seperateValue(tempUserProfileData, userProfileData, editUserData);
    seperateValue(tempUserContactData, userContactData, editContactData);
    seperateValue(
        tempUserBackOfficeData, userBackOfficeData, editBackOfficeData);
  }

  void seperateValue(List<Profilegroup> list, List<Datafilelist> data,
      List<ProfileEditList> editData) {
    data.clear();
    editData.clear();

    if (list.isNotEmpty) {
      for (Datafilelist tempVal in list[0].datafilelist) {
        if (profileDataMap
                .containsKey(tempVal.datafieldname.toLowerCase().toString()) &&
            tempVal.datafieldname.toLowerCase().toString() != 'picture') {
          data.add(tempVal);
        }
      }

      for (Datafilelist data in data) {
        if (profileDataMap
            .containsKey(data.datafieldname.toLowerCase().toString())) {
          data.valueName =
              profileDataMap[data.datafieldname.toLowerCase().toString()] ?? "";
        }
        if (data.valueName == null) {
          data.valueName = "";
        }
        if (data.aliasname.toLowerCase().toString() == 'dateofbirth' &&
            data.valueName.isNotEmpty) {
          DateTime tempDate =
              new DateFormat("yyyy-MM-ddThh:mm:ss").parse(data.valueName);

          String date = DateFormat("MM/dd/yyyy").format(tempDate);
          data.valueName = date;

          print('checkmydateva; $date');
        }

        editData.add(ProfileEditList(
          datafieldname: data.datafieldname,
          aliasname: data.aliasname,
          attributedisplaytext: data.attributedisplaytext,
          groupid: data.groupid,
          displayorder: data.displayorder,
          attributeconfigid: data.attributeconfigid,
          isrequired: data.isrequired,
          iseditable: data.iseditable,
          enduservisibility: data.enduservisibility,
          uicontroltypeid: data.uicontroltypeid,
          name: data.name,
          minlength: data.minlength,
          maxlength: data.maxlength,
          valueName: data.valueName,
          table5: data.table5,
        ));
      }
    }

    print(
        'profileeditlist ${editUserData.length} ${editContactData.length} ${editBackOfficeData.length}');
  }

  void assignDropDownValue(List<Datafilelist> userContactData,
      List<ProfileEditList> editContactData) {
    print('getvalofdataa ${profileDataMap['addresscountry']}');
    for (Datafilelist val in userContactData) {
      if (val.uicontroltypeid == 18 || val.uicontroltypeid == 3) {
        if (countryList.isNotEmpty) {
          if (profileDataMap['addresscountry'] != null) {
            for (Table5 country in countryList) {
              if (profileDataMap['addresscountry'] ==
                  country.choicevalue.toLowerCase().toString()) {
                val.table5 = country;
              }
            }
          } else {
            val.table5 = countryList[0];
          }
        }
      }
    }

    for (ProfileEditList val in editContactData) {
      if (val.uicontroltypeid == 18 || val.uicontroltypeid == 3) {
        if (countryList.isNotEmpty) {
          if (profileDataMap['addresscountry'] != null) {
            for (Table5 country in countryList) {
              if ((profileDataMap['addresscountry'] ?? "").toLowerCase() ==
                  country.choicevalue.toLowerCase().toString()) {
                val.table5 = country;
              }
            }
          } else {
            val.table5 = countryList[0];
          }
        }
      }
    }
  }

  Future<void> savePrevilige(List<Userprivilege> userprivilige) async {
    if (userprivilige.isNotEmpty) {
      for (Userprivilege data in userprivilige) {
        if (data.privilegeid == 1072) {
          await sharePrefSaveBool(sharedPref_previlige, true);
          break;
        } else {
          await sharePrefSaveBool(sharedPref_previlige, false);
        }
      }
    } else {
      await sharePrefSaveBool(sharedPref_previlige, false);
    }
  }
}
