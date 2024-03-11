import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twisted_twine_workshopppe/Controllers/expense_controller.dart';

import '../../Models/Models/expense_model.dart';
import '../Forms/add_expense.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<ExpenseModel> expenseList = [];
  bool isLoading = true;

  getAllExpense() async {
    final expenseData = await ExpenseController.getAllExpenses();

    setState(() {
      expenseList = expenseData.map((e) => ExpenseModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllExpense();
    super.initState();
  }

  Future refresh() async {
    expenseList.clear();
    getAllExpense();
  }

  void deleteExpense(
      {required ExpenseModel expense, required BuildContext context}) async {
    ExpenseController.deleteExpense(expense.expenseId!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${expense.expenseDescription} deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: expenseList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      DateFormat("MMMM-dd-yyyy").format(expenseList[index].date),
                      textAlign: TextAlign.left,
                    ),
                    Card(
                      child: ListTile(
                        // leading: Stack(
                        //   alignment: Alignment.center,
                        //   children: [
                        //     CircleAvatar(
                        //       backgroundColor: Colors.grey[350],
                        //       radius: 30,
                        //     ),
                        //     Text(
                        //       DateFormat.d().format(expenseList[index].date),
                        //       style: const TextStyle(fontSize: 20),
                        //     ),
                        //   ],
                        // ),
                        title: Text(expenseList[index].expenseType),
                        subtitle: Text('${expenseList[index].paidTo}' '\n' '${expenseList[index].expenseDescription}'),
                        trailing: Text('\$ ''${expenseList[index].amount}'),
                        onLongPress: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '
                                    '"'
                                    '${expenseList[index].expenseType}'
                                    '"'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Are you sure?'),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        // final result = await OrderController()
                                        //     .deleteOrder(
                                        //         _ordersList[index].orderNumber);
                                        deleteExpense(
                                            expense: expenseList[index],
                                            context: context);

                                        if (!mounted) return;

                                        Navigator.pop(
                                          context,
                                        );
                                        //getAllOrders();
                                        refresh();
                                      },
                                      child: const Text('Delete')),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
