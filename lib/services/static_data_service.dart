import '../models/user_model.dart';
import '../models/proposal_model.dart';
import '../models/notification_model.dart';

class StaticDataService {
  static final List<UserModel> _users = [
    UserModel(
      id: 'startup_001',
      name: 'TechVentures AI',
      email: 'startup@demo.com',
      role: UserRole.startup,
      companyName: 'TechVentures AI Pvt Ltd',
      profileImageUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=100',
      createdAt: DateTime(2024, 1, 15),
    ),
    UserModel(
      id: 'official_001',
      name: 'Rajesh Kumar',
      email: 'official@demo.com',
      role: UserRole.official,
      profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      createdAt: DateTime(2023, 6, 1),
    ),
  ];

  static final List<ProposalModel> _proposals = [
    ProposalModel(
      id: 'prop_001',
      startupId: 'startup_001',
      startupName: 'TechVentures AI Pvt Ltd',
      title: 'AI-Powered Traffic Management System',
      description: 'A comprehensive AI/ML solution for optimizing traffic flow in urban areas of Rajasthan. The system uses computer vision and deep learning to analyze traffic patterns, predict congestion, and automatically adjust signal timings for optimal flow. This will significantly reduce commute times and fuel consumption across major cities.',
      contactEmail: 'contact@techventures.ai',
      contactPhone: '+91 98765 43210',
      status: ProposalStatus.underReview,
      attachments: ['traffic_proposal.pdf', 'technical_specs.docx'],
      comments: [
        ProposalComment(
          id: 'comment_001',
          authorId: 'official_001',
          authorName: 'Rajesh Kumar',
          content: 'Interesting proposal. Please provide more details on the hardware requirements.',
          createdAt: DateTime(2024, 3, 10),
        ),
      ],
      submittedAt: DateTime(2024, 3, 5),
      updatedAt: DateTime(2024, 3, 10),
      category: 'Smart City',
    ),
    ProposalModel(
      id: 'prop_002',
      startupId: 'startup_002',
      startupName: 'AgriTech Solutions',
      title: 'ML-Based Crop Disease Detection',
      description: 'A mobile application that uses machine learning to detect crop diseases from smartphone images. Farmers can simply take a photo of affected crops, and the app will identify the disease and provide treatment recommendations. This will help reduce crop losses and improve agricultural productivity across Rajasthan.',
      contactEmail: 'info@agritechsol.com',
      contactPhone: '+91 87654 32109',
      status: ProposalStatus.approved,
      attachments: ['agritech_proposal.pdf', 'app_mockups.png'],
      comments: [
        ProposalComment(
          id: 'comment_002',
          authorId: 'official_001',
          authorName: 'Rajesh Kumar',
          content: 'Excellent initiative for farmers. Approved for pilot program.',
          createdAt: DateTime(2024, 2, 28),
        ),
      ],
      submittedAt: DateTime(2024, 2, 20),
      updatedAt: DateTime(2024, 2, 28),
      category: 'Agriculture',
    ),
    ProposalModel(
      id: 'prop_003',
      startupId: 'startup_003',
      startupName: 'HealthAI Labs',
      title: 'AI Diagnostic Assistant for Rural Healthcare',
      description: 'An AI-powered diagnostic tool that assists healthcare workers in rural areas with preliminary disease diagnosis. The system can analyze symptoms and medical history to suggest possible conditions and recommend appropriate tests, helping bridge the gap in healthcare access in remote regions.',
      contactEmail: 'team@healthailabs.in',
      contactPhone: '+91 76543 21098',
      status: ProposalStatus.pending,
      attachments: ['healthai_proposal.pdf'],
      comments: [],
      submittedAt: DateTime(2024, 3, 12),
      category: 'Healthcare',
    ),
    ProposalModel(
      id: 'prop_004',
      startupId: 'startup_004',
      startupName: 'EduML Innovations',
      title: 'Personalized Learning Platform using AI',
      description: 'An adaptive learning platform that uses ML algorithms to personalize educational content for students based on their learning pace, style, and performance. The system will help improve educational outcomes in government schools across the state by providing tailored learning experiences.',
      contactEmail: 'hello@edumlinnovations.com',
      contactPhone: '+91 65432 10987',
      status: ProposalStatus.requiresChanges,
      attachments: ['eduml_proposal.pdf', 'platform_demo.mp4'],
      comments: [
        ProposalComment(
          id: 'comment_003',
          authorId: 'official_001',
          authorName: 'Rajesh Kumar',
          content: 'Please revise the budget section and provide more details on teacher training programs.',
          createdAt: DateTime(2024, 3, 8),
        ),
      ],
      submittedAt: DateTime(2024, 3, 1),
      updatedAt: DateTime(2024, 3, 8),
      category: 'Education',
    ),
    ProposalModel(
      id: 'prop_005',
      startupId: 'startup_005',
      startupName: 'WaterSense Tech',
      title: 'AI Water Quality Monitoring System',
      description: 'A network of IoT sensors combined with AI analysis for real-time water quality monitoring across Rajasthan. The system can detect contamination, predict maintenance needs, and ensure safe drinking water supply for communities.',
      contactEmail: 'support@watersensetech.in',
      contactPhone: '+91 54321 09876',
      status: ProposalStatus.rejected,
      attachments: ['watersense_proposal.pdf'],
      comments: [
        ProposalComment(
          id: 'comment_004',
          authorId: 'official_001',
          authorName: 'Rajesh Kumar',
          content: 'Unfortunately, this project overlaps with an existing government initiative. Please consider collaboration opportunities.',
          createdAt: DateTime(2024, 2, 25),
        ),
      ],
      submittedAt: DateTime(2024, 2, 15),
      updatedAt: DateTime(2024, 2, 25),
      category: 'Water Management',
    ),
    ProposalModel(
      id: 'prop_006',
      startupId: 'startup_001',
      startupName: 'TechVentures AI Pvt Ltd',
      title: 'Smart Parking Solution for Tourist Areas',
      description: 'An AI-based parking management system for tourist destinations in Rajasthan. The system uses computer vision to detect available parking spots and guides visitors through a mobile app, reducing congestion and improving tourist experience.',
      contactEmail: 'contact@techventures.ai',
      contactPhone: '+91 98765 43210',
      status: ProposalStatus.pending,
      attachments: ['parking_proposal.pdf', 'system_architecture.png'],
      comments: [],
      submittedAt: DateTime(2024, 3, 14),
      category: 'Tourism',
    ),
  ];

