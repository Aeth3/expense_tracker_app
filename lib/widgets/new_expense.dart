import 'dart:io';

import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onAddExpense, super.key});

  // Add functionality - define a function
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, initialDate: now, firstDate: firstDay, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter a valid title, amount, date, and category.'),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OKAY',
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter a valid title, amount, date, and category.'),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OKAY',
              ),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final submittedAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = submittedAmount == null || submittedAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _addressController.text.trim().isEmpty) {
          _showDialog();
      return;
    }
    // Add functionality - Use class constructor to get its value for each properties.
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: submittedAmount,
        date: _selectedDate!,
        category: _selectedCategory,
        address: _addressController.text,
      ),
    );
    Navigator.pop(context);
  }

  Widget _titleWidget() {
    return TextField(
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
      controller: _titleController,
    );
  }

  Widget _addressWidget() {
    return TextField(
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Address'),
      ),
      controller: _addressController,
    );
  }

  Widget _amountWidget() {
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: 10,
      decoration: const InputDecoration(
        prefixText: '\$',
        label: Text('Amount'),
      ),
      controller: _amountController,
    );
  }

  Widget _categoryWidget() {
    return DropdownButton(
      value: _selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(category.name.toUpperCase()),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(
          () {
            _selectedCategory = value;
          },
        );
      },
    );
  }

  Widget _dateWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_selectedDate == null
            ? 'No date selected'
            : formatter.format(_selectedDate!)),
        IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month)),
      ],
    );
  }

  Widget _cancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        _submitExpenseData();
      },
      child: const Text('Save Expense'),
    );
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _titleWidget()),
                        const SizedBox(width: 24),
                        Expanded(child: _addressWidget()),
                      ],
                    )
                  else
                    _titleWidget(),
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _amountWidget(),
                        ),
                        const Spacer(),
                        _categoryWidget(),
                        Expanded(child: _dateWidget())
                      ],
                    )
                  else
                    Column(
                      children: [
                        _addressWidget(),
                        Row(
                          children: [
                            Expanded(
                              child: _amountWidget(),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(child: _dateWidget())
                          ],
                        ),
                      ],
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        _cancelButton(),
                        const SizedBox(
                          width: 10,
                        ),
                        _saveButton()
                      ],
                    )
                  else
                    Row(
                      children: [
                        _categoryWidget(),
                        const Spacer(),
                        _cancelButton(),
                        const SizedBox(
                          width: 10,
                        ),
                        _saveButton(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
