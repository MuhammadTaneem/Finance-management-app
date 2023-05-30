import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/assets_provider.dart';

class ChartData {
  final Color color;
  final double value;
  final String title;

  ChartData({
    required this.color,
    required this.value,
    required this.title,
  });
}

class AssetsBarChartWidget extends StatefulWidget {
  AssetsBarChartWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<AssetsBarChartWidget> {
  int touchedIndex = -1;

  // List<ChartData> chartDataList = [
  //   ChartData(
  //     color: Theme.of(context).colorScheme.primary,
  //     value: 50,
  //     title: '40%',
  //   ),
  //   ChartData(
  //     color: Colors.purple.shade300,
  //     value: 20,
  //     title: '30%',
  //   ),
  //   ChartData(
  //     color: Colors.deepOrangeAccent,
  //     value: 20,
  //     title: '30%',
  //   ),
  // ];
  List<ChartData> chartDataList = [];




  @override
  Widget build(BuildContext context) {
    List<double> _items = Provider.of<AssetsProvider>(context, listen: false).totalAmountPercentage;
    late double totalItems = _items.reduce((value, element) => value + element);
    List<Item> _amountItems = Provider.of<AssetsProvider>(context, listen: false).totalAmount;
    chartDataList = [
      ChartData(
        color: Theme.of(context).colorScheme.primary,
        value: _items[0],
        title: '40%',
      ),
      ChartData(
        color: Theme.of(context).colorScheme.secondary,
        value: _items[1],
        title: '30%',
      ),
      ChartData(
        color: Colors.grey,
        value: _items[2],
        title: '30%',
      ),
    ];
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 3,bottom: 12),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Assets Pie Chart", style: TextStyle(
                    fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                )),
              ],
            ),
          ),
          if(totalItems>0)...[
            Expanded(
              child: AspectRatio(
                aspectRatio: 2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(_amountItems),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(height: 20,width: 20, color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: 5,),
                    Text("Investment")
                  ],
                ),
                Row(
                  children: [
                    Container(height: 20,width: 20, color: Theme.of(context).colorScheme.secondary),
                    SizedBox(width: 5,),
                    Text("Deposit")
                  ],
                ),
                Row(
                  children: [
                    Container(height: 20,width: 20, color: Colors.grey),
                    SizedBox(width: 5,),
                    Text("Lent")
                  ],
                )
              ],
            ),
          ]
          else...[
            Spacer(),
            Image.asset('assets/icons/launcher.png', height: 100, width: 100,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No assets added"),
            ),
            Spacer(),
          ],


          SizedBox(height: 20,)

        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(amountItems) {
    return List.generate(chartDataList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final data =  chartDataList[i] ;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: isTouched ? "${amountItems[i].amount} ৳": "${(chartDataList[i].value.toStringAsFixed(1))} %" ,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          // color: Colors.white,
          fontWeight: FontWeight.normal,
          shadows: shadows,
        ),
      );
    });
  }
}
