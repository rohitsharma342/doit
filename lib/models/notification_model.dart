enum NotificationType {
  statusUpdate,
  newComment,
  proposalSubmitted,
  systemAlert,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final String? relatedProposalId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.relatedProposalId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.systemAlert,
      ),
      relatedProposalId: json['relatedProposalId'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? type,
    String? relatedProposalId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      relatedProposalId: relatedProposalId ?? this.relatedProposalId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
