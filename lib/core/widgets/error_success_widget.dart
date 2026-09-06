import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

enum MessageType { error, success, warning }

class MessageBanner extends StatelessWidget {
  final String message;
  final MessageType type;

  const MessageBanner({
    super.key,
    required this.message,
    this.type = MessageType.error,
  });

  Color get _backgroundColor {
    switch (type) {
      case MessageType.error:
        return AppColors.error.withValues(alpha: 0.1);
      case MessageType.success:
        return AppColors.success.withValues(alpha: 0.1);
      case MessageType.warning:
        return AppColors.warning.withValues(alpha: 0.1);
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case MessageType.error:
        return AppColors.error;
      case MessageType.success:
        return AppColors.success;
      case MessageType.warning:
        return AppColors.warning;
    }
  }

  IconData get _icon {
    switch (type) {
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.success:
        return Icons.check_circle_outline;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: _foregroundColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _foregroundColor, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: _foregroundColor),
            ),
          ),
        ],
      ),
    );
  }
}


void showAppSnackBar(
  BuildContext context, {
  required String message,
  MessageType type = MessageType.error,
}) {
  final color = type == MessageType.error
      ? AppColors.error
      : type == MessageType.success
          ? AppColors.success
          : AppColors.warning;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    ),
  );
}