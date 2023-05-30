import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Database/context_data.dart';
import '../providers/filterDate.dart';
import '../providers/income_provider.dart';
import '../widgets/from_label.dart';

class AddIncomeScreen extends StatefulWidget {
  static const routeName = '/add_income';
  final IncomeType? income;

  const AddIncomeScreen({Key? key, this.income}) : super(key: key);
  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen>{
  final List<String> _items = ContextOptions().incomeOption;
  final GlobalKey<FormState> _incomeFormKey = GlobalKey<FormState>();
  int filterYear = DateTime.now().year;
  late int filterMonth = DateTime.now().month;
  int? _amount;
  String? _description;
  String? _selectedSource;
  final int _todayDate = DateTime.now().day;
  late DateTime _selectedDate;
  bool editMode = false;
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  final _dateFocusNode = FocusNode();
  String pageHeadline = "Add a new Income";
  late TimeOfDay _timeData = TimeOfDay.now();
  bool _autovalidate = false;


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
      if (widget.income != null) {
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
    late IncomeType _income = IncomeType(
        id: widget.income?.id,
        description: _description!,
        amount: _amount!,
        source: _selectedSource!,
        dateTime: _selectedDate);
    late IncomeProvider _provider =
        Provider.of<IncomeProvider>(context, listen: false);

    editMode ? _provider.editItem(_income) : _provider.addItem(_income);
    FormState formState = _incomeFormKey.currentState!;
    setState(() {
      _selectedSource = null;
      _selectedDate = DateTime(FilterDate.year, FilterDate.month, _todayDate,
          _timeData.hour, _timeData.minute);
    });
    formState.reset();
    Navigator.of(context).pop();
  }

  _fillOldData() {
    // setState(() {
      pageHeadline = "Edit Your Income";
      editMode = true;
      _selectedSource = widget.income?.source;
      _selectedDate = widget.income?.dateTime ?? DateTime.now();
    // });
  }

  // _onCancel() => Navigator.of(context).pop();
  void _showIncomeSourceMenu(BuildContext context) async {
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
                  '  Select Your Income Source',
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
                    decoration: const BoxDecoration(
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
        _selectedSource = selectedSource;
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
    super.initState();
    widget.income != null
        ? _fillOldData()
        : _selectedDate = DateTime(FilterDate.year, FilterDate.month,
            _todayDate, _timeData.hour, _timeData.minute);
  }







  SizedBox formGap = const SizedBox(height: 15.0);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title:const Text("Income"),
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
                          key: _incomeFormKey,
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
                                label: "Income Source",
                                isRequired: true,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Select Your Income Source',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _showIncomeSourceMenu(context);
                                },
                                readOnly: true,
                                controller:
                                    TextEditingController(text: _selectedSource),
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
                                initialValue: widget.income?.amount != null
                                    ? "${widget.income?.amount}"
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
                                  // FocusScope.of(context)
                                  //     .requestFocus(_descriptionFocusNode);
                                },
                                onSaved: (value) {
                                  int? amount = int.tryParse(value ?? '');
                                  if (amount != null) {
                                    _amount = amount;
                                  }
                                },
                              ),
                              formGap,
                              const CustomFromLabel(label: "Income Date"),
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
                              const CustomFromLabel(label: "Income Time"),
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
                                initialValue: widget.income?.description != null
                                    ? "${widget.income?.description}"
                                    : null,
                                minLines: 4,
                                decoration: const InputDecoration(
                                  hintText: 'Write details about this income',
                                ),
                                // scrollPhysics: const NeverScrollableScrollPhysics(),
                                maxLines: 6,
                                focusNode: _descriptionFocusNode,
                                // decoration:
                                // const InputDecoration(
                                //     labelText: 'Description', alignLabelWithHint: true),
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
                                            _incomeFormKey.currentState!;
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
