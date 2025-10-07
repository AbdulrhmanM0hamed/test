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
import 'package:test/l10n/app_localizations.dart';
import 'package:test/features/home/presentation/widgets/login_prompt_widget.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';
import 'notification_details_view.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in before creating cubit
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    if (isLoggedIn) {
      return BlocProvider(
        create: (context) =>
            DependencyInjection.getIt<NotificationsCubit>()..getNotifications(),
        child: const NotificationsViewBody(),
      );
    } else {
      // For guests, show login prompt directly without cubit
      return const NotificationsViewBody();
    }
  }
}

class NotificationsViewBody extends StatelessWidget {
  const NotificationsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final appStateService = DependencyInjection.getIt<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.notifications,
      ),
      body: isLoggedIn
          ? BlocListener<NotificationsCubit, NotificationsState>(
              listener: (context, state) {
                if (state is NotificationsDeletedSuccessfully) {
                  CustomSnackbar.showSuccess(
                    message: state.message,
                    context: context,
                  );
                }
              },
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CustomProgressIndicator());
                  }

                  if (state is NotificationsError) {
                    return _buildErrorState(context, state.message);
                  }

                if (state is NotificationsLoaded) {
                  if (state.notifications.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return _buildNotificationsList(context, state);
                }

                return const SizedBox.shrink();
                },
              ),
            )
          : const LoginPromptWidget(), // Show login prompt for guests
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsLoaded state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsCubit>().refreshNotifications();
      },
      color: AppColors.primary,
      child: Column(
        children: [
          // Header with unread count and delete button
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Unread count section
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.unreadCount > 0
                                ? '${AppLocalizations.of(context)!.youHave} ${state.unreadCount} ${AppLocalizations.of(context)!.unreadNotifications}'
                                : AppLocalizations.of(context)!.noUnreadNotifications,
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Delete all button
                if (state.notifications.isNotEmpty)
                  Expanded(
                    flex: 0,
                    child: ElevatedButton.icon(
                      onPressed: () => _showDeleteConfirmationDialog(context),
                      icon: const Icon(
                        Icons.delete_sweep,
                        size: 18,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.deleteAllNotifications,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailsView(
                          notificationId: notification.id,
                        ),
                      ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noNotifications,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.youHaveNoNotifications,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NotificationsCubit>().refreshNotifications();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.error,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 14,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NotificationsCubit>().getNotifications();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteAllNotifications,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteAllNotificationsConfirmation,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<NotificationsCubit>().deleteAllNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

 }
