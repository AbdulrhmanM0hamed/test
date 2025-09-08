import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? retryText;
  final Widget? icon;

  const CustomErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.retryText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 60,
                ),
            const SizedBox(height: 16),
            Text(
              message ?? 'حدث خطأ ما',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                text: retryText ?? 'إعادة المحاولة',
                onPressed: onRetry!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
