import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/features/auth/data/models/terms_and_conditions_model.dart';
import 'package:test/features/auth/data/services/terms_service.dart';
import 'package:test/l10n/app_localizations.dart';

class TermsAndConditionsView extends StatefulWidget {
  static const String routeName = '/terms-and-conditions';

  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  final TermsService _termsService = DependencyInjection.getIt<TermsService>();
  TermsAndConditionsModel? _terms;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTermsAndConditions();
  }

  Future<void> _loadTermsAndConditions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _termsService.getTermsAndConditions();

      setState(() {
        _terms = response.data.isNotEmpty ? response.data.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.termsAndConditions,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CustomProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل الشروط والأحكام',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTermsAndConditions,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'إعادة المحاولة',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_terms == null) {
      return Center(
        child: Text(
          'لا توجد شروط وأحكام متاحة',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _terms!.text,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // HTML Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Directionality(
              textDirection:
                  Localizations.localeOf(context).languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: html.Html(
                data: _terms!.body,
                style: {
                  "body": html.Style(
                    fontFamily: FontConstant.cairo,
                    fontSize: html.FontSize(14),
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.justify,
                    direction:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  "p": html.Style(
                    fontFamily: FontConstant.cairo,
                    fontSize: html.FontSize(14),
                    color: AppColors.textPrimary,
                    margin: html.Margins.only(bottom: 12),
                    textAlign: TextAlign.justify,
                    direction:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  "strong": html.Style(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  "ul": html.Style(
                    margin: Localizations.localeOf(context).languageCode == 'ar'
                        ? html.Margins.only(right: 16, bottom: 12)
                        : html.Margins.only(left: 16, bottom: 12),
                  ),
                  "li": html.Style(
                    fontFamily: FontConstant.cairo,
                    fontSize: html.FontSize(14),
                    color: AppColors.textPrimary,
                    margin: html.Margins.only(bottom: 8),
                    textAlign: TextAlign.justify,
                    direction:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  "a": html.Style(
                    color: AppColors.primary,
                    textDecoration: TextDecoration.underline,
                  ),
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
