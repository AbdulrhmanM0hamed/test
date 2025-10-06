import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test/core/utils/theme/app_colors.dart';

class BlogDetailsShimmer extends StatelessWidget {
  const BlogDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blog Image Shimmer
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Shimmer.fromColors(
              baseColor: AppColors.grey.withValues(alpha: 0.1),
              highlightColor: AppColors.grey.withValues(alpha: 0.2),
              child: Container(width: double.infinity, color: Colors.white),
            ),
          ),

          // Blog Header Info Shimmer
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.1),
                  highlightColor: AppColors.grey.withValues(alpha: 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 24,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Meta Info Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.1),
                  highlightColor: AppColors.grey.withValues(alpha: 0.2),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 8,
                    children: List.generate(4, (index) {
                      return Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // Keywords Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.1),
                  highlightColor: AppColors.grey.withValues(alpha: 0.2),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (index) {
                      return Container(
                        height: 28,
                        width: 60 + (index * 20).toDouble(),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.grey.withValues(alpha: 0.2),
          ),

          // Content Shimmer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Shimmer.fromColors(
              baseColor: AppColors.grey.withValues(alpha: 0.1),
              highlightColor: AppColors.grey.withValues(alpha: 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content lines
                  ...List.generate(8, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        height: 16,
                        width: index == 7
                            ? MediaQuery.of(context).size.width * 0.6
                            : double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Paragraph break
                  ...List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        height: 16,
                        width: index == 5
                            ? MediaQuery.of(context).size.width * 0.4
                            : double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Comments Section Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comments Header Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.grey.withValues(alpha: 0.1),
                  highlightColor: AppColors.grey.withValues(alpha: 0.2),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Comment Items Shimmer
                ...List.generate(2, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.grey.withValues(alpha: 0.1),
                      highlightColor: AppColors.grey.withValues(alpha: 0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Comment Header
                          Row(
                            children: [
                              // Avatar
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // User Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 12,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Comment Content
                          ...List.generate(2, (lineIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                height: 14,
                                width: lineIndex == 1
                                    ? MediaQuery.of(context).size.width * 0.6
                                    : double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Add Comment Shimmer
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer.fromColors(
              baseColor: AppColors.grey.withValues(alpha: 0.1),
              highlightColor: AppColors.grey.withValues(alpha: 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add Comment Header
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Comment Input
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
