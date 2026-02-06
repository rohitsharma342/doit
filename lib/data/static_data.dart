import '../models/user_model.dart';
import '../models/proposal_model.dart';
import '../models/notification_model.dart';

class StaticData {
  static final List<UserModel> users = [
    UserModel(
      id: 'user_001',
      name: 'TechVision AI',
      email: 'startup@techvision.com',
      role: UserRole.startup,
      profileImage: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=150',
      createdAt: DateTime(2024, 1, 15),
    ),
    UserModel(
      id: 'user_002',
      name: 'Rajesh Kumar',
      email: 'official@doit.raj.gov.in',
      role: UserRole.official,
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      createdAt: DateTime(2023, 6, 1),
    ),
  ];

  static final List<ProposalModel> proposals = [
    ProposalModel(
      id: 'prop_001',
      startupId: 'user_001',
      startupName: 'TechVision AI',
      title: 'AI-Powered Crop Disease Detection System',
      description: 'A mobile application leveraging deep learning and computer vision to identify crop diseases in real-time. The system uses a trained CNN model to analyze leaf images captured by farmers and provides instant diagnosis along with treatment recommendations. This solution aims to reduce crop losses by 30% and improve agricultural productivity across Rajasthan.',
      contactInfo: 'contact@techvision.com | +91-9876543210',
      attachments: ['proposal_document.pdf', 'technical_specs.pdf'],
      status: ProposalStatus.reviewing,
      comments: [
        CommentModel(
          id: 'com_001',
          userId: 'user_002',
          userName: 'Rajesh Kumar',
          content: 'Interesting proposal. Please provide more details on the dataset used for training.',
          createdAt: DateTime(2024, 12, 1),
        ),
      ],
      createdAt: DateTime(2024, 11, 20),
      updatedAt: DateTime(2024, 12, 1),
    ),
    ProposalModel(
      id: 'prop_002',
      startupId: 'user_003',
      startupName: 'DataMind Solutions',
      title: 'Predictive Analytics for Smart City Traffic Management',
      description: 'An ML-based traffic prediction and management system for Jaipur Smart City initiative. The solution integrates with existing traffic infrastructure to provide real-time congestion predictions, optimize signal timings, and suggest alternative routes to commuters through a mobile app.',
      contactInfo: 'info@datamind.in | +91-9988776655',
      attachments: ['business_plan.pdf'],
      status: ProposalStatus.pending,
      comments: [],
      createdAt: DateTime(2024, 12, 5),
      updatedAt: DateTime(2024, 12, 5),
    ),
    ProposalModel(
      id: 'prop_003',
      startupId: 'user_004',
      startupName: 'HealthTech Innovations',
      title: 'AI Diagnostic Assistant for Rural Healthcare',
      description: 'A telemedicine platform with integrated AI diagnostic capabilities designed for primary healthcare centers in rural Rajasthan. The system helps healthcare workers make preliminary diagnoses using symptom analysis and medical imaging interpretation powered by machine learning models.',
      contactInfo: 'support@healthtech.in | +91-9123456789',
      attachments: ['project_overview.pdf', 'pilot_results.pdf', 'team_profile.pdf'],
      status: ProposalStatus.approved,
      comments: [
        CommentModel(
          id: 'com_002',
          userId: 'user_002',
          userName: 'Rajesh Kumar',
          content: 'Excellent proposal with strong potential for social impact. Approved for Phase 1 funding.',
          createdAt: DateTime(2024, 11, 25),
        ),
      ],
      createdAt: DateTime(2024, 10, 15),
      updatedAt: DateTime(2024, 11, 25),
    ),
    ProposalModel(
      id: 'prop_004',
      startupId: 'user_005',
      startupName: 'EduAI Labs',
      title: 'Personalized Learning Platform using NLP',
      description: 'An adaptive learning platform that uses Natural Language Processing to understand student queries, assess knowledge gaps, and provide personalized educational content. The platform supports multiple Indian languages including Hindi and Rajasthani.',
      contactInfo: 'hello@eduailabs.com | +91-8765432109',
      attachments: ['pitch_deck.pdf'],
      status: ProposalStatus.rejected,
      comments: [
        CommentModel(
          id: 'com_003',
          userId: 'user_002',
          userName: 'Rajesh Kumar',
          content: 'The proposal lacks technical depth and clear implementation timeline. Please resubmit with detailed specifications.',
          createdAt: DateTime(2024, 11, 10),
        ),
      ],
      createdAt: DateTime(2024, 10, 28),
      updatedAt: DateTime(2024, 11, 10),
    ),
    ProposalModel(
      id: 'prop_005',
      startupId: 'user_001',
      startupName: 'TechVision AI',
      title: 'Automated Document Processing for Government Services',
      description: 'An intelligent document processing system that uses OCR and NLP to automate the extraction and validation of information from government documents. This will significantly reduce processing time for citizen services and improve accuracy.',
      contactInfo: 'contact@techvision.com | +91-9876543210',
      attachments: ['solution_architecture.pdf', 'demo_video.mp4'],
      status: ProposalStatus.pending,
      comments: [],
      createdAt: DateTime(2024, 12, 10),
      updatedAt: DateTime(2024, 12, 10),
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_001',
      title: 'Proposal Under Review',
      description: 'Your proposal "AI-Powered Crop Disease Detection System" is now being reviewed by DOIT officials.',
      proposalId: 'prop_001',
      timestamp: DateTime(2024, 12, 1, 10, 30),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_002',
      title: 'New Comment Added',
      description: 'Rajesh Kumar commented on your proposal regarding dataset details.',
      proposalId: 'prop_001',
      timestamp: DateTime(2024, 12, 1, 14, 45),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_003',
      title: 'Proposal Approved',
      description: 'Congratulations! "AI Diagnostic Assistant for Rural Healthcare" has been approved for Phase 1 funding.',
      proposalId: 'prop_003',
      timestamp: DateTime(2024, 11, 25, 16, 0),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_004',
      title: 'Submission Received',
      description: 'Your proposal "Automated Document Processing for Government Services" has been successfully submitted.',
      proposalId: 'prop_005',
      timestamp: DateTime(2024, 12, 10, 9, 15),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_005',
      title: 'New Proposal Submitted',
      description: 'DataMind Solutions submitted a new proposal for traffic management system.',
      proposalId: 'prop_002',
      timestamp: DateTime(2024, 12, 5, 11, 0),
      isRead: false,
    ),
  ];
}