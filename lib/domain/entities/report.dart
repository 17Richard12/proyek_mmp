class Report {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String status; // 'pending', 'resolved'
  final bool isDraft;
  final String? aiSuggestion;
  final DateTime createdAt;

  const Report({
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
}
