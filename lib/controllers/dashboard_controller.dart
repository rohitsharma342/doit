import 'package:flutter/material.dart';
import '../models/proposal_model.dart';
import '../services/static_data_service.dart';

class DashboardController extends ChangeNotifier {
  List<ProposalModel> _allProposals = [];
  List<ProposalModel> _filteredProposals = [];
  String _searchQuery = '';
  ProposalStatus? _statusFilter;
  String? _startupFilter;
  bool _isLoading = false;
  int _currentTabIndex = 0;

  List<ProposalModel> get allProposals => _allProposals;
  List<ProposalModel> get filteredProposals => _filteredProposals;
  String get searchQuery => _searchQuery;
  ProposalStatus? get statusFilter => _statusFilter;
  String? get startupFilter => _startupFilter;
  bool get isLoading => _isLoading;
  int get currentTabIndex => _currentTabIndex;

  Future<void> loadProposals({String? userId, bool isOfficial = false}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (isOfficial) {
      _allProposals = StaticDataService.getAllProposals();
    } else if (userId != null) {
      _allProposals = StaticDataService.getProposalsByStartup(userId);
    } else {
      _allProposals = StaticDataService.getAllProposals();
    }

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setStatusFilter(ProposalStatus? status) {
    _statusFilter = status;
    _applyFilters();
  }

  void setStartupFilter(String? startup) {
    _startupFilter = startup;
    _applyFilters();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _startupFilter = null;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProposals = _allProposals.where((proposal) {
      final matchesSearch = _searchQuery.isEmpty ||
          proposal.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          proposal.startupName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          proposal.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _statusFilter == null || proposal.status == _statusFilter;

      final matchesStartup = _startupFilter == null ||
          _startupFilter!.isEmpty ||
          proposal.startupName.toLowerCase().contains(_startupFilter!.toLowerCase());

      return matchesSearch && matchesStatus && matchesStartup;
    }).toList();

    _filteredProposals.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    notifyListeners();
  }

  List<String> get uniqueStartupNames {
    return _allProposals.map((p) => p.startupName).toSet().toList();
  }

  void addProposal(ProposalModel proposal) {
    _allProposals.insert(0, proposal);
    _applyFilters();
  }

  void updateProposalStatus(String proposalId, ProposalStatus newStatus) {
    final index = _allProposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      _allProposals[index] = _allProposals[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      _applyFilters();
    }
  }
}
