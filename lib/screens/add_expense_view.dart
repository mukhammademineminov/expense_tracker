import 'package:expense_tracker/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/models/transaction.dart';

import 'package:expense_tracker/widgets/popup_menu.dart';
import 'package:expense_tracker/widgets/textfield.dart';

class AddExpenseView extends StatefulWidget {
  final VoidCallback onInvalidAmount;
  const AddExpenseView({super.key, required this.onInvalidAmount});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  final List<bool> _isSelected = [true, false];
  late Category _selectedCategory = Category.other;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Expense',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              //title
              CustomTextField(
                label: 'Enter Expense Title',
                controller: _titleController,
              ),
              SizedBox(height: 20),

              //amount
              CustomTextField(
                label: 'Enter Expense Amount',
                controller: _amountController,
                prefixIcon: Icon(Icons.attach_money),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),

              SizedBox(height: 20),

              //expense type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(_isSelected[0] ? 'Income' : 'Expense'),
                  Spacer(),
                  //upward and downward buttons
                  ToggleButtons(
                    onPressed: (index) {
                      setState(() {
                        for (var i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      });
                    },
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    isSelected: _isSelected,
                    children: [
                      Icon(Icons.arrow_upward),
                      Icon(Icons.arrow_downward),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),

              //category
              if (!_isSelected[0]) //only show category dropdown for expenses
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text('Category:'),
                    Spacer(),
                    PopupMenu(
                      items: Category.values
                          .map(
                            (category) => PopupMenuItem(
                              value: category,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        setState(() => _selectedCategory = value);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCategory.name),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              SizedBox(height: 20),

              //add button
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text);
                  if (amount == null || amount <= 0) {
                    Navigator.pop(context);
                    widget.onInvalidAmount();
                    return;
                  }

                  Navigator.pop(context, {
                    'title': _titleController.text.isNotEmpty
                        ? _titleController.text
                        : 'No Title',
                    'amount': amount,
                    'isIncome': _isSelected[0],
                    'category': _selectedCategory.name,
                  });
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
