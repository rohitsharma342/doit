enum ProposalStatus {
  pending,
  underReview,
  approved,
  rejected,
  requiresChanges,
}

extension ProposalStatusExtension on ProposalStatus {
  String get displayName {
    switch (this) {
      case ProposalStatus.pending:
        return 'Pending';
      case ProposalStatus.underReview:
        return 'Under Review';
      case ProposalStatus.approved:
        return 'Approved';
      case ProposalStatus.rejected:
        return 'Rejected';
      case ProposalStatus.requiresChanges:
        return 'Requires Changes';
    }
  }

  String get colorHex {
    switch (this) {
      case ProposalStatus.pending:
        return '#FFA726';
      case ProposalStatus.underReview:
        return '#42A5F5';
      case ProposalStatus.approved:
        return '#66BB6A';
      case ProposalStatus.rejected:
        return '#EF5350';
      case ProposalStatus.requiresChanges:
        return '#AB47BC';
    }
  }
}

class ProposalComment {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  ProposalComment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory ProposalComment.fromJson(Map<String, dynamic> json) {
    return ProposalComment(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ProposalModel {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String contactEmail;
  final String contactPhone;
  final ProposalStatus status;
  final List<String> attachments;
  final List<ProposalComment> comments;
  final DateTime submittedAt;
  final DateTime? updatedAt;
  final String? category;

  ProposalModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    required this.status,
    this.attachments = const [],
    this.comments = const [],
    required this.submittedAt,
    this.updatedAt,
    this.category,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] ?? '',
      startupId: json['startupId'] ?? '',
      startupName: json['startupName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      status: ProposalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProposalStatus.pending,
      ),
      attachments: List<String>.from(json['attachments'] ?? []),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((c) => ProposalComment.fromJson(c))
              .toList() ??
          [],
      submittedAt: DateTime.parse(json['submittedAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      category: json['category'],
    );
  }

  ProposalModel copyWith({
    String? id,
    String? startupId,
    String? startupName,
    String? title,
    String? description,
    String? contactEmail,
    String? contactPhone,
    ProposalStatus? status,
    List<String>? attachments,
    List<ProposalComment>? comments,
    DateTime? submittedAt,
    DateTime? updatedAt,
    String? category,
  }) {
    return ProposalModel(
      id: id ?? this.id,
      startupId: startupId ?? this.startupId,
      startupName: startupName ?? this.startupName,
      title: title ?? this.title,
      description: description ?? this.description,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      submittedAt: submittedAt ?? this.submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }
}
