import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/l10n/app_localizations.dart';
import '../../domain/entities/product_details.dart';

class ProductVariantSelector extends StatefulWidget {
  final List<ProductSizeColor> variants;
  final ProductSizeColor? selectedVariant;
  final Function(ProductSizeColor) onVariantSelected;

  const ProductVariantSelector({
    super.key,
    required this.variants,
    this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  State<ProductVariantSelector> createState() => _ProductVariantSelectorState();
}

class _ProductVariantSelectorState extends State<ProductVariantSelector> {
  Timer? _countdownTimer;
  Map<int, CountDown> _currentCountdowns = {};

  @override
  void initState() {
    super.initState();
    _initializeCountdowns();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _initializeCountdowns() {
    for (var variant in widget.variants) {
      if (variant.endAt != null && variant.endAt!.isNotEmpty) {
        _currentCountdowns[variant.id] = variant.countDown;
      }
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentCountdowns.forEach((variantId, countdown) {
          if (countdown.seconds > 0) {
            _currentCountdowns[variantId] = CountDown(
              productId: countdown.productId,
              days: countdown.days,
              hours: countdown.hours,
              minutes: countdown.minutes,
              seconds: countdown.seconds - 1,
            );
          } else if (countdown.minutes > 0) {
            _currentCountdowns[variantId] = CountDown(
              productId: countdown.productId,
              days: countdown.days,
              hours: countdown.hours,
              minutes: countdown.minutes - 1,
              seconds: 59,
            );
          } else if (countdown.hours > 0) {
            _currentCountdowns[variantId] = CountDown(
              productId: countdown.productId,
              days: countdown.days,
              hours: countdown.hours - 1,
              minutes: 59,
              seconds: 59,
            );
          } else if (countdown.days > 0) {
            _currentCountdowns[variantId] = CountDown(
              productId: countdown.productId,
              days: countdown.days - 1,
              hours: 23,
              minutes: 59,
              seconds: 59,
            );
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          AppLocalizations.of(context)!.selectVariant,
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Variants List
        ...widget.variants
            .map((variant) => _buildVariantCard(variant))
            .toList(),
      ],
    );
  }

  Widget _buildVariantCard(ProductSizeColor variant) {
    final isSelected = widget.selectedVariant?.id == variant.id;
    final hasOffer = variant.fakePrice != null && variant.fakePrice!.isNotEmpty;
    final hasCountdown = variant.endAt != null && variant.endAt!.isNotEmpty;
    final currentCountdown = _currentCountdowns[variant.id];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => widget.onVariantSelected(variant),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Size/Color Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (variant.size != null && variant.size!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.straighten,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                variant.size!,
                                style: getMediumStyle(
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        if (variant.color != null && variant.color!.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _parseColor(variant.colorCode),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                variant.color!,
                                style: getMediumStyle(
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Selection Indicator
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Price Section
              Row(
                children: [
                  // Real Price
                  Text(
                    '${variant.realPrice} ${AppLocalizations.of(context)!.currency}',
                    style: getBoldStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                      color: hasOffer ? AppColors.primary : Colors.black,
                    ),
                  ),

                  // Fake Price (if offer exists)
                  if (hasOffer) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${variant.fakePrice} ${AppLocalizations.of(context)!.currency}',
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: Colors.grey[500],
                      ).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ],

                  const Spacer(),

                  // Stock Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: variant.countOfAvailable > 0
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${variant.countOfAvailable} ${AppLocalizations.of(context)!.available}',
                      style: getMediumStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: variant.countOfAvailable > 0
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),

              // Discount Badge
              if (hasOffer && variant.discount != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.discount} ${variant.discount}%',
                    style: getBoldStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],

              // Countdown Timer (if offer has countdown)
              if (hasCountdown && currentCountdown != null) ...[
                const SizedBox(height: 12),
                _buildCountdownTimer(currentCountdown),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(CountDown countdown) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.red[700], size: 16),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.offerEndsIn,
                style: getMediumStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(
                countdown.days.toString().padLeft(2, '0'),
                AppLocalizations.of(context)!.day,
              ),
              _buildTimeSeparator(),
              _buildTimeUnit(
                countdown.hours.toString().padLeft(2, '0'),
                AppLocalizations.of(context)!.hour,
              ),
              _buildTimeSeparator(),
              _buildTimeUnit(
                countdown.minutes.toString().padLeft(2, '0'),
                AppLocalizations.of(context)!.minute,
              ),
              _buildTimeSeparator(),
              _buildTimeUnit(
                countdown.seconds.toString().padLeft(2, '0'),
                AppLocalizations.of(context)!.second,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: getBoldStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: getMediumStyle(
            fontSize: FontSize.size10,
            fontFamily: FontConstant.cairo,
            color: Colors.red[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: getBoldStyle(
        fontSize: FontSize.size16,
        fontFamily: FontConstant.cairo,
        color: Colors.red[700],
      ),
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null || colorCode.isEmpty) {
      return Colors.grey[300]!;
    }

    try {
      String hexColor = colorCode.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey[300]!;
    }
  }
}
