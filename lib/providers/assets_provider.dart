import 'package:cash_flow/Database/sqflight.dart';
import 'package:cash_flow/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'filterDate.dart';

class AssetsType{
  final int? id;
  final String name;
  final String category;
  final String description;
  final int amount;
  final DateTime dateTime;

  AssetsType({required this.name, required this.amount, required this.dateTime,
    this.id,
    this.description = '', required this.category,
  });



  factory AssetsType.fromMap(Map<String, dynamic> json) => AssetsType(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime'])
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'amount': amount,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
    };
  }
}


class Item {
  final String name;
  final int amount;
  Item({required this.name, required this.amount,});
}


class AssetsProvider with ChangeNotifier {

  late  List<AssetsType> _investments = [];
  late  List<AssetsType> _deposits = [];
  late  List<AssetsType> _lents = [];
  late  int _response;
  final snackWidget = SnackWidget();
  bool _isLoading = false;



  List<AssetsType> get investmentItems {
    return [..._investments];
  }

  List<AssetsType> get depositsItems {
    return [..._deposits];
  }

  List<AssetsType> get lentsItems {
    return [..._lents];
  }


  bool get isLoading{
    return _isLoading;
  }


  Future<void> loadInvestmentItems() async {
    _isLoading = true;
    notifyListeners();
    _investments = await DatabaseHelper.instance.getInvestment();
    notifyListeners();
    _isLoading = false;
  }

  Future<void> loadDepositItems() async {
    _isLoading = true;
    notifyListeners();
    _deposits = await DatabaseHelper.instance.getDeposit();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLentItems() async {
    _isLoading = true;
    notifyListeners();
    _lents = await DatabaseHelper.instance.getLent();
    _isLoading = false;
    notifyListeners();
  }
  loadItems(){
    loadInvestmentItems();
    loadDepositItems();
    loadLentItems();
  }




  int get investmentItemCount {
    return  _investments.length;
  }
  int get depositItemCount {
    return  _deposits.length;
  }
  int get lentItemCount {
    return  _lents.length;
  }



  get totalAmount{
    int  totalInvestmentAmount = _investments.fold(0, (previousValue, item) => previousValue + item.amount);
    int totalDepositAmount  = _deposits.fold(0, (previousValue, item) => previousValue + item.amount);
    int  totalLentAmount = _lents.fold(0, (previousValue, item) => previousValue + item.amount);

    late  List<Item> _items = [
      Item(name: "Investment", amount:totalInvestmentAmount ),
      Item(name: "Deposit", amount: totalDepositAmount),
      Item(name: "Lent", amount:  totalLentAmount),
    ];
    return [..._items];
  }

  List<double> calculatePercentages(List<int> amountList) {
    final total = amountList.reduce((a, b) => a + b);

    if (total == 0) {
      return List<double>.filled(amountList.length, 0);
    }

    return amountList.map((amount) => (amount / total) * 100).toList();
  }

  get totalAmountPercentage{
    int  totalInvestmentAmount = _investments.fold(0, (previousValue, item) => previousValue + item.amount);
    int totalDepositAmount  = _deposits.fold(0, (previousValue, item) => previousValue + item.amount);
    int  totalLentAmount = _lents.fold(0, (previousValue, item) => previousValue + item.amount);
    late List<double> _percentage= calculatePercentages([totalInvestmentAmount,totalDepositAmount, totalLentAmount] );
    return [..._percentage];
  }


  Future<void> addItem(AssetsType assets) async {
    _response = await DatabaseHelper.instance.addAssets(assets);
    if(_response>0){
      snackWidget.showMessage(message: "Assets added.", snackbarType: SnackbarType.success);
      if(assets.category == 'Investment'){
        loadInvestmentItems();
      }
      else if(assets.category == 'Deposit'){
        loadDepositItems();
      }
      else{
        loadLentItems();
      }
    }
    else{
      snackWidget.showMessage(message: "Failed.", snackbarType: SnackbarType.error);
    }

  }
  removeItem(AssetsType assets) async {
    if(assets.id != null){
      _response = await DatabaseHelper.instance.removeAsset(assets.id);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Assets deleted.", snackbarType: SnackbarType.success);
      if(assets.category == 'Investment'){
      loadInvestmentItems();
      }
      else if(assets.category == 'Deposit'){
        loadDepositItems();
      }
      else{
        loadLentItems();
      }
    }
  }
  editItem(AssetsType assets) async {
    _response = 0;
    if(assets.id != null){
      _response = await DatabaseHelper.instance.updateAsset(assets);
    }
    if(_response>0){
      snackWidget.showMessage(message: "Assets updated.", snackbarType: SnackbarType.success);
      if(assets.category == 'Investment'){
        loadInvestmentItems();
      }
      else if(assets.category == 'Deposit'){
        loadDepositItems();
      }
      else{
        loadLentItems();
      }
    }
    else{
      snackWidget.showMessage(message: "failed.", snackbarType: SnackbarType.error);
    }
  }



}