import 'package:flutter/material.dart';
import '../models/proposal_model.dart';
import '../services/static_data_service.dart';

class ProposalController extends ChangeNotifier {
  ProposalModel? _selectedProposal;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  List<String> _uploadedFiles = [];

  ProposalModel? get selectedProposal => _selectedProposal;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  List<String> get uploadedFiles => _uploadedFiles;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadProposal(String proposalId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _selectedProposal = StaticDataService.getProposalById(proposalId);
    if (_selectedProposal == null) {
      _errorMessage = 'Proposal not found';
    }

    _isLoading = false;
    notifyListeners();
  }

  void addFile(String fileName) {
    _uploadedFiles.add(fileName);
    notifyListeners();
  }

  void removeFile(String fileName) {
    _uploadedFiles.remove(fileName);
    notifyListeners();
  }

  void clearFiles() {
    _uploadedFiles.clear();
    notifyListeners();
  }

  Future<ProposalModel?> submitProposal({
    required String startupId,
    required String startupName,
    required String title,
    required String description,
    required String contactEmail,
    required String contactPhone,
    String? category,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final newProposal = ProposalModel(
      id: 'proposal_${DateTime.now().millisecondsSinceEpoch}',
      startupId: startupId,
      startupName: startupName,
      title: title,
      description: description,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      status: ProposalStatus.pending,
      attachments: List.from(_uploadedFiles),
      comments: [],
      submittedAt: DateTime.now(),
      category: category,
    );

    _uploadedFiles.clear();
    _isSubmitting = false;
    notifyListeners();

    return newProposal;
  }

  Future<bool> updateProposalStatus(
    String proposalId,
    ProposalStatus newStatus, {
    String? comment,
    String? authorId,
    String? authorName,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (_selectedProposal != null && _selectedProposal!.id == proposalId) {
      List<ProposalComment> updatedComments = List.from(_selectedProposal!.comments);

      if (comment != null && comment.isNotEmpty) {
        updatedComments.add(ProposalComment(
          id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
          authorId: authorId ?? 'official',
          authorName: authorName ?? 'DOIT Official',
          content: comment,
          createdAt: DateTime.now(),
        ));
      }

      _selectedProposal = _selectedProposal!.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        comments: updatedComments,
      );
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void clearSelectedProposal() {
    _selectedProposal = null;
    _errorMessage = null;
    notifyListeners();
  }
}
