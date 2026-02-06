import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../models/proposal_model.dart';
import '../providers/auth_provider.dart';
import '../providers/proposal_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/proposal_card.dart';
import '../widgets/custom_text_field.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  ProposalStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _tabController = TabController(
      length: auth.isOfficial ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Proposals',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedStatus = null;
                          });
                          context.read<ProposalProvider>().clearFilters();
                          _searchController.clear();
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip(
                        'All',
                        _selectedStatus == null,
                        () {
                          setModalState(() => _selectedStatus = null);
                          context.read<ProposalProvider>().setStatusFilter(null);
                        },
                      ),
                      _buildFilterChip(
                        'Pending',
                        _selectedStatus == ProposalStatus.pending,
                        () {
                          setModalState(
                              () => _selectedStatus = ProposalStatus.pending);
                          context
                              .read<ProposalProvider>()
                              .setStatusFilter(ProposalStatus.pending);
                        },
                      ),
                      _buildFilterChip(
                        'Under Review',
                        _selectedStatus == ProposalStatus.reviewing,
                        () {
                          setModalState(
                              () => _selectedStatus = ProposalStatus.reviewing);
                          context
                              .read<ProposalProvider>()
                              .setStatusFilter(ProposalStatus.reviewing);
                        },
                      ),
                      _buildFilterChip(
                        'Approved',
                        _selectedStatus == ProposalStatus.approved,
                        () {
                          setModalState(
                              () => _selectedStatus = ProposalStatus.approved);
                          context
                              .read<ProposalProvider>()
                              .setStatusFilter(ProposalStatus.approved);
                        },
                      ),
                      _buildFilterChip(
                        'Rejected',
                        _selectedStatus == ProposalStatus.rejected,
                        () {
                          setModalState(
                              () => _selectedStatus = ProposalStatus.rejected);
                          context
                              .read<ProposalProvider>()
                              .setStatusFilter(ProposalStatus.rejected);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showProfileMenu() {
    final auth = context.read<AuthProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  auth.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                auth.currentUser?.name ?? 'User',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                auth.currentUser?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  auth.isOfficial ? 'DOIT Official' : 'Startup',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  auth.logout();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final proposals = context.watch<ProposalProvider>();
    final notifications = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DOIT',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  auth.isOfficial ? 'Official Portal' : 'Startup Portal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
              ),
              if (notifications.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${notifications.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          GestureDetector(
            onTap: _showProfileMenu,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  auth.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hint: 'Search proposals...',
                        controller: _searchController,
                        prefixIcon: const Icon(Icons.search),
                        onChanged: (value) {
                          proposals.setSearchQuery(value);
                        },
                      ),
                    ),
                    if (auth.isOfficial) ...[
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: _showFilterBottomSheet,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                if (auth.isOfficial) ...[
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'All Proposals'),
                      Tab(text: 'My Reviews'),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: auth.isOfficial
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProposalList(proposals.proposals),
                      _buildProposalList(proposals.proposals
                          .where((p) =>
                              p.status == ProposalStatus.reviewing ||
                              p.comments.any(
                                  (c) => c.userId == auth.currentUser?.id))
                          .toList()),
                    ],
                  )
                : _buildProposalList(
                    proposals.getProposalsForStartup(auth.currentUser?.id ?? ''),
                  ),
          ),
        ],
      ),
      floatingActionButton: auth.isStartup
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.proposalSubmission);
              },
              icon: const Icon(Icons.add),
              label: const Text('New Proposal'),
            )
          : null,
    );
  }

  Widget _buildProposalList(List<ProposalModel> proposalList) {
    if (proposalList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No proposals found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Proposals will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProposalProvider>().loadProposals();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: proposalList.length,
        itemBuilder: (context, index) {
          final proposal = proposalList[index];
          return ProposalCard(
            proposal: proposal,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.proposalDetail,
                arguments: proposal,
              );
            },
          );
        },
      ),
    );
  }
}