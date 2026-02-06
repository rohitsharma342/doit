enum ProposalStatus { pending, reviewing, approved, rejected }

class ProposalModel {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String contactInfo;
  final List<String> attachments;
  final ProposalStatus status;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProposalModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.contactInfo,
    required this.attachments,
    required this.status,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] as String,
      startupId: json['startupId'] as String,
      startupName: json['startupName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      contactInfo: json['contactInfo'] as String,
      attachments: List<String>.from(json['attachments'] ?? []),
      status: _parseStatus(json['status'] as String),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static ProposalStatus _parseStatus(String status) {
    switch (status) {
      case 'reviewing':
        return ProposalStatus.reviewing;
      case 'approved':
        return ProposalStatus.approved;
      case 'rejected':
        return ProposalStatus.rejected;
      default:
        return ProposalStatus.pending;
    }
  }

  String get statusString {
    switch (status) {
      case ProposalStatus.pending:
        return 'Pending';
      case ProposalStatus.reviewing:
        return 'Under Review';
      case ProposalStatus.approved:
        return 'Approved';
      case ProposalStatus.rejected:
        return 'Rejected';
    }
  }

  ProposalModel copyWith({
    String? id,
    String? startupId,
    String? startupName,
    String? title,
    String? description,
    String? contactInfo,
    List<String>? attachments,
    ProposalStatus? status,
    List<CommentModel>? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProposalModel(
      id: id ?? this.id,
      startupId: startupId ?? this.startupId,
      startupName: startupName ?? this.startupName,
      title: title ?? this.title,
      description: description ?? this.description,
      contactInfo: contactInfo ?? this.contactInfo,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}