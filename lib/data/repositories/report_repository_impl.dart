import 'package:city_care/data/datasources/database_helper.dart';
import 'package:city_care/data/datasources/firebase_service.dart';
import 'package:city_care/data/datasources/gemini_service.dart';
import 'package:city_care/data/datasources/location_service.dart';
import 'package:city_care/data/models/report_model.dart';
import 'package:city_care/domain/entities/report.dart';
import 'package:city_care/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final DatabaseHelper databaseHelper;
  final FirebaseService firebaseService;
  final GeminiService geminiService;
  final LocationService locationService;

  ReportRepositoryImpl({
    required this.databaseHelper,
    required this.firebaseService,
    required this.geminiService,
    required this.locationService,
  });

  @override
  Future<void> saveReport(Report report) async {
    final model = ReportModel(
      id: report.id,
      title: report.title,
      description: report.description,
      latitude: report.latitude,
      longitude: report.longitude,
      status: report.status,
      isDraft: report.isDraft,
      aiSuggestion: report.aiSuggestion,
      createdAt: report.createdAt,
    );

    if (report.isDraft) {
      await databaseHelper.insertDraft(model);
    } else {
      await firebaseService.saveReport(model);
      // Optional: Delete from draft if it was a draft
      await databaseHelper.deleteDraft(report.id);
    }
  }

  @override
  Future<List<Report>> getReports() async {
    return await firebaseService.getReports();
  }

  @override
  Future<List<Report>> getDrafts() async {
    return await databaseHelper.getDrafts();
  }

  @override
  Future<void> deleteDraft(String id) async {
    await databaseHelper.deleteDraft(id);
  }

  @override
  Future<void> syncDrafts() async {
    final drafts = await databaseHelper.getDrafts();
    for (var draft in drafts) {
      // Logic to sync drafts to cloud automatically if needed
      // For now, we just leave them as drafts until user explicitly uploads
    }
  }

  @override
  Future<String> getAiSuggestion(String description) async {
    return await geminiService.getSuggestion(description);
  }

  @override
  Future<Map<String, double>> getCurrentLocation() async {
    return await locationService.getCurrentLocation();
  }
}