  static final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_001',
      title: 'Proposal Status Updated',
      description: 'Your proposal "AI-Powered Traffic Management System" is now under review.',
      type: NotificationType.statusUpdate,
      relatedProposalId: 'prop_001',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'New Comment',
      description: 'Rajesh Kumar commented on your proposal.',
      type: NotificationType.newComment,
      relatedProposalId: 'prop_001',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'Proposal Approved',
      description: 'Congratulations! "ML-Based Crop Disease Detection" has been approved.',
      type: NotificationType.statusUpdate,
      relatedProposalId: 'prop_002',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'notif_004',
      title: 'New Proposal Submitted',
      description: 'HealthAI Labs submitted a new proposal for review.',
      type: NotificationType.proposalSubmitted,
      relatedProposalId: 'prop_003',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'System Maintenance',
      description: 'Scheduled maintenance on March 20th from 2:00 AM to 4:00 AM IST.',
      type: NotificationType.systemAlert,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static UserModel? authenticateUser(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static bool emailExists(String email) {
    return _users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  static UserModel getOfficialUser() {
    return _users.firstWhere((user) => user.role == UserRole.official);
  }

  static UserModel getStartupUser() {
    return _users.firstWhere((user) => user.role == UserRole.startup);
  }

  static List<ProposalModel> getAllProposals() {
    return List.from(_proposals);
  }

  static List<ProposalModel> getProposalsByStartup(String startupId) {
    return _proposals.where((p) => p.startupId == startupId).toList();
  }

  static ProposalModel? getProposalById(String proposalId) {
    try {
      return _proposals.firstWhere((p) => p.id == proposalId);
    } catch (e) {
      return null;
    }
  }

  static List<NotificationModel> getNotifications() {
    return List.from(_notifications);
  }

  static List<String> getCategories() {
    return [
      'Smart City',
      'Agriculture',
      'Healthcare',
      'Education',
      'Tourism',
      'Water Management',
      'Environment',
      'Transportation',
      'Finance',
      'Other',
    ];
  }
}
