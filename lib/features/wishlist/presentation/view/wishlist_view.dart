import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_button.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:test/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:test/features/home/presentation/view/bottom_nav_bar.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';

class WishlistView extends StatefulWidget {
  static const String routeName = '/wishlist';

  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Load wishlist data will be handled by BlocProvider
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.favorite,
          style: getBoldStyle(
            fontSize: FontSize.size20,
            fontFamily: FontConstant.cairo,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              if (state is WishlistLoaded &&
                  state.wishlistResponse.wishlist.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_sweep, color: Colors.red, size: 24),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: AppLocalizations.of(context)!.clearAll,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocConsumer<WishlistCubit, WishlistState>(
          listener: (context, state) {
            if (state is WishlistItemAdded) {
              CustomSnackbar.showSuccess(
                context: context,
                message: state.message,
              );
            } else if (state is WishlistItemRemoved) {
              CustomSnackbar.showWarning(
                context: context,
                message: state.message,
              );
            } else if (state is WishlistCleared) {
              CustomSnackbar.showSuccess(
                context: context,
                message: state.message,
              );
            } else if (state is WishlistError) {
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is WishlistLoading) {
              return _buildLoadingState();
            } else if (state is WishlistEmpty) {
              return _buildEmptyState(context);
            } else if (state is WishlistLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is WishlistError) {
              return _buildErrorState(context, state);
            }
            return _buildInitialState(context);
          },
        ),
      ),
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
              Icons.favorite_border,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.wishlistEmpty,
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
              AppLocalizations.of(context)!.wishlistEmptyDescription,
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
            child: CustomButton(
              onPressed: () {
                // Navigate to home tab using static method
                BottomNavBar.navigateToHome();
              },
              text: AppLocalizations.of(context)!.browseProducts,
              backgroundColor: AppColors.primary,
              height: 56,
              prefix: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, WishlistLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WishlistCubit>().getMyWishlist();
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
                  AppColors.primary.withValues(alpha: 0.05),
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
                    Icons.favorite,
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
                        AppLocalizations.of(context)!.addProductsToWishlist,
                        style: getBoldStyle(
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${state.wishlistResponse.count} ${AppLocalizations.of(context)!.productsInWishlist}',
                        style: getMediumStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Wishlist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: state.wishlistResponse.wishlist.length,
              itemBuilder: (context, index) {
                final item = state.wishlistResponse.wishlist[index];
                return WishlistItemCard(
                  item: item,
                  onTap: () {
                    // TODO: Navigate to product details
                    ////print('Navigate to product: ${item.product.id}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WishlistError state) {
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
              context.read<WishlistCubit>().getMyWishlist();
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
      context.read<WishlistCubit>().getMyWishlist();
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingWishlist,
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

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.confirmDeletion,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.confirmDeletion,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<WishlistCubit>().removeAllFromWishlist();
              },
              child: Text(
                AppLocalizations.of(context)!.deleteAll,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
