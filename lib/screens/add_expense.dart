import 'dart:async';

import 'package:cash_flow/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Database/context_data.dart';
import '../providers/filterDate.dart';
import '../widgets/from_label.dart';

class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add_expense';
  final ExpenseType? expense;

  const AddExpenseScreen({Key? key, this.expense}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final List<String> _items = ContextOptions().expenseOption;
  final GlobalKey<FormState> expenseFormKey = GlobalKey<FormState>();
  int filterYear = DateTime.now().year;
  late int filterMonth = DateTime.now().month;
  int? _amount;
  String? _description;
  String? _selectedExpenditure;
  final int _todayDate = DateTime.now().day;
  late DateTime _selectedDate;
  bool editMode = false;
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  String pageHeadline = "Add a new Expense";
  late TimeOfDay _timeData = TimeOfDay.now();
  bool _autovalidate  = false;

  timePicker() async {
    _timeData = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _timeData.hour, minute: _timeData.minute),
    ))!;
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _timeData.hour,
        _timeData.minute,
      );
    });
    FocusScope.of(context).requestFocus(_descriptionFocusNode);
  }

  void _presentDatePicker() {
    _descriptionFocusNode.unfocus();
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (widget.expense != null) {
        _timeData =
            TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute);
      } else {
        _timeData = TimeOfDay.now();
      }
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _timeData.hour,
          _timeData.minute,
        );
      });
      timePicker();
    });
  }

  _onSave() {
    late ExpenseType _expense = ExpenseType(
        id: widget.expense?.id,
        description: _description!,
        amount: _amount!,
        expenditure: _selectedExpenditure!,
        dateTime: _selectedDate,);
    late ExpenseProvider _provider =
        Provider.of<ExpenseProvider>(context, listen: false);

    editMode ? _provider.editItem(_expense) : _provider.addItem(_expense);
    FormState formState = expenseFormKey.currentState!;
    setState(() {
      _selectedExpenditure = null;
      _selectedDate = DateTime(FilterDate.year, FilterDate.month, _todayDate,
          _timeData.hour, _timeData.minute);
    });
    formState.reset();
    Navigator.of(context).pop();
  }

  _fillOldData() {
    setState(() {
      pageHeadline = "Edit Your Expense";
      editMode = true;
      _selectedExpenditure = widget.expense?.expenditure;
      _selectedDate = widget.expense?.dateTime ?? DateTime.now();
    });
  }

  // _onCancel() => Navigator.of(context).pop();
  void _showExpenseSourceMenu(BuildContext context) async {
    String? selectedSource = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.only(left: 0),
          title: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '  Select Your Expenditure',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.maxFinite,
            child: Scrollbar(
              thickness: 5,
              child: ListView(
                shrinkWrap: true,
                children: _items.map((String item) {
                  return Container(
                    decoration: BoxDecoration(
                      //                    <-- BoxDecoration
                      border: Border(bottom: BorderSide(color: Colors.black12)),
                    ),
                    child: ListTile(
                      title: Text(item),
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
    if (selectedSource != null) {
      setState(() {
        _selectedExpenditure = selectedSource;
        FocusScope.of(context).requestFocus(_amountFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _amountFocusNode.dispose();
    _dateFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.expense != null
        ? _fillOldData()
        : _selectedDate = DateTime(FilterDate.year, FilterDate.month,
            _todayDate, _timeData.hour, _timeData.minute);
    super.initState();

}


  SizedBox formGap = const SizedBox(height: 15.0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text("Expense"),
          automaticallyImplyLeading: true),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Card(
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Form(
                          key: expenseFormKey,
                          autovalidateMode: _autovalidate ?AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(

                                    pageHeadline,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                              ),
                              const CustomFromLabel(
                                label: "Expenditure",
                                isRequired: true,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Select Your Expenditure',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _showExpenseSourceMenu(context);
                                },
                                readOnly: true,
                                controller:
                                    TextEditingController(text: _selectedExpenditure),
                                validator: (value) {
                                  return value == null || value.isEmpty
                                      ? 'This field is required'
                                      : null;
                                },
                              ),

                              formGap,
                              const CustomFromLabel(
                                label: "Amount",
                                isRequired: true,
                              ),
                              TextFormField(
                                initialValue: widget.expense?.amount != null
                                    ? "${widget.expense?.amount}"
                                    : null,
                                decoration: const InputDecoration(
                                  hintText: 'Input your amount',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                ],
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  return value == null || value.isEmpty
                                      ? 'This field is required'
                                      : null;
                                },
                                focusNode: _amountFocusNode,
                                onFieldSubmitted: (_) {
                                  _presentDatePicker();
                                },
                                onSaved: (value) {
                                  int? amount = int.tryParse(value ?? '');
                                  if (amount != null) {
                                    _amount = amount;
                                  }
                                },
                              ),
                              formGap,
                              const CustomFromLabel(label: "Expense Date"),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: DateFormat.yMMMd().format(_selectedDate),
                                ),
                                onTap: _presentDatePicker,
                                decoration: const InputDecoration(
                                  hintText: "",
                                  suffixIcon: Icon(Icons.calendar_month),
                                ),
                              ),
                              formGap,
                              const CustomFromLabel(label: "Expense Time"),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text:
                                        DateFormat('hh:mm a').format(_selectedDate)),
                                onTap: timePicker,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.watch_later_outlined),
                                ),
                              ),
                              formGap,
                              const CustomFromLabel(label: "Description"),
                              TextFormField(
                                initialValue: widget.expense?.description != null
                                    ? "${widget.expense?.description}"
                                    : null,
                                minLines: 4,
                                decoration: const InputDecoration(
                                  hintText: 'Write details about this expense',
                                ),
                                maxLines: 6,
                                focusNode: _descriptionFocusNode,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  return null;
                                },
                                onSaved: (value) {
                                  _description = value!;
                                },
                              ),
                              formGap,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        FormState formState =
                                        expenseFormKey.currentState!;
                                        formState.save();
                                        formState.validate() ? _onSave() : null;
                                        setState(() {
                                          _autovalidate = true;
                                        });
                                      },
                                      style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          Size(
                                              MediaQuery.of(context).size.width *
                                                  0.9,
                                              50),
                                        ),
                                      ),
                                      child: const Text("Submit")),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}


