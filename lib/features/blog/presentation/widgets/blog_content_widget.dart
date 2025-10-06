import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:test/core/utils/theme/app_colors.dart';
import '../../domain/entities/blog.dart';

class BlogContentWidget extends StatelessWidget {
  final Blog blog;

  const BlogContentWidget({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta Description (if different from excerpt)
          if (blog.metaDescription.isNotEmpty &&
              blog.metaDescription != blog.getExcerpt()) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Text(
                blog.metaDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Blog Content (HTML)
          LayoutBuilder(
            builder: (context, constraints) {
              return Html(
                data: _cleanHtmlContent(blog.text),
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.6),
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                  "h1": Style(
                    fontSize: FontSize(24),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    margin: Margins.only(top: 24, bottom: 16),
                  ),
                  "h2": Style(
                    fontSize: FontSize(22),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    margin: Margins.only(top: 20, bottom: 12),
                  ),
                  "h3": Style(
                    fontSize: FontSize(20),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    margin: Margins.only(top: 16, bottom: 10),
                  ),
                  "p": Style(
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.6),
                    color: AppColors.textPrimary,
                    margin: Margins.only(bottom: 16),
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  "em": Style(fontStyle: FontStyle.italic),
                  "u": Style(textDecoration: TextDecoration.underline),
                  "a": Style(
                    color: AppColors.primary,
                    textDecoration: TextDecoration.underline,
                  ),
                  "ul": Style(margin: Margins.only(bottom: 16, left: 16)),
                  "ol": Style(margin: Margins.only(bottom: 16, left: 16)),
                  "li": Style(
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.6),
                    color: AppColors.textPrimary,
                    margin: Margins.only(bottom: 8),
                  ),
                  "blockquote": Style(
                    backgroundColor: AppColors.grey.withOpacity(0.1),
                    padding: HtmlPaddings.all(16),
                    margin: Margins.only(bottom: 16),
                    border: Border(
                      left: BorderSide(color: AppColors.primary, width: 4),
                    ),
                    fontStyle: FontStyle.italic,
                    fontSize: FontSize(16),
                    color: AppColors.textSecondary,
                  ),
                  "img": Style(
                    width: Width(
                      constraints.maxWidth - 40,
                    ), // Account for padding
                    margin: Margins.only(bottom: 16),
                  ),
                  "code": Style(
                    backgroundColor: AppColors.grey.withOpacity(0.1),
                    padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 2),
                    fontSize: FontSize(14),
                    fontFamily: 'monospace',
                    color: AppColors.primary,
                  ),
                  "pre": Style(
                    backgroundColor: AppColors.grey.withOpacity(0.1),
                    padding: HtmlPaddings.all(16),
                    margin: Margins.only(bottom: 16),
                    fontSize: FontSize(14),
                    fontFamily: 'monospace',
                    color: AppColors.textPrimary,
                  ),
                },
                onLinkTap: (url, attributes, element) {
                  // Handle link taps
                  if (url != null) {
                    // You can implement custom link handling here
                    debugPrint('Link tapped: $url');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _cleanHtmlContent(String htmlContent) {
    // Clean up HTML content and fix image paths
    String cleaned = htmlContent;

    // Fix relative image paths
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'<img[^>]+src="([^"]*)"[^>]*>', caseSensitive: false),
      (match) {
        String src = match.group(1) ?? '';

        // Convert relative paths to absolute URLs
        if (src.startsWith('/storage/') || src.startsWith('../')) {
          src = 'https://sobiehcoffee.com/sobieh/public$src';
        } else if (src.startsWith('storage/')) {
          src = 'https://sobiehcoffee.com/sobieh/public/$src';
        }

        return match.group(0)!.replaceFirst(match.group(1)!, src);
      },
    );

    // Remove any problematic HTML entities or tags
    cleaned = cleaned.replaceAll('&ndash;', '–');
    cleaned = cleaned.replaceAll('&mdash;', '—');
    cleaned = cleaned.replaceAll('&ldquo;', '"');
    cleaned = cleaned.replaceAll('&rdquo;', '"');
    cleaned = cleaned.replaceAll('&lsquo;', ''');
    cleaned = cleaned.replaceAll('&rsquo;', ''');

    return cleaned;
  }
}
