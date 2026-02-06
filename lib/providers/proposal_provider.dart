import 'package:flutter/material.dart';
import '../models/proposal_model.dart';
import '../data/static_data.dart';

class ProposalProvider extends ChangeNotifier {
  List<ProposalModel> _proposals = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  ProposalStatus? _statusFilter;
  String? _startupFilter;

  List<ProposalModel> get proposals => _filterProposals();
  List<ProposalModel> get allProposals => _proposals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  ProposalStatus? get statusFilter => _statusFilter;
  String? get startupFilter => _startupFilter;

  ProposalProvider() {
    loadProposals();
  }

  List<ProposalModel> _filterProposals() {
    var filtered = List<ProposalModel>.from(_proposals);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.startupName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_statusFilter != null) {
      filtered = filtered.where((p) => p.status == _statusFilter).toList();
    }

    if (_startupFilter != null && _startupFilter!.isNotEmpty) {
      filtered = filtered.where((p) => p.startupId == _startupFilter).toList();
    }

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  List<ProposalModel> getProposalsForStartup(String startupId) {
    return _proposals
        .where((p) => p.startupId == startupId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void loadProposals() {
    _isLoading = true;
    notifyListeners();

    _proposals = List<ProposalModel>.from(StaticData.proposals);
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(ProposalStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setStartupFilter(String? startupId) {
    _startupFilter = startupId;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _startupFilter = null;
    notifyListeners();
  }

  Future<bool> submitProposal({
    required String startupId,
    required String startupName,
    required String title,
    required String description,
    required String contactInfo,
    List<String> attachments = const [],
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final newProposal = ProposalModel(
        id: 'prop_${DateTime.now().millisecondsSinceEpoch}',
        startupId: startupId,
        startupName: startupName,
        title: title,
        description: description,
        contactInfo: contactInfo,
        attachments: attachments,
        status: ProposalStatus.pending,
        comments: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _proposals.insert(0, newProposal);
      StaticData.proposals.insert(0, newProposal);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit proposal';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProposalStatus(
    String proposalId,
    ProposalStatus newStatus, {
    String? comment,
    String? userId,
    String? userName,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _proposals.indexWhere((p) => p.id == proposalId);
      if (index == -1) {
        throw Exception('Proposal not found');
      }

      List<CommentModel> updatedComments =
          List<CommentModel>.from(_proposals[index].comments);

      if (comment != null &&
          comment.isNotEmpty &&
          userId != null &&
          userName != null) {
        updatedComments.add(CommentModel(
          id: 'com_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          userName: userName,
          content: comment,
          createdAt: DateTime.now(),
        ));
      }

      final updatedProposal = _proposals[index].copyWith(
        status: newStatus,
        comments: updatedComments,
        updatedAt: DateTime.now(),
      );

      _proposals[index] = updatedProposal;

      final staticIndex =
          StaticData.proposals.indexWhere((p) => p.id == proposalId);
      if (staticIndex != -1) {
        StaticData.proposals[staticIndex] = updatedProposal;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update proposal status';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  ProposalModel? getProposalById(String id) {
    try {
      return _proposals.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}