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
      try {
        // PERBAIKAN: Buat instance ReportModel baru secara manual
        final reportToUpload = ReportModel(
          id: draft.id,
          title: draft.title,
          description: draft.description,
          latitude: draft.latitude,
          longitude: draft.longitude,
          status: draft.status,
          isDraft: false, // Set isDraft menjadi false di sini
          aiSuggestion: draft.aiSuggestion,
          createdAt: draft.createdAt,
        );

        await firebaseService.saveReport(reportToUpload);
        await databaseHelper.deleteDraft(draft.id);
      } catch (e) {
        // Handle error jika gagal upload
      }
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
