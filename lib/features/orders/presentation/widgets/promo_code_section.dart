import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/utils/common/custom_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/promo_code_cubit/promo_code_cubit.dart';
import '../../domain/entities/promo_code.dart';

class PromoCodeSection extends StatefulWidget {
  final PromoCode? appliedPromoCode;
  final Function(PromoCode) onPromoCodeApplied;
  final VoidCallback onPromoCodeRemoved;

  const PromoCodeSection({
    super.key,
    required this.appliedPromoCode,
    required this.onPromoCodeApplied,
    required this.onPromoCodeRemoved,
  });

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  final TextEditingController _promoController = TextEditingController();
  final FocusNode _promoFocusNode = FocusNode();

  @override
  void dispose() {
    _promoController.dispose();
    _promoFocusNode.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    if (_promoController.text.trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.pleaseEnterPromoCode,
      );
      return;
    }

    context.read<PromoCodeCubit>().checkPromoCode(_promoController.text.trim());
  }

  void _removePromoCode() {
    setState(() {
      _promoController.clear();
    });
    widget.onPromoCodeRemoved();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.promoCode,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          const SizedBox(height: 16),

          if (widget.appliedPromoCode != null)
            _buildAppliedPromoCode()
          else
            _buildPromoCodeInput(),
        ],
      ),
    );
  }

  Widget _buildAppliedPromoCode() {
    final promoCode = widget.appliedPromoCode!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promoCode.code.toUpperCase(),
                  style: getBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promoCode.type == 'amount'
                      ? '${AppLocalizations.of(context)!.discount} ${promoCode.value.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}'
                      : '${AppLocalizations.of(context)!.discount} ${promoCode.value.toStringAsFixed(0)}%',
                  style: getMediumStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _removePromoCode,
            icon: Icon(Icons.close, color: Colors.green[700], size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return BlocListener<PromoCodeCubit, PromoCodeState>(
      listener: (context, state) {
        if (state is PromoCodeValid) {
          widget.onPromoCodeApplied(state.promoCode);
          CustomSnackbar.showSuccess(
            context: context,
            message: AppLocalizations.of(context)!.promoCodeAppliedSuccessfully,
          );
        } else if (state is PromoCodeError) {
          CustomSnackbar.showError(context: context, message: state.message);
        }
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promoController,
              focusNode: _promoFocusNode,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterPromoCode,
                hintStyle: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[500],
                ),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                prefixIcon: Icon(
                  Icons.local_offer_outlined,
                  color: Colors.grey[500],
                ),
              ),
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              onSubmitted: (_) => _applyPromoCode(),
            ),
          ),
          const SizedBox(width: 12),
          BlocBuilder<PromoCodeCubit, PromoCodeState>(
            builder: (context, state) {
              final isLoading = state is PromoCodeLoading;

              return SizedBox(
                height: 55,
                width: 80,
                child: CustomButton(
                  onPressed: isLoading ? null : _applyPromoCode,
                  text: AppLocalizations.of(context)!.apply,
                  isLoading: isLoading,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
