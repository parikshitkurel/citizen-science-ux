import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum CustomButtonType { primary, secondary, outlined, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CustomButtonType type;
  final bool fullWidth;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = CustomButtonType.primary,
    this.fullWidth = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );

    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    Widget button;
    switch (type) {
      case CustomButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primaryTeal),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
          child: child,
        );
        break;

      case CustomButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primaryNavy),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
          child: child,
        );
        break;

      case CustomButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            side: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            foregroundColor: AppColors.primaryNavy,
          ),
          child: child,
        );
        break;

      case CustomButtonType.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: const WidgetStatePropertyAll(AppColors.danger),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
          ),
          child: child,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: button,
      );
    }

    return SizedBox(
      height: 48,
      child: button,
    );
  }
}
