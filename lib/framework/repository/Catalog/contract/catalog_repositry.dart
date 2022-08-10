import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';

abstract class CatalogRepository {
  Future<Response?> getCategoryForBrowse();

  Future<Response?> getMobileMyCatalogObjectsData(
      int pageIndex,
      int selectedCategoryID,
      String searchTxt,
      bool isWishList,
      String selectedSort,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String selectedRating,
      String learningPortals,
      String type,
      String selectedPriceRange,
      String compId,
      String compInsId);

  Future<Response?> addToWishList(String contentId);

  Future<Response?> removeFromWishList(String contentId);

  Future<Response?> doSubSiteLogin(String username, String password,
      String mobileSiteUrl, String downloadContent, String siteId);

  Future<Response?> getFileUploadControls(
      String siteId, String localeId, String compInsId);

  Future<Response?> getScheduleData(
      {String eventID, String multiInstanceEventEnroll, String multiLocation});

  Future<Response?> addToEnrollContent({
    String selectedContent,
    int orgUnitID,
    int componentID,
    int componentInsID,
    String additionalParams,
    String targetDate,
    String rescheduleEnroll,
  });

  Future<Response?> getPrerequisiteDetails(String contentID, String userID);

  Future<Response?> getAssociatedContent(
    String contentID,
    String componentID,
    String componentInstanceID,
    String instanceData,
    String preRequisiteSequencePathID,
  );

  Future<Response?> associatedAddToMyLearning({
    String selectedContent,
    String componentID,
    String componentInsID,
    String additionalParams,
    String addLearnerPreRequisiteContent,
    String addMultiInstancesWithPrice,
    String addWaitListContentIDs,
    String multiInstanceEventEnroll,
  });

// ?ContentID=909d60e9-72e1-4d74-9553-390ceb7efd77&ComponentID=1&ComponentInstanceID=50044&UserID=352&SiteID=374&Instancedata=&PreRequisiteSequncePathID=10&Locale=en-us

  Future<Response?> getCatalogDetails(MyLearningDetailsRequest request);

  Future<Response?> saveInAppPurchaseDetails(
    String userId,
    String siteURl,
    String contentID,
    String orderId,
    String purchaseToken,
    String productId,
    String purchaseTime,
    String deviceType,
  );
}
