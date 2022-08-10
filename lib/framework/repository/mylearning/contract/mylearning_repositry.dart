import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';

abstract class MyLearningRepository {
  Future<Response?> getMobileMyCatalogObjectsData(
      int pageIndex,
      int pageSize,
      bool isArchive,
      bool isWaitList,
      String searchTxt,
      String selectedSort,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String contentID,
      String contentStatus);

  Future<Response?> getMobileMyCatalogObjectsPlusData(
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
      String compInsId,
      String string,
      int isWishlistContent);

  Future<Response?> getMobileMyLearningPlusObjectsData(
      int pageIndex,
      int pageSize,
      bool isArchive,
      bool isWaitList,
      String searchTxt,
      String selectedSort,
      String selectedGroupBy,
      String selectedCategories,
      String selectedObjectTypes,
      String selectedSkillCats,
      String selectedJobRoles,
      String selectedCredits,
      String selectedInstructor,
      String contentID,
      String contentStatus,
      String componentId,
      String componentInsId,
      int isWishlistCount,
      String dateFilter
      );

  Future<Response?> getEventResourceInfo(
      String componentId,
      String componentInsId,
      String objectTypes,
      String multiLocation,
      String startDate,
      String endDate,
      String eventId);

  Future<Response?> getUserRatingsOfTheContent(
      String contentID, int skippedRows);

  Future<Response?> deleteRatingsOfTheContent(String contentID);

  Future<Response?> addRatingsOfTheContent(
      String contentID, String strReview, int ratingID);

  Future<Response?> getComponentSortOptions(String strComponentID);

  Future<Response?> updateMyLearningArchive(bool isArchive, String contentID);

  Future<Response?> getMyConnectionListForShareContent(String searchTxt);

  Future<Response?> sendMailToPeople(
      String toEmail,
      String subject,
      String message,
      String emailList,
      bool isPeople,
      bool isFromForm,
      bool isFromQuestion,
      String contentId);

  Future<Response?> getMyLearningDetails(MyLearningDetailsRequest request);

  Future<Response?> setCompleteStatus(String contentId, String scoId);

  Future<Response?> getCertificate(String certificateId, String certificatePage,
      String siteUrl, String certificateId2, String contentId, String scoId);

  Future<Response?> cancelEnrollment(bool isBadCancel, String strContentID);

//  Future<Response> getCertificate(String contentId, String scoId);

  Future<Response?> getCategoriesTree(String categoryID, String componentId);

  Future<Response?> getLearningProviderTree();

  Future<Response?> getContentStatus(String url);

  Future<Response?> courseTrackingApiCall(
    String courseURL,
    String userID,
    String scoId,
    String objectTypeId,
    String contentID,
    String siteIDValue,
  );

  Future<Response?> tokenFromSessionIdAiCall(
      String courseURL,
      String courseName,
      String contentID,
      String objectTypeId,
      String learnerSCOID,
      String learnerSessionID,
      String userID);

  Future<Response?> sendViaEmailMyLearn(String userMails, String subject,
      String message, bool isAttachDocument, String contentId);

  Future<Response?> updateCompleteStatusCall(
      String contentId, String userID, String scoId);

  Future<Response?> getUserAchievementPlusData({
    String userID,
    String siteID,
    String locale,
    String gameID,
    String componentID,
    String componentInsID,
  });

  Future<Response?> getDynamicTabPlusEvent(String compId, String compInsId);

  Future<Response?> getMenuComponents(int menuId, String menuUrl, int roleId);

  Future<Response?> getGameLearnPlusList({
    bool fromAchievement,
    String userID,
    String siteID,
    String locale,
    String componentID,
    String componentInsID,
    String leaderByGroup,
    String gameID,
  });

  Future<Response?> getLearnPlusLeaderboardData({
    String userID,
    String siteID,
    String locale,
    String componentID,
    String componentInsID,
    String gameID,
  });
}
