

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';

class IncomeExpenseBarChart extends StatelessWidget {
  IncomeExpenseBarChart({super.key});

  final List<ChartData> chartData = <ChartData>[
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
    ChartData(date: 31,income: 0, expense:0),
  ];

  @override
  Widget build(BuildContext context) {


    late double dvHeight = MediaQuery.of(context).size.height;
    late double dvWight = MediaQuery.of(context).size.width;
    List<ChartData> updatedChartData = List<ChartData>.from(chartData);
    List<IncomeType> incomeItems = Provider.of<IncomeProvider>(context, listen: false).items;
    List<ExpenseType> expenseItems = Provider.of<ExpenseProvider>(context, listen: false).items;
    late int maxValue = 0;

    for (var e in incomeItems) {
      updatedChartData[e.dateTime.day -1].income += e.amount ;
      if(maxValue<updatedChartData[e.dateTime.day -1].income){
        maxValue = (updatedChartData[e.dateTime.day -1].income).toInt();
      }
    }

    for (var e in expenseItems) {
      updatedChartData[e.dateTime.day -1].expense += e.amount ;
      if(maxValue<updatedChartData[e.dateTime.day -1].expense){
        maxValue = (updatedChartData[e.dateTime.day -1].expense).toInt();
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.only(top: 3, bottom: 12),
          child: Text("Income Expense Chart", style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          )),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.white,
              width: dvWight*2,
              height: dvHeight,
              padding:const EdgeInsets.only(top: 12,left: 15, bottom: 12, right: 15),
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData(maxValue),
                  borderData: borderData,
                  // gridData: FlGridData(show: true),

                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue*1.5,
                  barGroups: barGroups(updatedChartData),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }





  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      rotateAngle: 270,
      fitInsideHorizontally: false,
      fitInsideVertically: true,

      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          // rod.toY.round().toString(),
          "${rod.toY.round()} ৳",
          // .toString(),
          const TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: AxisSide.top,
      space: 4,
      child: Text((value.toInt()).toString(), style: style),
    );
  }
  double calculateLeftTitlesReservedSize(maxValue) {
    // Calculate the required size based on your data
    // Replace this with your own logic to calculate the size dynamically
    int dataSize = (maxValue.toString().length)+1; // Replace with the actual size of your data
    double titleWidth = 13; // Replace with the desired width for each title

    double reservedSize = dataSize * titleWidth;

    // Add any additional padding or margins if needed
    // double padding = 20; // Replace with the desired padding value

    return reservedSize;
  }
  FlTitlesData  titlesData(maxValue) => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      axisNameWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Date"),
          Row(
            children: [
              Container(
                width: 30,
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue,
                      Colors.blue,
                      Colors.black87 ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Text("Income"),
              const SizedBox(height: 1, width: 10,),
              Container(
                width: 30,
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red,
                      Colors.red,
                      Colors.green, ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Text("Expense"),
            ],
          ),
          const Text(""),


        ],
      ),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles:  AxisTitles(
      // axisNameSize: Text("Amount"),
      axisNameWidget: const Text("Amount"),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: calculateLeftTitlesReservedSize(maxValue),
        getTitlesWidget: getTitles,
      ),
    ),
    topTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );
  FlBorderData get borderData => FlBorderData(
    border: Border(
      top: BorderSide(
        color: Colors.grey.shade300,
        width: 5
      ),
        bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 5
        ),
      right: BorderSide(
          color: Colors.grey.shade300,
        width: 5
    ),
      left: BorderSide(
          color: Colors.grey.shade300,
        width: 5
    ),
    ),
    show: true,
  );
  LinearGradient get _incomeGradient => const LinearGradient(
    colors: [
      Colors.blue,
      Colors.blue,
      Colors.black87 ,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  LinearGradient get _expenseGradient => const LinearGradient(
    colors: [
      Colors.red,
      Colors.red,
      Colors.green,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  List<BarChartGroupData> barGroups(items) => [
    for(var item in items)...[
      BarChartGroupData(
        barsSpace: 5,
        // groupVertically:true,
        x: item.date,
        barRods: [
          BarChartRodData(
            toY: item.income,
            gradient: _incomeGradient,
          ),
          BarChartRodData(
            toY: item.expense,
            gradient: _expenseGradient,
          )
        ],
        showingTooltipIndicators: [
          if (item.income > 0) 0,
          if (item.expense > 0) 1,],
      ),
    ],
  ];
}



class ChartData {
  ChartData({required this.date,  this.income = 0,  this.expense = 0});
  final int date;
  late double income;
  late double expense;
}