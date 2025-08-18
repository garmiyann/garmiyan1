import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Bottom Navigation Bar
///
/// Enterprise-level bottom navigation following Material Design 3
/// with proper accessibility and professional styling.
class ProfessionalBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<ProfessionalNavItem> items;
  final bool showLabels;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool enableHaptics;

  const ProfessionalBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.enableHaptics = true,
  });

  @override
  State<ProfessionalBottomNav> createState() => _ProfessionalBottomNavState();
}

class _ProfessionalBottomNavState extends State<ProfessionalBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Animate the current item
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(ProfessionalBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      // Reset old animation
      if (oldWidget.currentIndex < _animationControllers.length) {
        _animationControllers[oldWidget.currentIndex].reverse();
      }

      // Start new animation
      if (widget.currentIndex < _animationControllers.length) {
        _animationControllers[widget.currentIndex].forward();
      }
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
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: widget.elevation ?? 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              widget.items.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = widget.items[index];
    final isSelected = index == widget.currentIndex;

    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: InkWell(
            onTap: () => _handleTap(index),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedItemColor ?? AppColors.primary)
                        .withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with badge
                  Stack(
                    children: [
                      Icon(
                        isSelected ? item.activeIcon ?? item.icon : item.icon,
                        color: isSelected
                            ? (widget.selectedItemColor ?? AppColors.primary)
                            : (widget.unselectedItemColor ??
                                AppColors.textSecondary),
                        size: 24,
                      ),
                      if (item.badge != null) _buildBadge(item.badge!),
                    ],
                  ),

                  // Label
                  if (widget.showLabels) ...[
                    const SizedBox(height: AppDimensions.spacingXSmall),
                    Text(
                      item.label,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? (widget.selectedItemColor ?? AppColors.primary)
                            : (widget.unselectedItemColor ??
                                AppColors.textSecondary),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String badge) {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Text(
          badge,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.onPrimary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (widget.enableHaptics) {
      // TODO: Add haptic feedback
      // HapticFeedback.lightImpact();
    }

    widget.onTap(index);
  }
}

/// Professional Navigation Item Model
class ProfessionalNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badge;
  final String? semanticLabel;

  const ProfessionalNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
    this.semanticLabel,
  });
}
