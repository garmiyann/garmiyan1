import 'package:flutter/material.dart';
import '../../widgets/data_visualization/data_visualization_widgets.dart';
import '../../../core/core.dart';

class DataVisualizationShowcaseScreen extends StatefulWidget {
  const DataVisualizationShowcaseScreen({super.key});

  @override
  State<DataVisualizationShowcaseScreen> createState() =>
      _DataVisualizationShowcaseScreenState();
}

class _DataVisualizationShowcaseScreenState
    extends State<DataVisualizationShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Visualization Showcase'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Progress Indicators'),
            _buildProgressIndicatorsSection(),
            const SizedBox(height: AppDimensions.spacingXLarge),
            _buildSectionTitle('Metrics Cards'),
            _buildMetricsCardsSection(),
            const SizedBox(height: AppDimensions.spacingXLarge),
            _buildSectionTitle('Charts'),
            _buildChartsSection(),
            const SizedBox(height: AppDimensions.spacingXLarge),
            _buildSectionTitle('Timeline'),
            _buildTimelineSection(),
            const SizedBox(height: AppDimensions.spacingXLarge),
            _buildSectionTitle('Data Table'),
            _buildDataTableSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
      child: Text(
        title,
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressIndicatorsSection() {
    return Column(
      children: [
        // Linear Progress Indicators
        Row(
          children: [
            Expanded(
              child: ProfessionalProgressIndicator(
                value: 0.75,
                type: ProgressType.linear,
                size: ProgressSize.medium,
                label: 'Project Progress',
                showPercentage: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMedium),

        // Circular Progress Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfessionalProgressIndicator(
              value: 0.85,
              type: ProgressType.circular,
              size: ProgressSize.small,
              label: 'CPU',
              showPercentage: true,
            ),
            ProfessionalProgressIndicator(
              value: 0.65,
              type: ProgressType.ring,
              size: ProgressSize.small,
              label: 'Memory',
              showPercentage: true,
              color: AppColors.warning,
            ),
            ProfessionalProgressIndicator(
              value: 0.45,
              type: ProgressType.stepped,
              size: ProgressSize.small,
              label: 'Steps',
              showPercentage: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsCardsSection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppDimensions.spacingMedium,
      mainAxisSpacing: AppDimensions.spacingMedium,
      childAspectRatio: 1.5,
      children: [
        ProfessionalMetricsCard(
          title: 'Total Revenue',
          value: '\$125,430',
          type: MetricsCardType.standard,
          trend: TrendDirection.up,
          trendPercentage: 12.5,
          icon: Icons.attach_money,
        ),
        ProfessionalMetricsCard(
          title: 'Active Users',
          value: '8,492',
          type: MetricsCardType.compact,
          trend: TrendDirection.up,
          trendPercentage: 5.2,
          icon: Icons.people,
          color: AppColors.info,
        ),
        ProfessionalMetricsCard(
          title: 'Conversion Rate',
          value: '3.24%',
          type: MetricsCardType.detailed,
          trend: TrendDirection.down,
          trendPercentage: 0.8,
          subtitle: 'Last 30 days',
          icon: Icons.trending_up,
          color: AppColors.warning,
        ),
        ProfessionalMetricsCard(
          title: 'Server Load',
          value: '76%',
          type: MetricsCardType.hero,
          trend: TrendDirection.up,
          trendPercentage: 2.1,
          subtitle: 'Current usage',
          icon: Icons.dns,
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    final chartData = [
      const ChartData(label: 'Jan', value: 65),
      const ChartData(label: 'Feb', value: 78),
      const ChartData(label: 'Mar', value: 92),
      const ChartData(label: 'Apr', value: 85),
      const ChartData(label: 'May', value: 98),
    ];

    final pieData = [
      ChartData(label: 'Mobile', value: 45, color: AppColors.primary),
      ChartData(label: 'Desktop', value: 35, color: AppColors.secondary),
      ChartData(label: 'Tablet', value: 20, color: AppColors.accent),
    ];

    return Column(
      children: [
        // Bar Chart
        SizedBox(
          height: 300,
          child: ProfessionalChart(
            data: chartData,
            type: ChartType.bar,
            title: 'Monthly Sales',
            subtitle: 'Revenue in thousands',
            style: ChartStyle.standard,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingLarge),

        // Pie and Line Charts
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 250,
                child: ProfessionalChart(
                  data: pieData,
                  type: ChartType.donut,
                  title: 'Device Usage',
                  style: ChartStyle.compact,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(
              child: SizedBox(
                height: 250,
                child: ProfessionalChart(
                  data: chartData,
                  type: ChartType.line,
                  title: 'Growth Trend',
                  style: ChartStyle.compact,
                  showGrid: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    final timelineItems = [
      const TimelineItem(
        title: 'Project Started',
        description: 'Initial project setup and requirements gathering',
        timestamp: '2 weeks ago',
        icon: Icons.play_arrow,
      ),
      const TimelineItem(
        title: 'Development Phase',
        description: 'Core functionality implementation and testing',
        timestamp: '1 week ago',
        icon: Icons.code,
      ),
      const TimelineItem(
        title: 'Review & Testing',
        description: 'Quality assurance and performance optimization',
        timestamp: '3 days ago',
        icon: Icons.bug_report,
      ),
      const TimelineItem(
        title: 'Deployment Ready',
        description: 'Final preparations for production deployment',
        timestamp: 'Today',
        icon: Icons.rocket_launch,
        color: AppColors.success,
      ),
    ];

    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: ProfessionalTimeline(
        items: timelineItems,
        style: TimelineStyle.standard,
      ),
    );
  }

  Widget _buildDataTableSection() {
    final sampleData = List.generate(
        20,
        (index) => {
              'id': index + 1,
              'name': 'User ${index + 1}',
              'email': 'user${index + 1}@example.com',
              'status': index % 3 == 0
                  ? 'Active'
                  : index % 3 == 1
                      ? 'Inactive'
                      : 'Pending',
              'lastLogin': '${2 + index % 10} days ago',
              'score': 65 + (index % 35),
            });

    final columns = [
      DataTableColumn<Map<String, dynamic>>(
        key: 'id',
        label: 'ID',
        value: (item) => item['id'],
        numeric: true,
      ),
      DataTableColumn<Map<String, dynamic>>(
        key: 'name',
        label: 'Name',
        value: (item) => item['name'],
      ),
      DataTableColumn<Map<String, dynamic>>(
        key: 'email',
        label: 'Email',
        value: (item) => item['email'],
      ),
      DataTableColumn<Map<String, dynamic>>(
        key: 'status',
        label: 'Status',
        value: (item) => item['status'],
        cellBuilder: (context, item, value) {
          final status = value.toString();
          Color color = AppColors.textSecondary;
          if (status == 'Active') color = AppColors.success;
          if (status == 'Inactive') color = AppColors.error;
          if (status == 'Pending') color = AppColors.warning;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      DataTableColumn<Map<String, dynamic>>(
        key: 'score',
        label: 'Score',
        value: (item) => item['score'],
        numeric: true,
      ),
    ];

    return Container(
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: ProfessionalDataTable<Map<String, dynamic>>(
        data: sampleData,
        columns: columns,
        sortable: true,
        filterable: true,
        paginated: true,
        itemsPerPage: 8,
        showRowNumbers: true,
        onRowTap: (item) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${item['name']}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
