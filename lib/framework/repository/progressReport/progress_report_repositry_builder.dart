import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/repository/progressReport/progress_report_repositry_public.dart';

class ProgressReportRepositoryBuilder {
  static ProgressReportRepository repository() {
    return ProgressReportRepositoryPublic();
  }
}

abstract class ProgressReportRepository {
  Future<Response?> getConsolidatePRT({
    int aintComponentID,
    int aintCompInsID,
    int aintSelectedGroupValue,
  });

  Future<Response?> getCourseSummary(
      {int userID,
      String cID,
      int objectTypeId,
      String startDate,
      String endDate,
      String seqID,
      String trackID});

  Future<Response?> getProgressDetailData(
      {int userID,
      String cID,
      int objectTypeId,
      String startDate,
      String endDate,
      String seqID,
      String trackID});

  Future<Response?> viewQuestion(
      {String contentId,
      int qNo,
      String trackId,
      String trackSeqId,
      String folderpath,
      String eventSCOId});
}
