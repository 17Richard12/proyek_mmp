import 'package:city_care/domain/entities/report.dart';

abstract class ReportRepository {
  Future<void> saveReport(Report report);
  Future<List<Report>> getReports();
  Future<List<Report>> getDrafts();
  Future<void> deleteDraft(String id);
  Future<void> syncDrafts();
  Future<String> getAiSuggestion(String description);
  Future<Map<String, double>> getCurrentLocation();
}
