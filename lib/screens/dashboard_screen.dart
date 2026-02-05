import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/notification_controller.dart';
import '../models/proposal_model.dart';
import '../utils/constants.dart';
import '../widgets/proposal_card.dart';
import '../widgets/loading_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final authController = context.read<AuthController>();
    final dashboardController = context.read<DashboardController>();
    final notificationController = context.read<NotificationController>();

    dashboardController.loadProposals(
      userId: authController.currentUser?.id,
      isOfficial: authController.isOfficial,
    );
    notificationController.loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthController>().logout();
              context.go(AppRoutes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final isOfficial = authController.isOfficial;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(context, authController),
      body: Column(
        children: [
          _buildSearchAndFilter(context, isOfficial),
          if (isOfficial) _buildTabs(context),
          Expanded(
            child: _buildProposalsList(context, isOfficial),
          ),
        ],
      ),
      floatingActionButton: !isOfficial
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.proposalSubmission),
              icon: const Icon(Icons.add),
              label: const Text('New Proposal'),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 1, end: 0)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AuthController authController) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                authController.isOfficial ? 'Official Dashboard' : 'Startup Dashboard',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<NotificationController>(
          builder: (context, notifController, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
                if (notifController.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${notifController.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        PopupMenuButton<String>(
          icon: CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              authController.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authController.currentUser?.name ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        authController.currentUser?.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20, color: AppTheme.errorColor),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.logout,
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'logout') {
              _handleLogout();
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, bool isOfficial) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<DashboardController>().setSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search proposals...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              context.read<DashboardController>().setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              if (isOfficial) ...[  
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _showFilters ? AppTheme.primaryColor : AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: _showFilters ? Colors.white : AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                      });
                    },
                  ),
                ),
              ],
            ],
          ),
          if (_showFilters && isOfficial) ...[  
            const SizedBox(height: 16),
            _buildFilterSection(context),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildFilterSection(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ProposalStatus?>(
                    value: controller.statusFilter,
                    isExpanded: true,
                    hint: const Text('Status'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Status'),
                      ),
                      ...ProposalStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.displayName),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.setStatusFilter(value);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton.icon(
              onPressed: () {
                controller.clearFilters();
                _searchController.clear();
              },
              icon: const Icon(Icons.clear_all, size: 20),
              label: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'All Proposals'),
          Tab(text: 'Pending Review'),
        ],
        onTap: (index) {
          final controller = context.read<DashboardController>();
          if (index == 1) {
            controller.setStatusFilter(ProposalStatus.pending);
          } else {
            controller.setStatusFilter(null);
          }
        },
      ),
    );
  }

  Widget _buildProposalsList(BuildContext context, bool isOfficial) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingIndicator(message: 'Loading proposals...');
        }

        if (controller.filteredProposals.isEmpty) {
          return EmptyState(
            icon: Icons.description_outlined,
            title: 'No Proposals Found',
            subtitle: controller.searchQuery.isNotEmpty || controller.statusFilter != null
                ? 'Try adjusting your search or filters'
                : isOfficial
                    ? 'No proposals have been submitted yet'
                    : 'Start by submitting your first proposal',
            action: !isOfficial && controller.searchQuery.isEmpty && controller.statusFilter == null
                ? ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.proposalSubmission),
                    icon: const Icon(Icons.add),
                    label: const Text('Submit Proposal'),
                  )
                : null,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadProposals(
              userId: context.read<AuthController>().currentUser?.id,
              isOfficial: isOfficial,
            );
          },
          color: AppTheme.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredProposals.length,
            itemBuilder: (context, index) {
              final proposal = controller.filteredProposals[index];
              return ProposalCard(
                proposal: proposal,
                showStartupName: isOfficial,
                onTap: () {
                  context.push('${AppRoutes.proposalDetail}/${proposal.id}');
                },
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.1, end: 0);
            },
          ),
        );
      },
    );
  }
}
