import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Progress Indicator
///
/// Enterprise-level progress indicators with animations,
/// multiple styles, and professional theming.
class ProfessionalProgressIndicator extends StatefulWidget {
  final double value;
  final double? secondaryValue;
  final String? label;
  final String? subtitle;
  final ProgressType type;
  final ProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final bool showPercentage;
  final bool animated;
  final Duration animationDuration;
  final Widget? leading;
  final Widget? trailing;

  const ProfessionalProgressIndicator({
    super.key,
    required this.value,
    this.secondaryValue,
    this.label,
    this.subtitle,
    this.type = ProgressType.linear,
    this.size = ProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.showPercentage = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.leading,
    this.trailing,
  }) : assert(value >= 0.0 && value <= 1.0);

  @override
  State<ProfessionalProgressIndicator> createState() =>
      _ProfessionalProgressIndicatorState();
}

class _ProfessionalProgressIndicatorState
    extends State<ProfessionalProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ProfessionalProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));

      if (widget.animated) {
        _animationController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = widget.animated ? _animation.value : widget.value;

        switch (widget.type) {
          case ProgressType.linear:
            return _buildLinearProgress(currentValue);
          case ProgressType.circular:
            return _buildCircularProgress(currentValue);
          case ProgressType.ring:
            return _buildRingProgress(currentValue);
          case ProgressType.stepped:
            return _buildSteppedProgress(currentValue);
        }
      },
    );
  }

  Widget _buildLinearProgress(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        if (widget.label != null || widget.showPercentage)
          _buildProgressHeader(value),

        if (widget.label != null || widget.showPercentage)
          const SizedBox(height: AppDimensions.spacingSmall),

        // Progress Bar
        Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: AppDimensions.spacingSmall),
            ],
            Expanded(
              child: Container(
                height: _getProgressHeight(),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.surface,
                  borderRadius: BorderRadius.circular(_getProgressHeight() / 2),
                ),
                child: Stack(
                  children: [
                    // Main progress
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: MediaQuery.of(context).size.width * value,
                      height: _getProgressHeight(),
                      decoration: BoxDecoration(
                        color: widget.color ?? AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(_getProgressHeight() / 2),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.color ?? AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    // Secondary progress (if provided)
                    if (widget.secondaryValue != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: MediaQuery.of(context).size.width *
                            widget.secondaryValue!,
                        height: _getProgressHeight(),
                        decoration: BoxDecoration(
                          color: (widget.color ?? AppColors.primary)
                              .withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(_getProgressHeight() / 2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.trailing != null) ...[
              const SizedBox(width: AppDimensions.spacingSmall),
              widget.trailing!,
            ],
          ],
        ),

        // Subtitle
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppDimensions.spacingXSmall),
          Text(
            widget.subtitle!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCircularProgress(double value) {
    final size = _getCircularSize();
    final strokeWidth = _getStrokeWidth();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: strokeWidth,
                color: widget.backgroundColor ?? AppColors.surface,
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                color: widget.color ?? AppColors.primary,
                backgroundColor: Colors.transparent,
              ),
            ),

            // Center content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showPercentage)
                  Text(
                    '${(value * 100).toInt()}%',
                    style: _getCenterTextStyle().copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.color ?? AppColors.primary,
                    ),
                  ),
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: _getCenterTextStyle().copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ],
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(
            widget.subtitle!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildRingProgress(double value) {
    return _buildCircularProgress(
        value); // Similar to circular but with different styling
  }

  Widget _buildSteppedProgress(double value) {
    const totalSteps = 5;
    final completedSteps = (value * totalSteps).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) _buildProgressHeader(value),
        if (widget.label != null)
          const SizedBox(height: AppDimensions.spacingSmall),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < completedSteps;
            return Expanded(
              child: Container(
                margin: index < totalSteps - 1
                    ? const EdgeInsets.only(right: AppDimensions.spacingXSmall)
                    : EdgeInsets.zero,
                height: _getProgressHeight(),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? (widget.color ?? AppColors.primary)
                      : (widget.backgroundColor ?? AppColors.surface),
                  borderRadius: BorderRadius.circular(_getProgressHeight() / 2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProgressHeader(double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.label != null)
          Expanded(
            child: Text(
              widget.label!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (widget.showPercentage)
          Text(
            '${(value * 100).toInt()}%',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.color ?? AppColors.primary,
            ),
          ),
      ],
    );
  }

  double _getProgressHeight() {
    switch (widget.size) {
      case ProgressSize.small:
        return 4.0;
      case ProgressSize.medium:
        return 8.0;
      case ProgressSize.large:
        return 12.0;
    }
  }

  double _getCircularSize() {
    switch (widget.size) {
      case ProgressSize.small:
        return 48.0;
      case ProgressSize.medium:
        return 64.0;
      case ProgressSize.large:
        return 80.0;
    }
  }

  double _getStrokeWidth() {
    switch (widget.size) {
      case ProgressSize.small:
        return 3.0;
      case ProgressSize.medium:
        return 4.0;
      case ProgressSize.large:
        return 6.0;
    }
  }

  TextStyle _getCenterTextStyle() {
    switch (widget.size) {
      case ProgressSize.small:
        return AppTextStyles.caption;
      case ProgressSize.medium:
        return AppTextStyles.bodyMedium;
      case ProgressSize.large:
        return AppTextStyles.bodyLarge;
    }
  }
}

enum ProgressType { linear, circular, ring, stepped }

enum ProgressSize { small, medium, large }
