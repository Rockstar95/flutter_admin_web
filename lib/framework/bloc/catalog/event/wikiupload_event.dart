import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class WikiUploadEvent extends Equatable {
  const WikiUploadEvent();
}

class PostWikiUploadEvent extends WikiUploadEvent {
  final bool isUrl;
  final String filepath,
      title,
      shortDesc,
      localeID,
      keywords,
      eventCategoryID,
      categoryId;
  final int mediaTypeID,
      objectTypeID,
      userID,
      siteID,
      componentID,
      cMSGroupId,
      orgUnitID;

  PostWikiUploadEvent({
    this.isUrl = false,
    this.filepath = "",
    this.title = "",
    this.shortDesc = "",
    this.localeID = "",
    this.keywords = "",
    this.eventCategoryID = "",
    this.categoryId = "",
    this.mediaTypeID = 0,
    this.objectTypeID = 0,
    this.userID = 0,
    this.siteID = 0,
    this.componentID = 0,
    this.cMSGroupId = 0,
    this.orgUnitID = 0,
  });

  @override
  List<Object> get props => [
        isUrl,
        filepath,
        mediaTypeID,
        objectTypeID,
        title,
        shortDesc,
        userID,
        siteID,
        localeID,
        componentID,
        cMSGroupId,
        keywords,
        orgUnitID,
        eventCategoryID,
        categoryId,
      ];
}

class OpenFileExplorerEvent extends WikiUploadEvent {
  final FileType pickingType;

  OpenFileExplorerEvent(this.pickingType);

  @override
  // TODO: implement props
  List<Object> get props => [pickingType];
}

class GetWikiCategoriesEvent extends WikiUploadEvent {
  final int intUserID;
  final int intSiteID;
  final int intComponentID;
  final String locale;
  final String strType;

  GetWikiCategoriesEvent(
      {this.intUserID = 0,
      this.intSiteID = 0,
      this.intComponentID = 0,
      this.locale = "",
      this.strType = ""});

  @override
  List<Object> get props =>
      [intUserID, intSiteID, intComponentID, locale, strType];
}
