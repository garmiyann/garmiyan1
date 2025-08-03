import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Button Widget
///
/// Enterprise-level button component with consistent styling,
/// accessibility features, haptic feedback, and advanced animations
/// following Material Design 3 and WCAG accessibility guidelines.
class ProfessionalButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool enableHaptics;
  final bool enablePulseAnimation;
  final Color? customColor;
  final Duration animationDuration;
  final String? tooltip;
  final String? semanticLabel;

  const ProfessionalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptics = true,
    this.enablePulseAnimation = false,
    this.customColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.tooltip,
    this.semanticLabel,
  });

  @override
  State<ProfessionalButton> createState() => _ProfessionalButtonState();
}

class _ProfessionalButtonState extends State<ProfessionalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.enablePulseAnimation) {
      _startPulseAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startPulseAnimation() {
    _animationController.repeat(reverse: true);
  }

  void _stopPulseAnimation() {
    _animationController.stop();
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Widget button = _buildButton(context, isEnabled);

    // Add tooltip if provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    // Add semantic label for accessibility
    button = Semantics(
      label: widget.semanticLabel ?? widget.text,
      button: true,
      enabled: isEnabled,
      child: button,
    );

    // Add animation wrapper
    button = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = widget.enablePulseAnimation
            ? _pulseAnimation.value
            : _scaleAnimation.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: button,
    );

    if (widget.isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(BuildContext context, bool isEnabled) {
    switch (widget.type) {
      case ButtonType.primary:
        return _buildElevatedButton(context, isEnabled);
      case ButtonType.secondary:
        return _buildOutlinedButton(context, isEnabled);
      case ButtonType.text:
        return _buildTextButton(context, isEnabled);
      case ButtonType.icon:
        return _buildIconButton(context, isEnabled);
    }
  }

  Widget _buildElevatedButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? _handlePress : null,
      style: ElevatedButton.styleFrom(
        padding: _getPadding(),
        backgroundColor: widget.customColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? _handlePress : null,
      style: OutlinedButton.styleFrom(
        padding: _getPadding(),
        side: widget.customColor != null
            ? BorderSide(color: widget.customColor!)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? _handlePress : null,
      style: TextButton.styleFrom(
        padding: _getPadding(),
        foregroundColor: widget.customColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildIconButton(BuildContext context, bool isEnabled) {
    return IconButton(
      onPressed: isEnabled ? _handlePress : null,
      style: IconButton.styleFrom(
        padding: _getPadding(),
        foregroundColor: widget.customColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
      icon: _buildButtonContent(),
    );
  }

  void _handlePress() {
    // Add haptic feedback if enabled
    if (widget.enableHaptics) {
      // TODO: Add haptic feedback
      // HapticFeedback.lightImpact();
    }

    // Trigger press animation
    if (!widget.enablePulseAnimation) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }

    // Call the actual onPressed callback
    widget.onPressed?.call();
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.type == ButtonType.primary
                ? AppColors.onPrimary
                : AppColors.primary,
          ),
        ),
      );
    }

    if (widget.icon != null && widget.type != ButtonType.icon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: _getIconSize()),
          const SizedBox(width: AppDimensions.spacingSmall),
          Text(widget.text, style: _getTextStyle()),
        ],
      );
    }

    if (widget.type == ButtonType.icon && widget.icon != null) {
      return Icon(widget.icon, size: _getIconSize());
    }

    return Text(widget.text, style: _getTextStyle());
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingMedium,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXLarge,
          vertical: AppDimensions.paddingLarge,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600);
      case ButtonSize.medium:
        return AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600);
      case ButtonSize.large:
        return AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600);
    }
  }
}

enum ButtonType { primary, secondary, text, icon }

enum ButtonSize { small, medium, large }
