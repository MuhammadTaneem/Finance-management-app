import 'package:cash_flow/Database/sqflight.dart';
import 'package:cash_flow/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './filterDate.dart';

class IncomeType{
  final int? id;
  final String source;
  final String description;
  final int amount;
  final DateTime dateTime;

  IncomeType({required this.source, required this.amount, required this.dateTime,
    this.id,
    this.description = '',
  });



  factory IncomeType.fromMap(Map<String, dynamic> json) => IncomeType(
    id: json['id'],
    source: json['source'],
    description: json['description'],
    amount: json['amount'],
    dateTime: DateTime.parse(json['dateTime'])
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source': source,
      'description': description,
      'amount': amount,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
    };
  }
}

class IncomeProvider with ChangeNotifier {

  late  List<IncomeType> _incomes = [];
  late  List<IncomeType> _filteredIncomes = [];
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

  List<IncomeType> get items {
    return [..._filteredIncomes];
  }

  bool get isLoading{
    return _isLoading;
  }


  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    _incomes = await DatabaseHelper.instance.getIncome();
    _filteredIncomes = _incomes.where((income) =>
    income.dateTime.year == FilterDate.year  && income.dateTime.month == FilterDate.month
    ).toList();
    notifyListeners();
    _isLoading = false;
  }




  int get itemCount {
    return _filteredIncomes.length;
  }

  int get totalAmount{
    int  totalAmount = _filteredIncomes.fold(0, (previousValue, item) => previousValue + item.amount);
    return totalAmount;
  }

  Future<void> addItem(IncomeType income) async {
    _response = await DatabaseHelper.instance.addIncome(income);
    if(_response>0){
      snackWidget.showMessage(message: "Income added.", snackbarType: SnackbarType.success);
      loadItems();
    }
    else{
    snackWidget.showMessage(message: "Failed.", snackbarType: SnackbarType.error);
    }

  }

  removeItem(IncomeType income) async {
    if(income.id != null){
    _response = await DatabaseHelper.instance.removeIncome(income.id);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Income deleted.", snackbarType: SnackbarType.success);
      loadItems();
    }
  }
  editItem(IncomeType income) async {
    _response = 0;
    if(income.id != null){
      _response = await DatabaseHelper.instance.updateIncome(income);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Income updated.", snackbarType: SnackbarType.success);
      loadItems();
    }
    else{
      snackWidget.showMessage(message: "failed.", snackbarType: SnackbarType.error);
    }
  }



}