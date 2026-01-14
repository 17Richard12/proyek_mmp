import 'package:city_care/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required String id,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String status,
    required bool isDraft,
    String? aiSuggestion,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          latitude: latitude,
          longitude: longitude,
          status: status,
          isDraft: isDraft,
          aiSuggestion: aiSuggestion,
          createdAt: createdAt,
        );

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'],
      isDraft: json['isDraft'] == 1 || json['isDraft'] == true,
      aiSuggestion: json['aiSuggestion'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'isDraft': isDraft,
      'aiSuggestion': aiSuggestion,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'isDraft': isDraft ? 1 : 0,
      'aiSuggestion': aiSuggestion,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
