import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onAction;
  final String? actionText;
  final Widget? icon;

  const EmptyWidget({
    super.key,
    this.message,
    this.onAction,
    this.actionText,
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
                  Icons.hourglass_empty,
                  color: AppColors.secondary,
                  size: 60,
                ),
            const SizedBox(height: 16),
            Text(
              message ?? 'لا توجد بيانات',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                text: actionText ?? 'تحديث',
                onPressed: onAction!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
