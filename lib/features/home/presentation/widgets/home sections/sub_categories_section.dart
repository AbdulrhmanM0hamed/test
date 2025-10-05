import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/widgets/section_header.dart';
import '../../../../../core/utils/responsive/responsive_helper.dart';
import '../../../../../features/home/domain/entities/home_product.dart';
import '../../../../../features/home/domain/entities/sub_category.dart';
import '../../../../../features/home/presentation/cubits/sub_categories/sub_categories_cubit.dart';
import '../../../../../features/home/presentation/cubits/sub_categories/sub_categories_state.dart';
import '../../../../../features/home/presentation/widgets/home_product_card.dart';

class SubCategoriesSection extends StatelessWidget {
  final Function(HomeProduct) onProductTap;
  final Function(HomeProduct) onFavoritePressed;
  final Function(SubCategory) onSeeAll;
  const SubCategoriesSection({
    super.key,
    required this.onProductTap,
    required this.onFavoritePressed,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoriesCubit, SubCategoriesState>(
      builder: (context, state) {
        if (state is SubCategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SubCategoriesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is SubCategoriesLoaded) {
          return Column(
            children: state.subCategories.map((subCategory) {
              return _buildSubCategorySection(context, subCategory);
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubCategorySection(
    BuildContext context,
    SubCategory subCategory,
  ) {
    if (subCategory.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final products = subCategory.products;

    return Column(
      children: [
        const SizedBox(height: 24),
        SectionHeader(title: subCategory.name, icon: Icons.category),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: ResponsiveHelper.getResponsivePadding(context),
            itemCount: products.length > 6 ? 6 : products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: ResponsiveHelper.getHorizontalItemWidth(context),
                margin: EdgeInsetsDirectional.only(
                  end: index == (products.length > 6 ? 6 : products.length - 1)
                      ? 0
                      : ResponsiveHelper.getHorizontalItemMargin(context),
                ),
                child: HomeProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
