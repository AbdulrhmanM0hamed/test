import 'package:flutter/material.dart';
import '../constant/font_manger.dart';
import '../constant/styles_manger.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isDestructive;
  final bool isLoading;

  const CustomDialogButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? 
          (isDestructive ? const Color.fromARGB(255, 179, 68, 79) : Colors.grey[100]),
        foregroundColor: textColor ?? 
          (isDestructive ? Colors.white : Colors.black87),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: isLoading 
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: textColor ?? (isDestructive ? Colors.white : Colors.black87),
              ),
            ),
    );
  }
} 