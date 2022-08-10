import 'dart:convert';

LearningCommunitiesResponse communitiesResponseFromJson(String str) =>
    LearningCommunitiesResponse.fromJson(json.decode(str));

dynamic communitiesResponseToJson(LearningCommunitiesResponse data) =>
    json.encode(data.toJson());

class LearningCommunitiesResponse {
  List<Table> table = [];
  List<PortalListing> portalListing = [];

  LearningCommunitiesResponse(
      {required this.table, required this.portalListing});

  LearningCommunitiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != dynamic) {
      json['Table'].forEach((v) {
        table.add(new Table.fromJson(v));
      });
    }
    if (json['portallisting'] != dynamic) {
      json['portallisting'].forEach((v) {
        portalListing.add(new PortalListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != dynamic) {
      data['Table'] = this.table.map((v) => v.toJson()).toList();
    }
    if (this.portalListing != dynamic) {
      data['portallisting'] =
          this.portalListing.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  int categoryID = 0;
  String name = "";
  String shortCategoryName = "";
  String description = "";
  int parentID = 0;
  dynamic displayOrder;
  int componentID = 0;

  /*Table(
      {this.categoryID,
      this.name,
      this.shortCategoryName,
      this.description,
      this.parentID,
      this.displayOrder,
      this.componentID});*/

  Table.fromJson(Map<String, dynamic> json) {
    categoryID = json['CategoryID'];
    name = json['Name'];
    shortCategoryName = json['ShortCategoryName'];
    description = json['Description'];
    parentID = json['ParentID'];
    displayOrder = json['DisplayOrder'];
    componentID = json['ComponentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryID'] = this.categoryID;
    data['Name'] = this.name;
    data['ShortCategoryName'] = this.shortCategoryName;
    data['Description'] = this.description;
    data['ParentID'] = this.parentID;
    data['DisplayOrder'] = this.displayOrder;
    data['ComponentID'] = this.componentID;
    return data;
  }
}

class PortalListing {
  int learningPortalID = 0;
  String learningProviderName = "";
  String learningProviderNameONEnlightus = "";
  String description = "";
  String keywords = "";
  String contactFirstName = "";
  dynamic contactMiddleName;
  String contactLastName = "";
  String contactAddress1 = "";
  dynamic contactAddress2;
  String contactCity = "";
  String contactState = "";
  String contactCountry = "";
  String contactPhoneNo = "";
  String contactEmail = "";
  int siteID = 0;
  String siteURL = "";
  String learnerSiteURL = "";
  int parentID = 0;
  int orgUnitID = 0;
  int objectID = 0;
  String name = "";
  String picture = "";
  int categoryID = 0;
  String titleWithLink = "";
  String imageWithLink = "";
  String actionGOTO = "";
  String labelAlreadyaMember = "";
  String actionJoinCommunity = "";
  String labelPendingRequest = "";

  /*Portallisting(
      {this.learningPortalID,
      this.learningProviderName,
      this.learningProviderNameONEnlightus,
      this.description,
      this.keywords,
      this.contactFirstName,
      this.contactMiddleName,
      this.contactLastName,
      this.contactAddress1,
      this.contactAddress2,
      this.contactCity,
      this.contactState,
      this.contactCountry,
      this.contactPhoneNo,
      this.contactEmail,
      this.siteID,
      this.siteURL,
      this.learnerSiteURL,
      this.parentID,
      this.orgUnitID,
      this.objectID,
      this.name,
      this.picture,
      this.categoryID,
      this.titleWithLink,
      this.imageWithLink,
      this.actionGOTO,
      this.labelAlreadyaMember,
      this.actionJoinCommunity,
      this.labelPendingRequest});*/

  PortalListing.fromJson(Map<String, dynamic> json) {
    print(json['LearningPortalID']);
    learningPortalID = json['LearningPortalID'];
    learningProviderName = json['LearningProviderName'];
    learningProviderNameONEnlightus = json['LearningProviderName_ON_Enlightus'];
    description = json['Description'];
    keywords = json['Keywords'];
    contactFirstName = json['Contact_FirstName'];
    // contactMiddleName =
    //     json['Contact_MiddleName'] == dynamic ? '' : json['Contact_MiddleName'];
    // contactMiddleName = json['Contact_MiddleName'];
    contactLastName = json['Contact_LastName'];
    contactAddress1 = json['Contact_Address1'];
    // contactAddress2 = json['Contact_Address2'];
    contactCity = json['Contact_City'];
    contactState = json['Contact_State'];
    contactCountry = json['Contact_Country'];
    contactPhoneNo = json['Contact_PhoneNo'];
    contactEmail = json['Contact_Email'];
    siteID = json['SiteID'];
    siteURL = json['SiteURL'];
    learnerSiteURL = json['LearnerSiteURL'];
    parentID = json['ParentID'];
    orgUnitID = json['OrgUnitID'];
    objectID = json['ObjectID'];
    name = json['name'];
    picture = json['picture'];
    categoryID = json['CategoryID'];
    titleWithLink = json['TitleWithLink'];
    imageWithLink = json['ImageWithLink'];
    actionGOTO = json['actionGOTO'];
    labelAlreadyaMember = json['labelAlreadyaMember'];
    actionJoinCommunity = json['actionJoinCommunity'];
    labelPendingRequest = json['labelPendingRequest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LearningPortalID'] = this.learningPortalID;
    data['LearningProviderName'] = this.learningProviderName;
    data['LearningProviderName_ON_Enlightus'] =
        this.learningProviderNameONEnlightus;
    data['Description'] = this.description;
    data['Keywords'] = this.keywords;
    data['Contact_FirstName'] = this.contactFirstName;
    data['Contact_MiddleName'] = this.contactMiddleName;
    data['Contact_LastName'] = this.contactLastName;
    data['Contact_Address1'] = this.contactAddress1;
    data['Contact_Address2'] = this.contactAddress2;
    data['Contact_City'] = this.contactCity;
    data['Contact_State'] = this.contactState;
    data['Contact_Country'] = this.contactCountry;
    data['Contact_PhoneNo'] = this.contactPhoneNo;
    data['Contact_Email'] = this.contactEmail;
    data['SiteID'] = this.siteID;
    data['SiteURL'] = this.siteURL;
    data['LearnerSiteURL'] = this.learnerSiteURL;
    data['ParentID'] = this.parentID;
    data['OrgUnitID'] = this.orgUnitID;
    data['ObjectID'] = this.objectID;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['CategoryID'] = this.categoryID;
    data['TitleWithLink'] = this.titleWithLink;
    data['ImageWithLink'] = this.imageWithLink;
    data['actionGOTO'] = this.actionGOTO;
    data['labelAlreadyaMember'] = this.labelAlreadyaMember;
    data['actionJoinCommunity'] = this.actionJoinCommunity;
    data['labelPendingRequest'] = this.labelPendingRequest;
    return data;
  }
}
