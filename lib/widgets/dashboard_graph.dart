import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';


// class DashboardGraphWidget extends StatelessWidget {
//    DashboardGraphWidget({Key? key}) : super(key: key);
//
//
//   late  List<ChartData> chartData = <ChartData>[];
//   final List<ChartData> chartDataReset = <ChartData>[
//     ChartData(date: 1,income: 0, expense:0),
//     ChartData(date: 2,income: 0, expense: 0),
//     ChartData(date: 3,income: 0, expense: 0),
//     ChartData(date: 4,income: 0, expense: 0),
//     ChartData(date: 5,income: 0, expense: 0),
//     ChartData(date: 6,income: 0, expense: 0),
//     ChartData(date: 7,income: 0, expense: 0),
//     ChartData(date: 8,income: 0, expense: 0),
//     ChartData(date: 9,income: 0, expense: 0),
//     ChartData(date: 10,income: 0, expense: 0),
//     ChartData(date: 11,income: 0, expense: 0),
//     ChartData(date: 12,income: 0, expense: 0),
//     ChartData(date: 13,income: 0, expense: 0),
//     ChartData(date: 14,income: 0, expense: 0),
//     ChartData(date: 15,income: 0, expense: 0),
//     ChartData(date: 16,income: 0, expense: 0),
//     ChartData(date: 17,income: 0, expense: 0),
//     ChartData(date: 18,income: 0, expense: 0),
//     ChartData(date: 19,income: 0, expense: 0),
//     ChartData(date: 20,income: 0, expense: 0),
//     ChartData(date: 21,income: 0, expense: 0),
//     ChartData(date: 22,income: 0, expense:0),
//     ChartData(date: 23,income: 0, expense:0),
//     ChartData(date: 24,income: 0, expense:0),
//     ChartData(date: 25,income: 0, expense:0),
//     ChartData(date: 26,income: 0, expense:0),
//     ChartData(date: 27,income: 0, expense:0),
//     ChartData(date: 28,income: 0, expense:0),
//     ChartData(date: 29,income: 0, expense:0),
//     ChartData(date: 30,income: 0, expense:0),
//     ChartData(date: 31,income: 0, expense:0),];
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<ChartData> updatedChartData = List<ChartData>.from(chartDataReset);
//
//     List<IncomeType> incomeItems = Provider.of<IncomeProvider>(context, listen: false).items;
//     List<ExpenseType> expenseItems = Provider.of<ExpenseProvider>(context, listen: false).items;
//
//     for (var e in incomeItems) {
//       updatedChartData[e.dateTime.day -1].income += e.amount ;
//     }
//
//     for (var e in expenseItems) {
//       updatedChartData[e.dateTime.day -1].expense += e.amount ;
//     }
//
//
//
//
//     return SfCartesianChart (
//       title: ChartTitle(text: "                          Income Expense Graph", alignment: ChartAlignment.near),
//       borderWidth: 5,
//       legend: Legend(isVisible: true, position: LegendPosition.bottom),
//       plotAreaBackgroundColor: Colors.transparent,
//       plotAreaBorderColor :  Colors.grey.shade200,
//       plotAreaBorderWidth: 2,
//       borderColor: Colors.grey.shade200,
//       backgroundColor: Colors.transparent,
//       primaryXAxis: CategoryAxis(
//         // autoScrollingDelta: 12,
//         // autoScrollingMode: AutoScrollingMode.end,
//         // labelPlacement: LabelPlacement.onTicks,
//         labelRotation: 45,
//
//         majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
//         minorGridLines: MinorGridLines(width: 0, ),
//         title: AxisTitle(text: "                                Date",alignment: ChartAlignment.near),
//         borderWidth: 0,
//       ),
//       primaryYAxis: NumericAxis(
//         majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
//         minorGridLines: MinorGridLines(width: 0),
//         title: AxisTitle(text: "Amount"),
//         borderWidth: 0,
//         isVisible: true
//       ),
//       // palette: const [ Colors.purple, Colors.deepPurpleAccent],
//       // series: <ChartSeries>[
//       //   SplineAreaSeries<ChartData, int>(
//       //       name: "Income",
//       //       dataSource: updatedChartData,
//       //       xValueMapper: (ChartData data, _) => data.date,
//       //       yValueMapper: (ChartData data, _) => data.income,
//       //
//       //   ),
//       //   SplineAreaSeries<ChartData, int>(
//       //       name: "Expense",
//       //       dataSource: updatedChartData,
//       //       xValueMapper: (ChartData data, _) => data.date,
//       //       yValueMapper: (ChartData data, _) => data.expense
//       //   ),
//       //
//       //
//       // ],
//       series: <BarSeries>[
//
//
//         // SplineSeries(dataSource: updatedChartData,, xValueMapper: xValueMapper, yValueMapper: yValueMapper)
//
//         BarSeries<ChartData, int>(
//           name: "Income",
//           dataSource: updatedChartData,
//           xValueMapper: (ChartData data, _) => data.date,
//           yValueMapper: (ChartData data, _) => data.income,
//
//         ),
//         BarSeries<ChartData, int>(
//             name: "Expense",
//             dataSource: updatedChartData,
//             xValueMapper: (ChartData data, _) => data.date,
//             yValueMapper: (ChartData data, _) => data.expense
//         ),
//
//
//       ],
//     );
//   }
// }
//
//
class ChartData {
  ChartData({required this.date,  this.income = 0,  this.expense = 0});
  final int date;
  late int income;
  late int expense;
}


