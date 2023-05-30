import 'package:cash_flow/screens/dashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cash_flow/screens/expense.dart';
import 'package:cash_flow/screens/income.dart';
import 'package:flutter/material.dart';
import '../widgets/nav_items.dart';
import 'add_assets.dart';
import 'assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin {
  late int selectedIndex = 0;

  AppBar _appbar(context){
    final _appbars = [
      AppBar(title:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/icons/launcher.png',width: 30, height: 30,),
          const Text("Cash Flow"),
          const Text(""),
        ],
      ), automaticallyImplyLeading: false,),
      AppBar(
        title: const Text('Income'),
        automaticallyImplyLeading: false,
      ),
      AppBar(
        title: const Text('Expense'),
        automaticallyImplyLeading: false,
      ),
      AppBar(
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(AddAssetsScreen.routeName);
            },
          ),
        ],
      ),

    ];
    return _appbars[selectedIndex];
  }




  final pages = [
    {'label': 'Dashboard', 'icon': const Icon(Icons.dashboard), 'screen': Dashboard()},
    {'label': 'Income', 'icon': const Icon(Icons.attach_money), 'screen': IncomeScreen()},
    {'label': 'Expense', 'icon': const Icon(Icons.money_off), 'screen': ExpenseScreen()},
    {'label': 'Assets', 'icon': const Icon(Icons.account_balance), 'screen': AssetsScreen()}
  ];
  late final List<Widget> _items =  pages.map<Widget>((page) => NavbarItem( icon: page['icon'] as Icon, label: page['label'] as String,)  ).toList();
  List<Widget> getNavItem(sIndex){
    return pages
        .asMap()
        .map((index, page) {
      if (index == sIndex) {
        return MapEntry(
          index,
          page['icon'] as Icon ,
        );
      } else {
        return MapEntry(
            index,
            _items[index]
        );
      }
    }).values.toList();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Provider.of<IncomeProvider>(context,  listen: false).loadItems();
    // Provider.of<ExpenseProvider>(context,  listen: false).loadItems();
    // Provider.of<AssetsProvider>(context,  listen: false).loadItems();
    return Scaffold(

      appBar: _appbar(context),
      body: pages[selectedIndex]['screen'] as Widget?,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primary,
        animationCurve: Curves.ease,
        animationDuration: const Duration(milliseconds:1100),
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        height: 60,
        items: getNavItem(selectedIndex),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );

  }
}