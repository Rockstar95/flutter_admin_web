import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:provider/provider.dart';

import '../framework/bloc/discussion/model/discussion_main_home_response.dart';
import '../framework/common/constants.dart';
import '../framework/common/pref_manger.dart';
import '../providers/discussion_forum_provider.dart';
import '../repositories/discussion_forum/discussion_forum_repository_main.dart';
import '../utils/my_print.dart';
import 'connection_controller.dart';

class DiscussionForumController {
  Future<void> getAllDiscussionForums({bool isRefresh = true, bool withoutNotify = false, String searchString = "", bool isEventTab = true,
    String contentId = "", String strComponentID = "", String strRepositoryId = ""}) async {

    MyPrint.printOnConsole("getAllDiscussionForums called with refresh:$isRefresh");
    print("isEventTab:${isEventTab}");
    print("Component Id:${contentId}");

    DiscussionForumProvider discussionForumProvider = Provider.of<DiscussionForumProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);

    if (!ConnectionController().checkConnection()) {
      return;
    }

    if (isRefresh) {
      MyPrint.printOnConsole("Refresh");
      discussionForumProvider.isFirstTimeLoadingDiscussions = true;
      discussionForumProvider.isDiscussionsLoading = false; // track if discussions fetching
      discussionForumProvider.hasMoreDiscussions = true; // flag for more discussions available or not
      discussionForumProvider.discussionsPageIndex = 1;
      discussionForumProvider.list.clear();
      discussionForumProvider.myDiscussionForumList.clear();

      if (!withoutNotify) discussionForumProvider.notifyListeners();
    }

    try {
      if (!discussionForumProvider.hasMoreDiscussions || discussionForumProvider.isDiscussionsLoading) return;

      discussionForumProvider.isDiscussionsLoading = true;
      if (!withoutNotify) discussionForumProvider.notifyListeners();

      List<ForumList> forums = await DiscussionForumRepositoryMain().getDiscussionMainHomeDataUsingCompute(
        pageIndex: discussionForumProvider.discussionsPageIndex,
        pageSize: discussionForumProvider.discussionsPageLimit,
        searchString: discussionForumProvider.dicussionsSearchString,
        categoryIds: '',
        isEventTab: isEventTab,
        forumContentID: contentId,
        strComponentID: strComponentID,
        strRepositoryId: strRepositoryId,
      );

      if (forums.length < discussionForumProvider.discussionsPageLimit) {
        discussionForumProvider.hasMoreDiscussions = false;
      }

      discussionForumProvider.list.addAll(forums);
      discussionForumProvider.discussionsPageIndex++;
      MyPrint.printOnConsole("New Page Index:${discussionForumProvider.discussionsPageIndex}");

      String strUserID = await sharePrefGetString(sharedPref_userid);
      int myuserid = int.tryParse(strUserID) ?? -1;
      for (int i = 0; i < forums.length; i++) {
        if (forums[i].createdUserID == myuserid) {
          discussionForumProvider.myDiscussionForumList.add(forums[i]);
        }
      }

      discussionForumProvider.isDiscussionsLoading = false;
      discussionForumProvider.isFirstTimeLoadingDiscussions = false;
      discussionForumProvider.notifyListeners();
      MyPrint.printOnConsole("Discussion Length : ${discussionForumProvider.list.length}");
    }
    catch (e) {
      MyPrint.printOnConsole("Error:" + e.toString());
      discussionForumProvider.isFirstTimeLoadingDiscussions = false;
      discussionForumProvider.isDiscussionsLoading = false;
      discussionForumProvider.list.clear();
      discussionForumProvider.hasMoreDiscussions = false;
      discussionForumProvider.notifyListeners();
    }
  }


}

