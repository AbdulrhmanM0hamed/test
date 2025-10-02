import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test/core/utils/constant/font_manger.dart';
import 'package:test/core/utils/constant/styles_manger.dart';
import 'package:test/core/utils/widgets/custom_snackbar.dart';
import 'package:test/l10n/app_localizations.dart';

class SocialShareSection extends StatelessWidget {
  final String productName;
  final String productSlug;
  final String? productImage;

  const SocialShareSection({
    super.key,
    required this.productName,
    required this.productSlug,
    this.productImage,
  });

  String get _shareUrl => 'https://sobiehcoffee.com/ar/details/$productSlug';

  String get _shareText =>
      'تحقق من هذا المنتج الرائع: $productName\n$_shareUrl';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Text(
            AppLocalizations.of(context)!.shareProduct,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                context: context,
                iconPath: 'assets/images/whatsaap.svg',
                label: 'WhatsApp',
                onTap: () => _shareToWhatsApp(),
              ),
              _buildSocialButton(
                context: context,
                iconPath: 'assets/images/facebook_icon.svg',
                label: 'Facebook',
                onTap: () => _shareToFacebook(),
              ),
              _buildSocialButton(
                context: context,
                iconPath: 'assets/images/xTwitter.svg',
                label: 'X (Twitter)',
                onTap: () => _shareToTwitter(),
              ),
              _buildSocialButton(
                context: context,
                icon: Icons.more_horiz_rounded,
                label: AppLocalizations.of(context)!.more,
                onTap: () => _shareGeneral(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Copy Link Button
          TextButton.icon(
            onPressed: () => _copyLink(context),
            icon: Icon(
              Icons.link_rounded,
              color: Colors.grey[600],
              size: 18,
            ),
            label: Text(
              AppLocalizations.of(context)!.copyLink,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: Colors.grey[600],
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    String? iconPath,
    IconData? icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Center(
              child: iconPath != null
                  ? SvgPicture.asset(iconPath, width: 24, height: 24)
                  : Icon(icon, size: 24, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: getRegularStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _shareToWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(_shareText)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _shareGeneral();
    }
  }

  void _shareToFacebook() async {
    final url = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(_shareUrl)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _shareGeneral();
    }
  }

  void _shareToTwitter() async {
    final url = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(_shareText)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _shareGeneral();
    }
  }

  void _shareGeneral() {
    Share.share(_shareText, subject: productName);
  }

  void _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _shareUrl));

    if (context.mounted) {
      CustomSnackbar.showSuccess(
        context: context,
        message: 'تم نسخ الرابط بنجاح', // Temporary hardcoded text
      );
    }
  }
}
