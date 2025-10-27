import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderExpenseChart extends StatelessWidget {
  final List<dynamic> orders;
  final String title;
  final String subtitle;

  const OrderExpenseChart({
    super.key,
    required this.orders,
    this.title = 'Expense Flow',
    this.subtitle = 'Last twenty orders',
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _generateChartData(orders);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.sm),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net Spend
          Text(
            'Net Spend',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            'GHS ${_calculateTotal(orders).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.md),
          
          // Chart
          SizedBox(
            height: 100,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                isVisible: false,
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
              ),
              series: <CartesianSeries<ChartData, String>>[
                SplineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: TColors.primary,
                  width: 2,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TSizes.xs),
          Text(
            title.toLowerCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            subtitle.toLowerCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  List<ChartData> _generateChartData(List orders) {
    final data = <ChartData>[];
    final limitedOrders = orders.take(20).toList();
    
    for (int i = 0; i < limitedOrders.length; i++) {
      final order = limitedOrders[i];
      double orderTotal = 0.0;
      
      // Calculate order total
      if (order is Map<String, dynamic>) {
        if (order.containsKey('products') && order['products'] is List) {
          orderTotal = (order['products'] as List).fold<double>(
            0.0,
            (sum, p) => sum + ((p['price'] ?? 0.0) * (p['cartQuantity'] ?? 1)),
          );
        } else if (order.containsKey('price')) {
          orderTotal = (order['price'] ?? 0.0).toDouble();
        }
      }
      
      data.add(ChartData('$i', orderTotal));
    }
    
    // If no data, add dummy data
    if (data.isEmpty) {
      for (int i = 0; i < 5; i++) {
        data.add(ChartData('$i', 0.0));
      }
    }
    
    return data;
  }

  double _calculateTotal(List orders) {
    return orders.fold<double>(
      0.0,
      (sum, order) {
        if (order is Map<String, dynamic>) {
          if (order.containsKey('products') && order['products'] is List) {
            return sum +
                (order['products'] as List).fold<double>(
                  0.0,
                  (pSum, p) => pSum + ((p['price'] ?? 0.0) * (p['cartQuantity'] ?? 1)),
                );
          } else if (order.containsKey('price')) {
            return sum + (order['price'] ?? 0.0).toDouble();
          }
        }
        return sum;
      },
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
