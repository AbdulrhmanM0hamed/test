import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/di/dependency_injection.dart';
import '../cubit/about_us_cubit.dart';
import '../cubit/about_us_state.dart';

class AboutUsView extends StatelessWidget {
  static const String routeName = '/about-us';

  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) => DependencyInjection.getIt<AboutUsCubit>()..getAboutUs(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: isArabic ? 'حول التطبيق' : 'About Us',
        ),
        body: BlocBuilder<AboutUsCubit, AboutUsState>(
          builder: (context, state) {
            if (state is AboutUsLoading) {
              return const Center(child: CustomProgressIndicator());
            } else if (state is AboutUsError) {
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
                        context.read<AboutUsCubit>().getAboutUs();
                      },
                      child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is AboutUsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AboutUsCubit>().getAboutUs();
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

                      // About Us Content
                      _buildAboutUsContent(context, isArabic, state.aboutUs),

                      const SizedBox(height: 30),

                      // Video Section
                      if (state.aboutUs.videoLink.isNotEmpty)
                        _buildVideoSection(context, isArabic, state.aboutUs.videoLink),

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
          Icon(Icons.info_outline_rounded, size: 40, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'حول التطبيق' : 'About Our App',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'تعرف على المزيد حول تطبيقنا ورؤيتنا'
                : 'Learn more about our app and our vision',
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

  Widget _buildAboutUsContent(BuildContext context, bool isArabic, dynamic aboutUs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'من نحن' : 'Who We Are',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          child: html.Html(
            data: isArabic ? aboutUs.textAr : aboutUs.textEn,
            style: {
              "body": html.Style(
                margin: html.Margins.zero,
                padding: html.HtmlPaddings.zero,
                fontSize: html.FontSize(16),
                fontFamily: FontConstant.cairo,
                color: Colors.grey[700],
                lineHeight: const html.LineHeight(1.6),
              ),
              "p": html.Style(
                margin: html.Margins.zero,
                padding: html.HtmlPaddings.zero,
              ),
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection(BuildContext context, bool isArabic, String videoLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'شاهد الفيديو' : 'Watch Video',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _launchVideo(videoLink),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.1),
                      Colors.red.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'اضغط لمشاهدة الفيديو' : 'Tap to Watch Video',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic ? 'تعرف على المزيد من خلال الفيديو' : 'Learn more through our video',
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchVideo(String videoUrl) async {
    final Uri videoUri = Uri.parse(videoUrl);
    try {
      if (await canLaunchUrl(videoUri)) {
        await launchUrl(videoUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}
