import 'package:cash_flow/Database/sqflight.dart';
import 'package:cash_flow/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'filterDate.dart';

class ExpenseType{
  final int? id;
  final String expenditure;
  final String description;
  final int amount;
  final DateTime dateTime;

  ExpenseType({required this.expenditure, required this.amount, required this.dateTime,
    this.id,
    this.description = '',
  });



  factory ExpenseType.fromMap(Map<String, dynamic> json) => ExpenseType(
      id: json['id'],
      expenditure: json['expenditure'],
      description: json['description'],
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime'])
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenditure': expenditure,
      'description': description,
      'amount': amount,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
    };
  }
}

class ExpenseProvider with ChangeNotifier {

  late  List<ExpenseType> _expense = [];
  late  List<ExpenseType> _filteredExpense = [];
  late  int _response;
  final snackWidget = SnackWidget();
  // late int filterYear = DateTime.now().year;
  // late int filterMonth = DateTime.now().month;
  bool _isLoading = false;

  filter({required int month, required int year}) {
    // filterMonth = month;
    // filterYear = year;
    FilterDate.month = month;
    FilterDate.year = year;
    loadItems();
  }

  // getFilterContext(){
  //   return{'year': filterYear, 'month': filterMonth};
  // }

  List<ExpenseType> get items {
    return [..._filteredExpense];
  }

  bool get isLoading{
    return _isLoading;
  }


  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    _expense = await DatabaseHelper.instance.getExpense();
    _filteredExpense = _expense.where((expense) =>
    expense.dateTime.year == FilterDate.year  && expense.dateTime.month == FilterDate.month
    ).toList();
    notifyListeners();
    _isLoading = false;
  }




  int get itemCount {
    return  _filteredExpense.length;
  }

  int get totalAmount{
    int  totalAmount = _filteredExpense.fold(0, (previousValue, item) => previousValue + item.amount);
    return totalAmount;
  }

  Future<void> addItem(ExpenseType expense) async {
    _response = await DatabaseHelper.instance.addExpense(expense);
    if(_response>0){
      snackWidget.showMessage(message: "Expense added.", snackbarType: SnackbarType.success);
      loadItems();
    }
    else{
      snackWidget.showMessage(message: "Failed.", snackbarType: SnackbarType.error);
    }

  }

  removeItem(ExpenseType expense) async {
    if(expense.id != null){
      _response = await DatabaseHelper.instance.removeExpense(expense.id);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Expense deleted.", snackbarType: SnackbarType.success);
      loadItems();
    }
  }
  editItem(ExpenseType expense) async {
    _response = 0;
    if(expense.id != null){
      _response = await DatabaseHelper.instance.updateExpense(expense);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Expense updated.", snackbarType: SnackbarType.success);
      loadItems();
    }
    else{
      snackWidget.showMessage(message: "failed.", snackbarType: SnackbarType.error);
    }
  }



}