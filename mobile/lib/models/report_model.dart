class ReportHistoryItem {
  final String status;
  final DateTime date;
  final String note;

  ReportHistoryItem({
    required this.status,
    required this.date,
    required this.note,
  });

  factory ReportHistoryItem.fromJson(Map<String, dynamic> json) {
    return ReportHistoryItem(
      status: json['status'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'date': date.toIso8601String(),
    'note': note,
  };
}

class ReportModel {
  final String id;
  final String ticketNumber;
  final String title;
  final String description;
  final String categoryId;
  String status; // 'pending', 'in_review', 'assigned', 'in_progress', 'resolved'
  final String priority; // 'low', 'medium', 'high', 'critical'
  final double latitude;
  final double longitude;
  final String address;
  final String neighborhood;
  final String photoUrl;
  final String? resolutionPhotoUrl;
  final String? resolutionNotes;
  final String citizenName;
  final String citizenPhone;
  int upvotesCount;
  final DateTime createdAt;
  DateTime? resolvedAt;
  final List<ReportHistoryItem> history;

  ReportModel({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.status,
    required this.priority,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.neighborhood,
    required this.photoUrl,
    this.resolutionPhotoUrl,
    this.resolutionNotes,
    required this.citizenName,
    required this.citizenPhone,
    this.upvotesCount = 1,
    required this.createdAt,
    this.resolvedAt,
    required this.history,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 19.7024,
      longitude: (json['longitude'] as num?)?.toDouble() ?? -101.1923,
      address: json['address'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      resolutionPhotoUrl: json['resolutionPhotoUrl'],
      resolutionNotes: json['resolutionNotes'],
      citizenName: json['citizenName'] ?? 'Ciudadano Anónimo',
      citizenPhone: json['citizenPhone'] ?? '',
      upvotesCount: json['upvotesCount'] ?? 1,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      resolvedAt: json['resolvedAt'] != null ? DateTime.tryParse(json['resolvedAt']) : null,
      history: (json['history'] as List<dynamic>? ?? [])
          .map((h) => ReportHistoryItem.fromJson(h))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ticketNumber': ticketNumber,
    'title': title,
    'description': description,
    'categoryId': categoryId,
    'status': status,
    'priority': priority,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'neighborhood': neighborhood,
    'photoUrl': photoUrl,
    'resolutionPhotoUrl': resolutionPhotoUrl,
    'resolutionNotes': resolutionNotes,
    'citizenName': citizenName,
    'citizenPhone': citizenPhone,
    'upvotesCount': upvotesCount,
    'createdAt': createdAt.toIso8601String(),
    'resolvedAt': resolvedAt?.toIso8601String(),
    'history': history.map((h) => h.toJson()).toList(),
  };
}
