import 'package:cash_flow/providers/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Database/context_data.dart';
import '../providers/filterDate.dart';
import '../widgets/from_label.dart';

class AddAssetsScreen extends StatefulWidget {
  static const routeName = '/add_assets';
  final AssetsType? assets;

  const AddAssetsScreen({Key? key, this.assets}) : super(key: key);

  @override
  State<AddAssetsScreen> createState() => _AddAssetsScreenState();
}

class _AddAssetsScreenState extends State<AddAssetsScreen> {
  final List<String> _items = ContextOptions().assetsOption;
  final GlobalKey<FormState> assetsFormKey = GlobalKey<FormState>();
  int filterYear = DateTime.now().year;
  late int filterMonth = DateTime.now().month;
  int? _amount;
  String? _name;
  String? _description;
  String? _selectedCategory;
  final int _todayDate = DateTime.now().day;
  late DateTime _selectedDate;
  bool editMode = false;
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  String pageHeadline = "Add a new assets";
  late TimeOfDay _timeData = TimeOfDay.now();
  final ScrollController _scrollController = ScrollController();
  bool _autovalidate = false;

  scroll(double scrollTo) {
    _scrollController.jumpTo(scrollTo);
  }

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
      if (widget.assets != null) {
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
    late AssetsType _assets = AssetsType(
        id: widget.assets?.id,
        category: _selectedCategory!,
        description: _description!,
        amount: _amount!,
        name: _name!,
        dateTime: _selectedDate);
    late AssetsProvider _provider =
        Provider.of<AssetsProvider>(context, listen: false);
    editMode ? _provider.editItem(_assets) : _provider.addItem(_assets);
    FormState formState = assetsFormKey.currentState!;
    setState(() {
      _selectedCategory = null;
      _selectedDate = DateTime(FilterDate.year, FilterDate.month, _todayDate,
          _timeData.hour, _timeData.minute);
    });
    formState.reset();
    Navigator.of(context).pop();
  }

  _fillOldData() {
    setState(() {
      pageHeadline = "Edit Your Assets";
      editMode = true;
      _selectedCategory = widget.assets?.category;
      _selectedDate = widget.assets?.dateTime ?? DateTime.now();
    });
  }

  // _onCancel() => Navigator.of(context).pop();
  void _showIncomeSourceMenu(BuildContext context) async {
    String? selectedCategory = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.only(left: 0),
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
    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
        FocusScope.of(context).requestFocus(_nameFocusNode);
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
    widget.assets != null
        ? _fillOldData()
        : _selectedDate = DateTime(FilterDate.year, FilterDate.month,
            _todayDate, _timeData.hour, _timeData.minute);
    super.initState();
  }

  SizedBox formGap = const SizedBox(height: 15.0);

  @override
  Widget build(BuildContext context) {

    final currentFocus = FocusScope.of(context);
    return Scaffold(
      appBar:
          AppBar(title: const Text("Asset"), automaticallyImplyLeading: true),
      body: GestureDetector(
        onTap: currentFocus.unfocus,
        child: SingleChildScrollView(
          reverse: true,
          child: Card(
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // padding:  EdgeInsets.only(top: 20),
              child: Form(
                  key: assetsFormKey,
                  autovalidateMode: _autovalidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
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
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      const CustomFromLabel(
                        label: "Asset Category",
                        isRequired: true,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Select Your Asset Category',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        onTap: () {
                          currentFocus.requestFocus(FocusNode());
                          _showIncomeSourceMenu(context);
                        },
                        readOnly: true,
                        controller:
                            TextEditingController(text: _selectedCategory),
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? 'This field is required'
                              : null;
                        },
                      ),
                      formGap,
                      const CustomFromLabel(
                        label: "Name",
                        isRequired: true,
                      ),
                      TextFormField(
                        initialValue: widget.assets?.name != null
                            ? "${widget.assets?.name}"
                            : null,
                        decoration: const InputDecoration(
                          // contentPadding: EdgeInsets.all(20),
                          hintText: 'Enter name of your assets',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? 'This field is required'
                              : null;
                        },
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (_) {
                          currentFocus.requestFocus(_amountFocusNode);
                        },
                        onSaved: (value) {
                          // int? name = int.tryParse(value ?? '');
                          if (value != null) {
                            _name = value;
                          }
                        },
                      ),
                      formGap,
                      const CustomFromLabel(label: "Amount", isRequired: true),
                      TextFormField(
                        initialValue: widget.assets?.amount != null
                            ? "${widget.assets?.amount}"
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
                      const CustomFromLabel(label: "Assets Date"),
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
                      const CustomFromLabel(label: "Assets Time"),
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: DateFormat('hh:mm a').format(_selectedDate)),
                        onTap: timePicker,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.watch_later_outlined),
                        ),
                      ),
                      formGap,
                      const CustomFromLabel(label: "Description"),
                      TextFormField(
                        initialValue: widget.assets?.description != null
                            ? "${widget.assets?.description}"
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'Write details about this expense',
                        ),
                        maxLines: 6,
                        minLines: 4,
                        onTap: () {
                          currentFocus
                              .requestFocus(_descriptionFocusNode);
                        },
                        textInputAction: TextInputAction.newline,
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
                                    assetsFormKey.currentState!;
                                formState.save();
                                formState.validate() ? _onSave() : null;
                                setState(() {
                                  _autovalidate = true;
                                });
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(MediaQuery.of(context).size.width * 0.9,
                                      50),
                                ),
                              ),
                              child: const Text("Submit")),
                        ],
                      ),
                      formGap,
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
