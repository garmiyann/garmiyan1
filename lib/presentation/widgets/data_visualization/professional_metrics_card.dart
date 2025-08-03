import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Metrics Card
///
/// Enterprise-level metrics display with trend indicators,
/// animations, and professional styling for dashboards.
class ProfessionalMetricsCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? previousValue;
  final IconData? icon;
  final Color? color;
  final MetricsCardType type;
  final TrendDirection? trend;
  final double? trendPercentage;
  final VoidCallback? onTap;
  final bool showAnimation;
  final Widget? customWidget;

  const ProfessionalMetricsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.previousValue,
    this.icon,
    this.color,
    this.type = MetricsCardType.standard,
    this.trend,
    this.trendPercentage,
    this.onTap,
    this.showAnimation = true,
    this.customWidget,
  });

  @override
  State<ProfessionalMetricsCard> createState() =>
      _ProfessionalMetricsCardState();
}

class _ProfessionalMetricsCardState extends State<ProfessionalMetricsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.showAnimation) {
      _animationController.forward();
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
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.showAnimation ? _slideAnimation.value : 0),
          child: Opacity(
            opacity: widget.showAnimation ? _fadeAnimation.value : 1.0,
            child: _buildCard(),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    switch (widget.type) {
      case MetricsCardType.standard:
        return _buildStandardCard();
      case MetricsCardType.compact:
        return _buildCompactCard();
      case MetricsCardType.detailed:
        return _buildDetailedCard();
      case MetricsCardType.hero:
        return _buildHeroCard();
    }
  }

  Widget _buildStandardCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            gradient: widget.color != null
                ? LinearGradient(
                    colors: [
                      widget.color!.withOpacity(0.05),
                      widget.color!.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.icon != null)
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                      decoration: BoxDecoration(
                        color: (widget.color ?? AppColors.primary)
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color ?? AppColors.primary,
                        size: 20,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingMedium),

              // Value
              Text(
                widget.value,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: widget.color ?? AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Trend and subtitle
              if (widget.trend != null || widget.subtitle != null) ...[
                const SizedBox(height: AppDimensions.spacingSmall),
                Row(
                  children: [
                    if (widget.trend != null) _buildTrendIndicator(),
                    if (widget.trend != null && widget.subtitle != null)
                      const SizedBox(width: AppDimensions.spacingSmall),
                    if (widget.subtitle != null)
                      Expanded(
                        child: Text(
                          widget.subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.color ?? AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spacingMedium),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      widget.value,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: widget.color ?? AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.trend != null) _buildTrendIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Container(
                      padding:
                          const EdgeInsets.all(AppDimensions.paddingMedium),
                      decoration: BoxDecoration(
                        color: (widget.color ?? AppColors.primary)
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color ?? AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMedium),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Main value
              Text(
                widget.value,
                style: AppTextStyles.displaySmall.copyWith(
                  color: widget.color ?? AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Trend and comparison
              if (widget.trend != null || widget.previousValue != null) ...[
                const SizedBox(height: AppDimensions.spacingMedium),
                Row(
                  children: [
                    if (widget.trend != null) _buildTrendIndicator(),
                    if (widget.trend != null && widget.previousValue != null)
                      const SizedBox(width: AppDimensions.spacingMedium),
                    if (widget.previousValue != null)
                      Text(
                        'Previous: ${widget.previousValue}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ],

              // Custom widget
              if (widget.customWidget != null) ...[
                const SizedBox(height: AppDimensions.spacingMedium),
                widget.customWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            gradient: LinearGradient(
              colors: [
                widget.color ?? AppColors.primary,
                (widget.color ?? AppColors.primary).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and title
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Container(
                      padding:
                          const EdgeInsets.all(AppDimensions.paddingMedium),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMedium),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingXLarge),

              // Main value
              Text(
                widget.value,
                style: AppTextStyles.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Subtitle and trend
              if (widget.subtitle != null || widget.trend != null) ...[
                const SizedBox(height: AppDimensions.spacingMedium),
                Row(
                  children: [
                    if (widget.subtitle != null)
                      Expanded(
                        child: Text(
                          widget.subtitle!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    if (widget.trend != null)
                      _buildTrendIndicator(isHero: true),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator({bool isHero = false}) {
    final color = isHero ? Colors.white : _getTrendColor();
    final backgroundColor =
        isHero ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: AppDimensions.paddingXSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTrendIcon(),
            color: color,
            size: 16,
          ),
          if (widget.trendPercentage != null) ...[
            const SizedBox(width: AppDimensions.spacingXSmall),
            Text(
              '${widget.trendPercentage!.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTrendColor() {
    switch (widget.trend!) {
      case TrendDirection.up:
        return AppColors.success;
      case TrendDirection.down:
        return AppColors.error;
      case TrendDirection.neutral:
        return AppColors.warning;
    }
  }

  IconData _getTrendIcon() {
    switch (widget.trend!) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.neutral:
        return Icons.trending_flat;
    }
  }
}

enum MetricsCardType { standard, compact, detailed, hero }

enum TrendDirection { up, down, neutral }
