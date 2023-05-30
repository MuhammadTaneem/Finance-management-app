import 'package:cash_flow/providers/assets_provider.dart';
import 'package:cash_flow/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filterDate.dart';
import '../providers/income_provider.dart';
import '../widgets/assets_bar.dart';
import '../widgets/dashboard_bar.dart';
import '../widgets/dashboard_graph.dart';
import '../widgets/income_expense_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard> {

  late int filterYear = FilterDate.year;
  late int filterMonth = FilterDate.month;
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  
  Future<void> _refreshPage() async {
    await Provider.of<IncomeProvider>(context, listen: false).loadItems();
    await Provider.of<ExpenseProvider>(context, listen: false).loadItems();
    await Provider.of<AssetsProvider>(context, listen: false).loadItems();
  }


  void _decress(BuildContext context){

    filterMonth ==1 ? setState(() {
      filterMonth = 12;
      filterYear--;
    }): setState(() {
      filterMonth--;
    });
    Provider.of<IncomeProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);
    Provider.of<ExpenseProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);

  }
  void _incress(BuildContext context){

    filterMonth ==12 ? setState(() {
      filterMonth = 1;
      filterYear++;
    }): setState(() {
      filterMonth++;
    });
    Provider.of<IncomeProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);
    Provider.of<ExpenseProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
    _refreshPage();
    });
  }



  @override
  Widget build(BuildContext context) {
    // _refreshPage();
    late double dvHeight = MediaQuery.of(context).size.height;
    late double dvWight = MediaQuery.of(context).size.height;
    int totalIncome  = Provider.of<IncomeProvider>(context, listen: true).totalAmount;
    int totalExpense  = Provider.of<ExpenseProvider>(context, listen: true).totalAmount;
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: dvHeight *0.34,
              width: dvWight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: double.infinity,
                    height: dvHeight * 0.3,
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding:EdgeInsets.only(top: dvHeight * 0.03,left: 20, bottom: dvHeight * 0.05, ),
                          child: Text("${monthNames[filterMonth-1]} $filterYear \nCurrent Balance", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: (){_decress(context);} , icon: const Icon(Icons.arrow_back_ios, color: Colors.white),),
                            Text("${totalIncome - totalExpense} ৳",style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),),
                            IconButton(onPressed: (){_incress(context);}, icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),),

                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    // bottom: -35,
                    left: 0,
                    right: 0,
                    top: dvHeight * 0.25,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        height: dvHeight * 0.08,
                        width: dvWight * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$totalIncome"),
                                const Text("Total Income")
                              ],
                            ),
                            // const SizedBox(width: 10), // add some spacing between the widgets
                            SizedBox(
                              width: 2, // set a specific width for the divider
                              child: Divider(
                                height: double.infinity,
                                color: Theme.of(context).colorScheme.secondary,
                                thickness: 50,
                                // set a specific thickness for the divider
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$totalExpense"),
                                const Text("Total Expense")
                              ],
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
                padding: const EdgeInsets.only(bottom: 10) ,
                color: Colors.grey.shade200,
                height: dvHeight *0.4,
                width: dvWight*2,
                child: IncomeExpenseBarChart()

            ),
            AssetsBarChartWidget()

          ],
        ),
      ),
    );
  }
}
