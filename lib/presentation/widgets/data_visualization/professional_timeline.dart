import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Timeline Widget
///
/// Enterprise-level timeline component for displaying chronological
/// events with professional styling and animations.
class ProfessionalTimeline extends StatefulWidget {
  final List<TimelineItem> items;
  final TimelineStyle style;
  final bool showAnimation;
  final Duration animationDuration;
  final ScrollController? scrollController;

  const ProfessionalTimeline({
    super.key,
    required this.items,
    this.style = TimelineStyle.standard,
    this.showAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.scrollController,
  });

  @override
  State<ProfessionalTimeline> createState() => _ProfessionalTimelineState();
}

class _ProfessionalTimelineState extends State<ProfessionalTimeline>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    if (widget.showAnimation) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: widget.showAnimation
                  ? _fadeAnimations[index]
                  : const AlwaysStoppedAnimation(1.0),
              child: SlideTransition(
                position: widget.showAnimation
                    ? _slideAnimations[index]
                    : const AlwaysStoppedAnimation(Offset.zero),
                child: _buildTimelineItem(index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimelineItem(int index) {
    final item = widget.items[index];
    final isLast = index == widget.items.length - 1;

    switch (widget.style) {
      case TimelineStyle.standard:
        return _buildStandardTimelineItem(item, isLast);
      case TimelineStyle.compact:
        return _buildCompactTimelineItem(item, isLast);
      case TimelineStyle.detailed:
        return _buildDetailedTimelineItem(item, isLast);
    }
  }

  Widget _buildStandardTimelineItem(TimelineItem item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.color ?? AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
            ],
          ),

          const SizedBox(width: AppDimensions.spacingMedium),

          // Content
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: AppDimensions.spacingLarge),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              color: item.color ?? AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppDimensions.spacingSmall),
                          ],
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.timestamp != null)
                            Text(
                              item.timestamp!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),

                      if (item.description != null) ...[
                        const SizedBox(height: AppDimensions.spacingSmall),
                        Text(
                          item.description!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],

                      if (item.customWidget != null) ...[
                        const SizedBox(height: AppDimensions.spacingMedium),
                        item.customWidget!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTimelineItem(TimelineItem item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color ?? AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
            ],
          ),

          const SizedBox(width: AppDimensions.spacingMedium),

          // Content
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (item.timestamp != null)
                        Text(
                          item.timestamp!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: AppDimensions.spacingXSmall),
                    Text(
                      item.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTimelineItem(TimelineItem item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator with enhanced styling
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: item.color ?? AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (item.color ?? AppColors.primary).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: item.icon != null
                    ? Icon(
                        item.icon,
                        color: AppColors.onPrimary,
                        size: 8,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (item.color ?? AppColors.primary).withOpacity(0.5),
                          AppColors.textSecondary.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: AppDimensions.spacingLarge),

          // Enhanced content
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: AppDimensions.spacingXLarge),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLarge),
                    gradient: LinearGradient(
                      colors: [
                        (item.color ?? AppColors.primary).withOpacity(0.05),
                        (item.color ?? AppColors.primary).withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced header
                      Row(
                        children: [
                          if (item.icon != null) ...[
                            Container(
                              padding: const EdgeInsets.all(
                                  AppDimensions.paddingSmall),
                              decoration: BoxDecoration(
                                color: (item.color ?? AppColors.primary)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium),
                              ),
                              child: Icon(
                                item.icon,
                                color: item.color ?? AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingMedium),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.timestamp != null)
                                  Text(
                                    item.timestamp!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (item.description != null) ...[
                        const SizedBox(height: AppDimensions.spacingMedium),
                        Text(
                          item.description!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],

                      if (item.customWidget != null) ...[
                        const SizedBox(height: AppDimensions.spacingMedium),
                        item.customWidget!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Timeline Item Model
class TimelineItem {
  final String title;
  final String? description;
  final String? timestamp;
  final IconData? icon;
  final Color? color;
  final Widget? customWidget;

  const TimelineItem({
    required this.title,
    this.description,
    this.timestamp,
    this.icon,
    this.color,
    this.customWidget,
  });
}

enum TimelineStyle { standard, compact, detailed }
