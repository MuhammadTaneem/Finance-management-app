import 'package:cash_flow/providers/assets_provider.dart';
import 'package:cash_flow/providers/expense_provider.dart';
import 'package:cash_flow/providers/income_provider.dart';
import 'package:cash_flow/screens/add_assets.dart';
import 'package:cash_flow/screens/add_expense.dart';
import 'package:cash_flow/screens/add_income.dart';
import 'package:cash_flow/screens/assets.dart';
import 'package:cash_flow/screens/expense.dart';
import 'package:cash_flow/screens/home.dart';
import 'package:cash_flow/screens/income.dart';
import 'package:flutter/material.dart';
import './theme/theme_manager.dart';
import './theme/theme_data.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

ThemeManager _themeManager = ThemeManager();
class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IncomeProvider(),),
        ChangeNotifierProvider(create: (_) => ExpenseProvider(),),
        ChangeNotifierProvider(create: (_) => AssetsProvider(),),
        // ChangeNotifierProvider.value(
        //   value: IncomeProvider(),
        //
        // ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeManager.themeMode,
          navigatorKey: navigatorKey,
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            IncomeScreen.routeName: (ctx) => const IncomeScreen(),
            ExpenseScreen.routeName: (ctx) => const ExpenseScreen(),
            AssetsScreen.routeName: (ctx) => const AssetsScreen(),
            AddIncomeScreen.routeName: (ctx) => const AddIncomeScreen(),
            AddExpenseScreen.routeName: (ctx) => const AddExpenseScreen(),
            AddAssetsScreen.routeName: (ctx) => const AddAssetsScreen(),

          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => const HomePage(),
            );
          },

      ),
    );
  }
}


