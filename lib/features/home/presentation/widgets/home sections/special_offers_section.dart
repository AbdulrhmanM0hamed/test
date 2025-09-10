import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/widgets/section_header.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../../domain/entities/home_product.dart';
import '../../cubits/special_offer_products/special_offer_products_cubit.dart';
import '../../cubits/special_offer_products/special_offer_products_state.dart';
import '../home_product_card.dart';
import '../home_product_card_shimmer.dart';

class SpecialOffersSection extends StatelessWidget {
  final Function(HomeProduct)? onProductTap;
  final Function(HomeProduct)? onFavoritePressed;
  final VoidCallback? onSeeAll;

  const SpecialOffersSection({
    super.key,
    this.onProductTap,
    this.onFavoritePressed,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // special_offers_section.dart
        SectionHeader(
          onSeeAll: onSeeAll,
          title: AppLocalizations.of(context)!.specialOffers,
          icon: Icons.local_offer,
          iconColor: Colors.red,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
        _buildProductsGrid(),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<SpecialOfferProductsCubit, SpecialOfferProductsState>(
      builder: (context, state) {
        if (state is SpecialOfferProductsLoading) {
          return _buildLoadingGrid();
        }

        if (state is SpecialOfferProductsError) {
          return _buildErrorState(context, state.message);
        }

        if (state is SpecialOfferProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          return SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length > 4 ? 4 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: 170,
                  margin: EdgeInsetsDirectional.only(
                    end:
                        index == (products.length > 4 ? 3 : products.length - 1)
                        ? 0
                        : 12,
                  ),
                  child: HomeProductCard(
                    product: product,
                    onTap: () => onProductTap?.call(product),
                    onFavoritePressed: () => onFavoritePressed?.call(product),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingGrid() {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 12),
            child: const HomeProductCardShimmer(),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.errorLoadingSpecialOffers,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: getRegularStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noSpecialOffersAvailable,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
