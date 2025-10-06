import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';
import 'package:test/core/utils/common/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'data/models/contact_info_model.dart';
import 'presentation/cubit/contact_us_cubit.dart';
import 'presentation/cubit/contact_us_state.dart';

class ContactUsView extends StatelessWidget {
  static const String routeName = '/contact-us';

  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (context) =>
          DependencyInjection.getIt<ContactUsCubit>()..getContactInfo(),
      child: Scaffold(
        appBar: CustomAppBar(title: isArabic ? 'تواصل معنا' : 'Contact Us'),
        body: BlocBuilder<ContactUsCubit, ContactUsState>(
          builder: (context, state) {
            if (state is ContactUsLoading) {
              return const Center(child: CustomProgressIndicator());
            } else if (state is ContactUsError) {
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
                        context.read<ContactUsCubit>().getContactInfo();
                      },
                      child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ContactUsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderSection(context, isArabic),

                    const SizedBox(height: 30),

                    // Contact Information Cards
                    _buildContactInfoSection(
                      context,
                      isArabic,
                      state.contactInfo,
                    ),

                    const SizedBox(height: 30),

                    // Social Media Section
                    _buildSocialMediaSection(
                      context,
                      isArabic,
                      state.contactInfo,
                    ),

                    const SizedBox(height: 30),

                    // Map Section
                    _buildMapSection(context, isArabic, state.contactInfo),

                    const SizedBox(height: 20),
                  ],
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
          Icon(Icons.support_agent_rounded, size: 40, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'نحن هنا لمساعدتك' : 'We\'re Here to Help',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'تواصل معنا في أي وقت وسنكون سعداء للرد على استفساراتك'
                : 'Contact us anytime and we\'ll be happy to answer your questions',
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

  Widget _buildContactInfoSection(
    BuildContext context,
    bool isArabic,
    ContactInfoModel contactInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'معلومات التواصل' : 'Contact Information',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        // Phone Numbers
        _buildContactCard(
          icon: Icons.phone_rounded,
          title: isArabic ? 'أرقام الهاتف' : 'Phone Numbers',
          subtitle: '${contactInfo.phone1} • ${contactInfo.phone2}',
          onTap: () => _launchPhone(contactInfo.phone1),
          color: Colors.green,
        ),

        const SizedBox(height: 12),

        // Email
        _buildContactCard(
          icon: Icons.email_rounded,
          title: isArabic ? 'البريد الإلكتروني' : 'Email',
          subtitle: contactInfo.email,
          onTap: () => _launchEmail(contactInfo.email),
          color: Colors.blue,
        ),

        const SizedBox(height: 12),

        // Address
        _buildContactCard(
          icon: Icons.location_on_rounded,
          title: isArabic ? 'العنوان' : 'Address',
          subtitle: contactInfo.address,
          onTap: () => _launchUrl(contactInfo.map),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(
    BuildContext context,
    bool isArabic,
    ContactInfoModel contactInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'تابعنا على' : 'Follow Us',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon(
                'assets/images/facebook_icon.svg',
                contactInfo.facebook,
                const Color(0xFF1877F2),
              ),
              _buildSocialIcon(
                'assets/images/instgram.svg',
                contactInfo.instagram,
                const Color(0xFFE4405F),
              ),
              _buildSocialIcon(
                'assets/images/linkedIn.svg',
                contactInfo.linkedin,
                const Color(0xFF0A66C2),
              ),
              _buildSocialIcon(
                'assets/images/xTwitter.svg',
                contactInfo.x,
                Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, String url, Color color) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(assetPath, width: 28, height: 28),
      ),
    );
  }

  Widget _buildMapSection(
    BuildContext context,
    bool isArabic,
    ContactInfoModel contactInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'موقعنا على الخريطة' : 'Our Location',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),

        Container(
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
              onTap: () => _launchUrl(contactInfo.map),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 50, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'اضغط لفتح الخريطة' : 'Tap to Open Map',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contactInfo.address,
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

  // Launch Methods
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}
