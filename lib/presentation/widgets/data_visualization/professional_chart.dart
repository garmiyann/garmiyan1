import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Charts Widget
///
/// Enterprise-level chart component supporting multiple chart types
/// with professional styling and animations.
class ProfessionalChart extends StatefulWidget {
  final List<ChartData> data;
  final ChartType type;
  final ChartStyle style;
  final String? title;
  final String? subtitle;
  final bool showAnimation;
  final Duration animationDuration;
  final bool showLegend;
  final bool showGrid;
  final Color? primaryColor;

  const ProfessionalChart({
    super.key,
    required this.data,
    required this.type,
    this.style = ChartStyle.standard,
    this.title,
    this.subtitle,
    this.showAnimation = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showLegend = true,
    this.showGrid = true,
    this.primaryColor,
  });

  @override
  State<ProfessionalChart> createState() => _ProfessionalChartState();
}

class _ProfessionalChartState extends State<ProfessionalChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

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
    return Card(
      elevation: widget.style == ChartStyle.elevated ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.style == ChartStyle.compact
              ? AppDimensions.radiusMedium
              : AppDimensions.radiusLarge,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          widget.style == ChartStyle.compact
              ? AppDimensions.paddingMedium
              : AppDimensions.paddingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null || widget.subtitle != null) _buildHeader(),
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return _buildChart();
                },
              ),
            ),
            if (widget.showLegend && widget.data.length > 1) _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: widget.style == ChartStyle.compact
                  ? AppTextStyles.headlineSmall
                  : AppTextStyles.headlineMedium,
            ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: AppDimensions.spacingXSmall),
            Text(
              widget.subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (widget.type) {
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.donut:
        return _buildDonutChart();
    }
  }

  Widget _buildBarChart() {
    final maxValue =
        widget.data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.data.asMap().entries.map((entry) {
              final data = entry.value;
              final heightRatio = data.value / maxValue;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Value label
                      if (widget.style != ChartStyle.compact)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            data.value.toStringAsFixed(0),
                            style: AppTextStyles.caption,
                          ),
                        ),

                      // Bar
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            height: widget.showAnimation
                                ? heightRatio * 200 * _animation.value
                                : heightRatio * 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: data.color != null
                                    ? [
                                        data.color!,
                                        data.color!.withOpacity(0.7)
                                      ]
                                    : [
                                        widget.primaryColor ??
                                            AppColors.primary,
                                        (widget.primaryColor ??
                                                AppColors.primary)
                                            .withOpacity(0.7),
                                      ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppDimensions.radiusSmall),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Label
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data.label,
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: LineChartPainter(
        data: widget.data,
        animation: _animation,
        primaryColor: widget.primaryColor ?? AppColors.primary,
        showGrid: widget.showGrid,
      ),
    );
  }

  Widget _buildPieChart() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: PieChartPainter(
        data: widget.data,
        animation: _animation,
        primaryColor: widget.primaryColor ?? AppColors.primary,
      ),
    );
  }

  Widget _buildDonutChart() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: DonutChartPainter(
        data: widget.data,
        animation: _animation,
        primaryColor: widget.primaryColor ?? AppColors.primary,
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacingMedium),
      child: Wrap(
        spacing: AppDimensions.spacingMedium,
        runSpacing: AppDimensions.spacingSmall,
        children: widget.data.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final color = data.color ??
              _getColorForIndex(
                  index, widget.primaryColor ?? AppColors.primary);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingXSmall),
              Text(
                data.label,
                style: AppTextStyles.caption,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getColorForIndex(int index, Color baseColor) {
    final colors = [
      baseColor,
      baseColor.withOpacity(0.8),
      baseColor.withOpacity(0.6),
      baseColor.withOpacity(0.4),
      baseColor.withOpacity(0.2),
    ];
    return colors[index % colors.length];
  }
}

/// Line Chart Painter
class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Animation<double> animation;
  final Color primaryColor;
  final bool showGrid;

  LineChartPainter({
    required this.data,
    required this.animation,
    required this.primaryColor,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    if (showGrid) {
      _drawGrid(canvas, size);
    }

    if (data.isEmpty) return;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw animated line
    final pathMetric = path.computeMetrics().first;
    final animatedPath = pathMetric.extractPath(
      0,
      pathMetric.length * animation.value,
    );

    canvas.drawPath(animatedPath, paint);

    // Draw points
    for (int i = 0; i < data.length; i++) {
      if (i / data.length <= animation.value) {
        final x = (i / (data.length - 1)) * size.width;
        final y = size.height - (data[i].value / maxValue) * size.height;
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    // Horizontal lines
    for (int i = 0; i <= 5; i++) {
      final y = (i / 5) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical lines
    for (int i = 0; i <= 5; i++) {
      final x = (i / 5) * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Pie Chart Painter
class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Animation<double> animation;
  final Color primaryColor;

  PieChartPainter({
    required this.data,
    required this.animation,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final total = data.map((e) => e.value).reduce((a, b) => a + b);
    double startAngle = -90 * (3.14159 / 180);

    for (int i = 0; i < data.length; i++) {
      final sweepAngle =
          (data[i].value / total) * 2 * 3.14159 * animation.value;
      final color = data[i].color ?? _getColorForIndex(i, primaryColor);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  Color _getColorForIndex(int index, Color baseColor) {
    final colors = [
      baseColor,
      baseColor.withOpacity(0.8),
      baseColor.withOpacity(0.6),
      baseColor.withOpacity(0.4),
      baseColor.withOpacity(0.2),
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Animation<double> animation;
  final Color primaryColor;

  DonutChartPainter({
    required this.data,
    required this.animation,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 10;
    final innerRadius = outerRadius * 0.6;

    final total = data.map((e) => e.value).reduce((a, b) => a + b);
    double startAngle = -90 * (3.14159 / 180);

    for (int i = 0; i < data.length; i++) {
      final sweepAngle =
          (data[i].value / total) * 2 * 3.14159 * animation.value;
      final color = data[i].color ?? _getColorForIndex(i, primaryColor);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path()
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);
      startAngle += sweepAngle;
    }
  }

  Color _getColorForIndex(int index, Color baseColor) {
    final colors = [
      baseColor,
      baseColor.withOpacity(0.8),
      baseColor.withOpacity(0.6),
      baseColor.withOpacity(0.4),
      baseColor.withOpacity(0.2),
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Chart Data Model
class ChartData {
  final String label;
  final double value;
  final Color? color;

  const ChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

enum ChartType { bar, line, pie, donut }

enum ChartStyle { standard, compact, elevated }
