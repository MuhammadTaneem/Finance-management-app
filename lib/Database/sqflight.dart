import 'package:cash_flow/providers/income_provider.dart';
import 'package:cash_flow/widgets/investment_list.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../providers/assets_provider.dart';
import '../providers/expense_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'www_cash_flow.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incomes(
          id INTEGER PRIMARY KEY,
          source TEXT NOT NULL,
          description TEXT DEFAULT '',
          amount INTEGER NOT NULL,
          dateTime TEXT NOT NULL
          )
      ''');
    await db.execute('''
      CREATE TABLE expense(
          id INTEGER PRIMARY KEY,
          expenditure TEXT NOT NULL,
          description TEXT DEFAULT '',
          amount INTEGER NOT NULL,
          dateTime TEXT NOT NULL
          )
      ''');

    await db.execute('''
      CREATE TABLE assets(
          id INTEGER PRIMARY KEY,
          category TEXT NOT NULL,
          name TEXT NOT NULL,
          description TEXT DEFAULT '',
          amount INTEGER NOT NULL,
          dateTime TEXT NOT NULL
          )
      ''');
  }

  Future<List<IncomeType>> getIncome() async {
    Database db = await instance.database;
    var incomes = await db.query('incomes');
    List<IncomeType> incomeList =
    incomes.isNotEmpty ? incomes.map((c) => IncomeType.fromMap(c)).toList() : [];
    return incomeList;
  }

  Future<int> addIncome(IncomeType income) async {
    Database db = await instance.database;
    var response = await db.insert('incomes', income.toMap());
    return response;
  }

  Future<int> removeIncome(int? id) async {
    Database db = await instance.database;
    return await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateIncome(IncomeType income) async {
    Database db = await instance.database;
    return await db.update('incomes', income.toMap(),
        where: "id = ?", whereArgs: [income.id]);
  }


  // expense =========================================

  Future<List<ExpenseType>> getExpense() async {
    Database db = await instance.database;
    var expense = await db.query('expense');
    List<ExpenseType> expenseList =
    expense.isNotEmpty ? expense.map((c) => ExpenseType.fromMap(c)).toList() : [];
    return expenseList;
  }

  Future<int> addExpense(ExpenseType expense) async {
    Database db = await instance.database;
    var response = await db.insert('expense', expense.toMap());
    return response;
  }

  Future<int> removeExpense(int? id) async {
    Database db = await instance.database;
    return await db.delete('expense', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExpense(ExpenseType expense) async {
    Database db = await instance.database;
    return await db.update('expense', expense.toMap(),
        where: "id = ?", whereArgs: [expense.id]);
  }

  // ====================== assets================

  Future<List<AssetsType>> getInvestment() async {
    Database db = await instance.database;
    // var assets = await db.query('assets');
    var assets = await db.rawQuery('SELECT * FROM assets WHERE category = ?', ['Investment']);
    List<AssetsType> investmentList =
    assets.isNotEmpty ? assets.map((c) => AssetsType.fromMap(c)).toList() : [];
    return investmentList;
  }
  Future<List<AssetsType>> getDeposit() async {
    Database db = await instance.database;
    var assets = await db.rawQuery('SELECT * FROM assets WHERE category = ?', ['Deposit']);
    List<AssetsType> depositList =
    assets.isNotEmpty ? assets.map((c) => AssetsType.fromMap(c)).toList() : [];
    return depositList;
  }
  Future<List<AssetsType>> getLent() async {
    Database db = await instance.database;
    var assets = await db.rawQuery('SELECT * FROM assets WHERE category = ?', ['Lent']);
    List<AssetsType> lentList =
    assets.isNotEmpty ? assets.map((c) => AssetsType.fromMap(c)).toList() : [];
    return lentList;
  }

  Future<int> addAssets(AssetsType asset) async {
    Database db = await instance.database;
    var response = await db.insert('assets', asset.toMap());
    return response;
  }

  Future<int> removeAsset(int? id) async {
    Database db = await instance.database;
    return await db.delete('assets', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAsset(AssetsType asset) async {
    Database db = await instance.database;
    return await db.update('assets', asset.toMap(),
        where: "id = ?", whereArgs: [asset.id]);
  }
}

