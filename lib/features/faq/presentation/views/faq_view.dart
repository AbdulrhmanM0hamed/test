import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/di/dependency_injection.dart';
import '../cubit/faq_cubit.dart';
import '../cubit/faq_state.dart';

class FAQView extends StatelessWidget {
  static const String routeName = '/faq';

  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => DependencyInjection.getIt<FAQCubit>()..getFAQs(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: isArabic ? 'الأسئلة الشائعة' : 'Frequently Asked Questions',
        ),
        body: BlocBuilder<FAQCubit, FAQState>(
          builder: (context, state) {
            if (state is FAQLoading) {
              return const Center(child: CustomProgressIndicator());
            } else if (state is FAQError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: Colors.red[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FAQCubit>().getFAQs();
                      },
                      child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is FAQLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FAQCubit>().getFAQs();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(context, isArabic),

                      const SizedBox(height: 30),

                      // FAQ List
                      _buildFAQList(context, isArabic, state.faqs),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline_rounded, size: 40, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'الأسئلة الشائعة' : 'Frequently Asked Questions',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'إجابات على أكثر الأسئلة شيوعاً حول منتجاتنا وخدماتنا'
                : 'Answers to the most common questions about our products and services',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(BuildContext context, bool isArabic, List faqs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الأسئلة والأجوبة' : 'Questions & Answers',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return _buildFAQItem(context, faq, isArabic);
          },
        ),
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, dynamic faq, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.help_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            faq.question,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: Colors.grey[800],
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: Colors.grey[600],
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: html.Html(
                data: faq.answer,
                style: {
                  "body": html.Style(
                    margin: html.Margins.zero,
                    padding: html.HtmlPaddings.zero,
                    fontSize: html.FontSize(14),
                    fontFamily: FontConstant.cairo,
                    color: Colors.grey[700],
                    lineHeight: const html.LineHeight(1.5),
                  ),
                  "p": html.Style(
                    margin: html.Margins.zero,
                    padding: html.HtmlPaddings.zero,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
