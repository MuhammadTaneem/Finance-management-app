import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_income.dart';
import '../providers/filterDate.dart';
import '../providers/income_provider.dart';
import '../widgets/income_list.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);
  static const routeName = '/income';


  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {


  final GlobalKey<RefreshIndicatorState> _arefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
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
  _onTap(){
    Navigator.of(context).pushNamed(AddIncomeScreen.routeName);
    _refreshPage();
  }
  void _decress(BuildContext context){

    filterMonth ==1 ? setState(() {
      filterMonth = 12;
      filterYear--;
    }): setState(() {
      filterMonth--;
    });
    Provider.of<IncomeProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);

  }
  void _incress(BuildContext context){

    filterMonth ==12 ? setState(() {
      filterMonth = 1;
      filterYear++;
    }): setState(() {
      filterMonth++;
    });
    Provider.of<IncomeProvider>(context, listen: false).filter(month: filterMonth, year: filterYear);
  }
  Future<void> _refreshPage() async {
    await Provider.of<IncomeProvider>(context, listen: false).loadItems();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int totalIncome  = Provider.of<IncomeProvider>(context, listen: true).totalAmount;


    return RefreshIndicator(
      onRefresh:_refreshPage,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      key: _arefreshIndicatorKey,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *0.34,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){_decress(context);} , icon: const Icon(Icons.arrow_back_ios, color: Colors.white),),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(monthNames[filterMonth-1],  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),),
                            Text("$filterYear",  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
                            // Text("$filterYear"),
                          ],
                        ),

                        IconButton(onPressed: (){_incress(context);}, icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),),
                      ],
                    ),
                  ),

                  Positioned(
                    // bottom: -35,
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.25,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.9,
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

                            InkWell(
                              onTap: _onTap,
                              child: SizedBox(
                                width: 100,
                                height: 70,
                                child: Column(
                                  children: const [
                                    SizedBox(height: 15,),
                                    Icon(Icons.add),
                                    Text( "Add Income"),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // top box end

            const IncomeItemListWidget(),
            // ExpenseScreen()


          ],
        ),
      ),
    );
  }
}
