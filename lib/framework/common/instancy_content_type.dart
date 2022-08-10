import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning.dart';
import 'package:flutter_admin_web/framework/helpers/parsing_helper.dart';

class InstancyContentType {
  InstancyContentTypeEnum type;
  InstancyContentSubTypeEnum subType;

  InstancyContentType({
    this.type = InstancyContentTypeEnum.NONE,
    this.subType = InstancyContentSubTypeEnum.NONE,
  });

  static InstancyContentType getContentType({DummyMyCatelogResponseTable2? table2, MyLearningModel? myLearningModel, int objecttypeid = -1, int mediatypeid = -1, }) {
    InstancyContentTypeEnum type = InstancyContentTypeEnum.NONE;
    InstancyContentSubTypeEnum subType = InstancyContentSubTypeEnum.NONE;

    int defaultObjectTypeValue = -1, defaultMediaTypeValue = -1;

    //region Object and Media Type Id Initializations
    int ojectTypeId = -1, mediaTypeId = -1;
    if(table2 != null) {
      ojectTypeId = table2.objecttypeid;
      mediaTypeId = ParsingHelper.parseIntMethod(table2.mediatypeid, defaultValue: defaultMediaTypeValue);
    }
    else if(myLearningModel != null) {
      ojectTypeId = ParsingHelper.parseIntMethod(myLearningModel.objecttypeId, defaultValue: defaultObjectTypeValue);
      mediaTypeId = ParsingHelper.parseIntMethod(myLearningModel.mediatypeId, defaultValue: defaultMediaTypeValue);
    }
    else {
      ojectTypeId = objecttypeid;
      mediaTypeId = mediatypeid;
    }
    //endregion

    //region Learning Module
    if(ojectTypeId == 8) {
      type = InstancyContentTypeEnum.Learning_Module;

      if(mediaTypeId == 61) {
        subType = InstancyContentSubTypeEnum.Microlearning;
      }
      else if(mediaTypeId == 62) {
        subType = InstancyContentSubTypeEnum.Learning_Module;
      }
    }
    //endregion
    //region Assessment
    else if(ojectTypeId == 9) {
      type = InstancyContentTypeEnum.Assessment;

      if(mediaTypeId == 27) {
        subType = InstancyContentSubTypeEnum.Test;
      }
      else if(mediaTypeId == 28) {
        subType = InstancyContentSubTypeEnum.Survey;
      }
    }
    //endregion
    //region Learning Track
    else if(ojectTypeId == 10) {
      type = InstancyContentTypeEnum.Learning_Track;
    }
    //endregion
    //region Video And Audio
    else if(ojectTypeId == 11) {
      type = InstancyContentTypeEnum.Video_and_Audio;

      if(mediaTypeId == 1) {
        subType = InstancyContentSubTypeEnum.Image;
      }
      else if(mediaTypeId == 3) {
        subType = InstancyContentSubTypeEnum.Video;
      }
      else if(mediaTypeId == 4) {
        subType = InstancyContentSubTypeEnum.Audio;
      }
      else if(mediaTypeId == 57) {
        subType = InstancyContentSubTypeEnum.Embeded_Audio;
      }
      else if(mediaTypeId == 58) {
        subType = InstancyContentSubTypeEnum.Embeded_Video;
      }
    }
    //endregion
    //region Documents
    else if(ojectTypeId == 14) {
      type = InstancyContentTypeEnum.Documents;

      if(mediaTypeId == 8) {
        subType = InstancyContentSubTypeEnum.Word;
      }
      else if(mediaTypeId == 9) {
        subType = InstancyContentSubTypeEnum.PDF;
      }
      else if(mediaTypeId == 10) {
        subType = InstancyContentSubTypeEnum.Excel;
      }
      else if(mediaTypeId == 17) {
        subType = InstancyContentSubTypeEnum.PPT;
      }
      else if(mediaTypeId == 18) {
        subType = InstancyContentSubTypeEnum.MPP;
      }
      else if(mediaTypeId == 19) {
        subType = InstancyContentSubTypeEnum.Visio_Types;
      }
    }
    //endregion
    //region Glossary
    else if(ojectTypeId == 20) {
      type = InstancyContentTypeEnum.Glossary;
    }
    //endregion
    //region HTML Package
    else if(ojectTypeId == 21) {
      type = InstancyContentTypeEnum.HTML_Package;

      if(mediaTypeId == 40) {
        subType = InstancyContentSubTypeEnum.HTML_Zip_File;
      }
      else if(mediaTypeId == 41) {
        subType = InstancyContentSubTypeEnum.Single_HTML_File;
      }
    }
    //endregion
    //region E-Learning Course
    else if(ojectTypeId == 26) {
      type = InstancyContentTypeEnum.E_Learning_Course;

      if(mediaTypeId == 30) {
        subType = InstancyContentSubTypeEnum.SCORM_12;
      }
      else if(mediaTypeId == 31) {
        subType = InstancyContentSubTypeEnum.SCORM_2004;
      }
    }
    //endregion
    //region AICC
    else if(ojectTypeId == 27) {
      type = InstancyContentTypeEnum.AICC;
    }
    //endregion
    //region Reference
    else if(ojectTypeId == 28) {
      type = InstancyContentTypeEnum.Reference;

      if(mediaTypeId == 5) {
        subType = InstancyContentSubTypeEnum.Online_Course;
      }
      else if(mediaTypeId == 6) {
        subType = InstancyContentSubTypeEnum.Classroom_Course;
      }
      else if(mediaTypeId == 7) {
        subType = InstancyContentSubTypeEnum.Virtual_Classroom;
      }
      else if(mediaTypeId == 13) {
        subType = InstancyContentSubTypeEnum.URL;
      }
      else if(mediaTypeId == 14) {
        subType = InstancyContentSubTypeEnum.LiveMeeting;
      }
      else if(mediaTypeId == 15) {
        subType = InstancyContentSubTypeEnum.Recording;
      }
      else if(mediaTypeId == 20) {
        subType = InstancyContentSubTypeEnum.Book;
      }
      else if(mediaTypeId == 21) {
        subType = InstancyContentSubTypeEnum.Document;
      }
      else if(mediaTypeId == 22) {
        subType = InstancyContentSubTypeEnum.Conference;
      }
      else if(mediaTypeId == 23) {
        subType = InstancyContentSubTypeEnum.Video;
      }
      else if(mediaTypeId == 24) {
        subType = InstancyContentSubTypeEnum.Audio;
      }
      else if(mediaTypeId == 25) {
        subType = InstancyContentSubTypeEnum.Web_Link;
      }
      else if(mediaTypeId == 26) {
        subType = InstancyContentSubTypeEnum.Blended_Online_and_Classroom;
      }
      else if(mediaTypeId == 33) {
        subType = InstancyContentSubTypeEnum.Assessor_Service;
      }
      else if(mediaTypeId == 42) {
        subType = InstancyContentSubTypeEnum.Image;
      }
      else if(mediaTypeId == 43) {
        subType = InstancyContentSubTypeEnum.Teaching_Slides;
      }
      else if(mediaTypeId == 44) {
        subType = InstancyContentSubTypeEnum.Animation;
      }
      else if(mediaTypeId == 52) {
        subType = InstancyContentSubTypeEnum.PsyTech_Assessment;
      }
      else if(mediaTypeId == 53) {
        subType = InstancyContentSubTypeEnum.DISC_Assessment;
      }
      else if(mediaTypeId == 54) {
        subType = InstancyContentSubTypeEnum.Coorpacademy;
      }
    }
    //endregion
    //region Webpage
    else if(ojectTypeId == 36) {
      type = InstancyContentTypeEnum.Webpage;
    }
    //endregion
    // region Certificate
    else if(ojectTypeId == 52) {
      type = InstancyContentTypeEnum.Certificate;
    }
    //endregion
    //region Events
    else if(ojectTypeId == 70) {
      type = InstancyContentTypeEnum.Event;

      if(mediaTypeId == 46) {
        subType = InstancyContentSubTypeEnum.Classroom_IN_Person;
      }
      else if(mediaTypeId == 47) {
        subType = InstancyContentSubTypeEnum.Virtual_Class_Online;
      }
      else if(mediaTypeId == 48) {
        subType = InstancyContentSubTypeEnum.Networking_In_Person;
      }
      else if(mediaTypeId == 49) {
        subType = InstancyContentSubTypeEnum.Lab_In_Person;
      }
      else if(mediaTypeId == 50) {
        subType = InstancyContentSubTypeEnum.Project_In_Person;
      }
      else if(mediaTypeId == 51) {
        subType = InstancyContentSubTypeEnum.Field_Trip_In_Person;
      }
    }
    //endregion
    // region XApi
    else if(ojectTypeId == 102) {
      type = InstancyContentTypeEnum.xAPI;
    }
    //endregion
    // region cmi5
    else if(ojectTypeId == 693) {
      type = InstancyContentTypeEnum.cmi5;
    }
    //endregion
    // region Assignment
    else if(ojectTypeId == 694) {
      type = InstancyContentTypeEnum.Assignment;
    }
    //endregion

    return InstancyContentType(type: type, subType: subType);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InstancyContentType && other.type == this.type && other.subType == this.subType;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return {"type" : type, "subType" : subType}.toString();
  }
}

enum InstancyContentTypeEnum {
  Learning_Module,
  Assessment,
  Learning_Track,
  Video_and_Audio,
  Documents,
  Glossary,
  HTML_Package,
  E_Learning_Course,
  AICC,
  Reference,
  Webpage,
  Certificate,
  Event,
  xAPI,
  cmi5,
  Assignment,
  NONE
}

enum InstancyContentSubTypeEnum {
  Microlearning, Learning_Module,
  Test, Survey,
  Image, Video, Audio, Embeded_Audio, Embeded_Video,
  Word, PDF, Excel, PPT, MPP, Visio_Types,
  HTML_Zip_File, Single_HTML_File,
  SCORM_12, SCORM_2004,

  Online_Course, Classroom_Course, Virtual_Classroom, URL, LiveMeeting, Recording,
  Book, Document, Conference, Web_Link, Blended_Online_and_Classroom, Assessor_Service,
  Teaching_Slides, Animation, PsyTech_Assessment, DISC_Assessment, Coorpacademy,

  Classroom_IN_Person, Virtual_Class_Online, Networking_In_Person, Lab_In_Person, Project_In_Person, Field_Trip_In_Person,
  NONE,
}
