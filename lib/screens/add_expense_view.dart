import 'package:flutter/material.dart';


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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Text('Add Expense',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          ),
          SizedBox(height: 20),

          //title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Enter Expense Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15),
              ),
              )
            ),
          ),
          SizedBox(height: 20),

          //amount
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Enter Expense Amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Expense Type'),
              SizedBox(width: 60),
              ToggleButtons(
                onPressed: (index) {
                  setState(() {
                    _isSelected[index] = !_isSelected[index];
                  });
                },
                isSelected: _isSelected,
                children: [
                  Icon(Icons.arrow_upward),
                  Icon(Icons.arrow_downward),
                ],
              ),
            ],
          ),

          Spacer(),
          ElevatedButton(onPressed: () {
            final amount = double.tryParse(_amountController.text);
              if (amount == null || amount <= 0) {
                Navigator.pop(context);
                widget.onInvalidAmount();
                return;
              } 
              
            Navigator.pop(context, {
              'title': _titleController.text.isNotEmpty
               ? _titleController.text : 'No Title',
              'amount': amount,
              'isInCome': _isSelected[0]
            });
          }, child: Text('Add')),
        ],
      ),
    );
  }
}
