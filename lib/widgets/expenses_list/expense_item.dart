import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(context) {
    Color? cardColor;
    if (expense.amount >= 300) {
      cardColor = Colors.red;
    }
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  expense.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.location_on),
                Text(
                  expense.address,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(children: [
              Text('\$${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Icon(categoryIcons[expense.category]),
              const SizedBox(
                width: 5,
              ),
              Text(expense.formattedDate)
            ])
          ],
        ),
      ),
    );
  }
}