class DashboardGraphWidget extends StatelessWidget {
   DashboardGraphWidget({Key? key}) : super(key: key);


    late  List<ChartData> chartData = <ChartData>[];
  final List<ChartData> chartDataReset = <ChartData>[
    ChartData(date: 1,income: 0, expense:0),
    ChartData(date: 2,income: 0, expense: 0),
    ChartData(date: 3,income: 0, expense: 0),
    ChartData(date: 4,income: 0, expense: 0),
    ChartData(date: 5,income: 0, expense: 0),
    ChartData(date: 6,income: 0, expense: 0),
    ChartData(date: 7,income: 0, expense: 0),
    ChartData(date: 8,income: 0, expense: 0),
    ChartData(date: 9,income: 0, expense: 0),
    ChartData(date: 10,income: 0, expense: 0),
    ChartData(date: 11,income: 0, expense: 0),
    ChartData(date: 12,income: 0, expense: 0),
    ChartData(date: 13,income: 0, expense: 0),
    ChartData(date: 14,income: 0, expense: 0),
    ChartData(date: 15,income: 0, expense: 0),
    ChartData(date: 16,income: 0, expense: 0),
    ChartData(date: 17,income: 0, expense: 0),
    ChartData(date: 18,income: 0, expense: 0),
    ChartData(date: 19,income: 0, expense: 0),
    ChartData(date: 20,income: 0, expense: 0),
    ChartData(date: 21,income: 0, expense: 0),
    ChartData(date: 22,income: 0, expense:0),
    ChartData(date: 23,income: 0, expense:0),
    ChartData(date: 24,income: 0, expense:0),
    ChartData(date: 25,income: 0, expense:0),
    ChartData(date: 26,income: 0, expense:0),
    ChartData(date: 27,income: 0, expense:0),
    ChartData(date: 28,income: 0, expense:0),
    ChartData(date: 29,income: 0, expense:0),
    ChartData(date: 30,income: 0, expense:0),
    ChartData(date: 31,income: 0, expense:0),];

  @override
  Widget build(BuildContext context) {

    List<ChartData> updatedChartData = List<ChartData>.from(chartDataReset);

    List<IncomeType> incomeItems = Provider.of<IncomeProvider>(context, listen: false).items;
    List<ExpenseType> expenseItems = Provider.of<ExpenseProvider>(context, listen: false).items;

    for (var e in incomeItems) {
      updatedChartData[e.dateTime.day -1].income += e.amount ;
    }

    for (var e in expenseItems) {
      updatedChartData[e.dateTime.day -1].expense += e.amount ;
    }

    return SfCartesianChart(
      margin: EdgeInsets.zero,

      // Initialize category axis
        title: ChartTitle(text: "                          Income Expense Graph", alignment: ChartAlignment.near,),
      borderWidth: 5,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          // padding: 0,
        ),
      // legend: Legend(isVisible: true, position: LegendPosition.bottom, backgroundColor: Colors.red, padding: 0, height: "4",iconHeight: 2, ),
      plotAreaBackgroundColor: Colors.transparent,
      plotAreaBorderColor :  Colors.grey.shade200,
      plotAreaBorderWidth: 2,
      borderColor: Colors.grey.shade200,
      backgroundColor: Colors.transparent,
      primaryXAxis: CategoryAxis(
        labelRotation: 0,
        majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
        minorGridLines: MinorGridLines(width: 0, ),
        title: AxisTitle(text: "Date",alignment: ChartAlignment.center ),

        borderWidth: 0,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0.2), // Set majorGridLines to null
        minorGridLines: MinorGridLines(width: 0),
        title: AxisTitle(text: "Amount"),
        borderWidth: 0,
        isVisible: true
      ),

        series: <LineSeries<ChartData, int>>[
          LineSeries<ChartData, int>(
          name: "Income",
          dataSource: updatedChartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.income,
            // color: Colors.green,
            width: 4, // Increase line thickness
            // dashArray: [5, 1],
            markerSettings: MarkerSettings(
              isVisible: true,
              borderWidth: 4,
              shape: DataMarkerType.diamond
              // borderColor: Colors.blue,
            )

        ),
          LineSeries<ChartData, int>(
            name: "Expense",
            dataSource: updatedChartData,
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.expense,
            width: 2, // Increase line thickness
            // dashArray: [5, 2],
              markerSettings: MarkerSettings(
                isVisible: true,
                // borderColor: Colors.redAccent,
              )
        ),
          // LineSeries<SalesData, String>(
          //   // Bind data source
          //     dataSource:  <SalesData>[
          //       SalesData('Jan', 35),
          //       SalesData('Feb', 28),
          //       SalesData('Mar', 34),
          //       SalesData('Apr', 32),
          //       SalesData('May', 40)
          //     ],
          //     xValueMapper: (SalesData sales, _) => sales.year,
          //     yValueMapper: (SalesData sales, _) => sales.sales
          // ),
          // LineSeries<SalesData, String>(
          //   // Bind data source
          //     dataSource:  <SalesData>[
          //       SalesData('Jan', 45),
          //       SalesData('Feb', 56),
          //       SalesData('Mar', 40),
          //       SalesData('Apr', 0),
          //       SalesData('May', 60)
          //     ],
          //     xValueMapper: (SalesData sales, _) => sales.year,
          //     yValueMapper: (SalesData sales, _) => sales.sales
          // )
        ]
    );
  }
}


// class SalesData {
//   SalesData(this.year, this.sales);
//   final String year;
//   final double sales;
// }