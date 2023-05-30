import 'package:cash_flow/providers/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatelessWidget {

  const BarChartWidget({super.key});

  List<ChartData> getChartData() {
    // Return your chart data here
    return [
      ChartData('Investment', 20),
      ChartData('Deposit', 30),
      ChartData('Lent', 40),
    ];
  }

  List<double> calculatePercentages(List<int> amountList) {
    final total = amountList.reduce((a, b) => a + b);
    return amountList.map((amount) => (amount / total) * 100).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Item> _items = Provider.of<AssetsProvider>(context, listen: false).totalAmount;



    // _items = [
    //   ChartData('Investment', 20),
    //   ChartData('Deposit', 30),
    //   ChartData('Lent', 40),
    // ]
    return SfCartesianChart(
      title: ChartTitle(text: "Assets Graph", alignment: ChartAlignment.center),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
        minorGridLines: MinorGridLines(width: 0, ),
        borderWidth: 0,
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
          minorGridLines: MinorGridLines(width: 0),
          title: AxisTitle(text: "Amount"),
          borderWidth: 0,
          isVisible: true
      ),
      palette: const [ Colors.purple],
      series: <ChartSeries>[
        BarSeries<Item, String>(
          dataSource: _items.reversed.toList(),
          xValueMapper: (Item data, _) => data.name,
          yValueMapper: (Item data, _) => data.amount,
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
