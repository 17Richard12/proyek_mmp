class ReportModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String status;
  final bool isDraft;
  final String? aiSuggestion;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.isDraft,
    this.aiSuggestion,
    required this.createdAt,
  });

  ReportModel copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    String? status,
    bool? isDraft,
    String? aiSuggestion,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      isDraft: isDraft ?? this.isDraft,
      aiSuggestion: aiSuggestion ?? this.aiSuggestion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
