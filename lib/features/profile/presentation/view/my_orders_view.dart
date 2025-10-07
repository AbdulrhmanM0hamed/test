import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/features/home/presentation/widgets/login_prompt_widget.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_cubit.dart';
import 'package:test/features/orders/presentation/cubit/orders_cubit/orders_state.dart';
import 'package:test/features/orders/domain/entities/order_actions_helper.dart';
import 'package:test/features/orders/domain/entities/order_item.dart';
import 'package:test/l10n/app_localizations.dart';
import '../widgets/order_card.dart';

class MyOrdersView extends StatelessWidget {
  static const String routeName = '/my-orders';

  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in before creating cubit
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    if (isLoggedIn) {
      return BlocProvider(
        create: (context) =>
            DependencyInjection.getIt<OrdersCubit>()..getMyOrders(),
        child: const MyOrdersViewBody(),
      );
    } else {
      // For guests, show login prompt directly without cubit
      return const MyOrdersViewBody();
    }
  }
}

class MyOrdersViewBody extends StatefulWidget {
  const MyOrdersViewBody({super.key});

  @override
  State<MyOrdersViewBody> createState() => _MyOrdersViewBodyState();
}

class _MyOrdersViewBodyState extends State<MyOrdersViewBody>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  // Filter options
  final List<String> _filterOptions = [
    'all',
    'New',
    'Inprogress',
    'Cancelled',
    'Returned',
    'InprogressReturn',
    'WantTOReturn',
  ];

  String _selectedFilter = 'all';

  // Mapping between Arabic and English status values
  Map<String, String> _getStatusMapping() {
    return {
      'جديد': 'New',
      'جاري العمل عليها': 'Inprogress',
      'تم الالغاء': 'Cancelled',
      'تم الارجاع': 'Returned',
      'جاري الارجاع': 'InprogressReturn',
      'طلب ارجاع': 'WantTOReturn',
    };
  }

  // Get English equivalent of Arabic status
  String _getEnglishStatus(String status) {
    final mapping = _getStatusMapping();
    return mapping[status] ?? status;
  }

  String _getFilterText(BuildContext context, String filter) {
    final isArabic = AppLocalizations.of(context)?.localeName == 'ar';
    switch (filter) {
      case 'all':
        return isArabic ? 'الكل' : 'All';
      case 'New':
        return isArabic ? 'جديد' : 'New';
      case 'Inprogress':
        return isArabic ? 'قيد التنفيذ' : 'In Progress';
      case 'Cancelled':
        return isArabic ? 'ملغي' : 'Cancelled';
      case 'Returned':
        return isArabic ? 'مُرجع' : 'Returned';
      case 'InprogressReturn':
        return isArabic ? 'إرجاع قيد التنفيذ' : 'Return in Progress';
      case 'WantTOReturn':
        return isArabic ? 'يريد الإرجاع' : 'Want to Return';
      default:
        return filter;
    }
  }

  List<OrderItem> _getFilteredOrders(List<OrderItem> orders) {
    if (_selectedFilter == 'all') {
      return orders;
    }

    // Debug: Print filter and order statuses
    print('🔍 Selected Filter: $_selectedFilter');
    print('📋 Available Orders:');
    for (var order in orders) {
      print('   Order ${order.orderNumber}: ${order.status}');
    }

    final filtered = orders.where((order) {
      // Convert Arabic status to English for comparison
      final englishStatus = _getEnglishStatus(order.status);
      print(
        '   🔄 ${order.status} -> $englishStatus (comparing with $_selectedFilter)',
      );
      return englishStatus == _selectedFilter;
    }).toList();

    print('✅ Filtered Orders Count: ${filtered.length}');

    return filtered;
  }

  int _getOrderCountForFilter(List<OrderItem> orders, String filter) {
    if (filter == 'all') {
      return orders.length;
    }
    return orders.where((order) {
      final englishStatus = _getEnglishStatus(order.status);
      return englishStatus == filter;
    }).length;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _tabController = TabController(length: _filterOptions.length, vsync: this);

    // Load orders data
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.myOrders),
      body: isLoggedIn
          ? BlocListener<OrdersCubit, OrdersState>(
        listenWhen: (previous, current) {
          return current is OrderActionSuccess || current is OrderActionError;
        },
        listener: (context, state) {
          if (state is OrderActionSuccess) {
            final isArabic = AppLocalizations.of(context)?.localeName == 'ar';

            // Determine the appropriate success message based on the action type
            String successMessage;
            if (state.message.toLowerCase().contains('cancel') ||
                state.message.contains('إلغاء') ||
                state.message.contains('ألغي')) {
              successMessage = OrderActionsHelper.getCancelSuccessMessage(
                isArabic == true,
              );
            } else if (state.message.toLowerCase().contains('return') ||
                state.message.contains('إرجاع') ||
                state.message.contains('ارجاع')) {
              successMessage = OrderActionsHelper.getReturnSuccessMessage(
                isArabic == true,
              );
            } else {
              // Fallback to server message
              successMessage = state.message;
            }

            CustomSnackbar.showSuccess(
              context: context,
              message: successMessage,
            );
            // Refresh orders list
            context.read<OrdersCubit>().getMyOrders();
          } else if (state is OrderActionError) {
            CustomSnackbar.showError(context: context, message: state.message);
          }
        },
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return _buildLoadingState();
            } else if (state is OrdersEmpty) {
              return _buildEmptyState(context);
            } else if (state is OrdersLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is OrdersError) {
              return _buildErrorState(context, state);
            }
            return _buildInitialState(context);
          },
        ),
      )
          : const LoginPromptWidget(), // Show login prompt for guests
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CustomProgressIndicator());
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noOrdersYet,
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              AppLocalizations.of(context)!.noOrdersMessage,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(
                AppLocalizations.of(context)!.startShopping,
                style: getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, OrdersLoaded state) {
    final filteredOrders = _getFilteredOrders(state.orders);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrdersCubit>().getMyOrders();
      },
      color: AppColors.primary,
      child: Column(
        children: [
          // Header with count
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.01),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.orderHistory,
                        style: getBoldStyle(
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${filteredOrders.length} ${AppLocalizations.of(context)!.totalOrders}',
                        style: getMediumStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[650],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              labelStyle: getMediumStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
              unselectedLabelStyle: getRegularStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
              onTap: (index) {
                setState(() {
                  _selectedFilter = _filterOptions[index];
                  print(
                    '🎯 Tab tapped: index=$index, filter=${_filterOptions[index]}',
                  );
                });
              },
              tabs: _filterOptions.map((filter) {
                final count = _getOrderCountForFilter(state.orders, filter);
                final filterText = _getFilterText(context, filter);
                print('📊 Filter: $filter, Text: $filterText, Count: $count');
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(filterText, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Orders list
          Expanded(
            child: filteredOrders.isEmpty
                ? _buildEmptyFilterState(context)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/order-details',
                            arguments: order.id,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState(BuildContext context) {
    final isArabic = AppLocalizations.of(context)?.localeName == 'ar';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_list_off,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isArabic ? 'لا توجد طلبات' : 'No Orders Found',
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isArabic
                ? 'لا توجد طلبات بهذا التصنيف حالياً'
                : 'No orders found for this filter',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, OrdersError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.error,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<OrdersCubit>().getMyOrders();
            },
            icon: const Icon(Icons.refresh),
            label: Text(
              AppLocalizations.of(context)!.retry,
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    // Trigger the API call when in initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().getMyOrders();
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingOrders,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
