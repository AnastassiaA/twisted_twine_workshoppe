import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/expense_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/expense_used_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/income_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/income_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/expense_used_model.dart';
import 'package:twisted_twine_workshopppe/Views/Animations/expandable_fab_class.dart';

import '../../../Models/Models/expense_model.dart';
import '../../../Models/Models/income_model.dart';
import '../../../Models/Models/income_used_model.dart';

class ExpenseDepositUsedPage extends StatefulWidget {
  final int taskNumber;
  const ExpenseDepositUsedPage(this.taskNumber, {super.key});

  @override
  State<ExpenseDepositUsedPage> createState() => _ExpenseDepositUsedPageState();
}

class _ExpenseDepositUsedPageState extends State<ExpenseDepositUsedPage> {
  List<ExpenseUsedModel> expenseUsedList = [];
  List<IncomeUsedModel> incomeUsedList = [];

  List<ExpenseModel> expenseList = [];
  List<IncomeModel> incomeList = [];

  bool isExpenseLoading = true;
  bool isIncomeLoading = true;

  List<ExpenseModel> showExpenseList = [];
  List<IncomeModel> showIncomeList = [];

  // List<double> expenseCost = [];
  // List<double> incomeCost = [];

  getAllExpenses() async {
    final showExpenseData = await ExpenseController.getAllExpenses();

    setState(() {
      showExpenseList =
          showExpenseData.map((e) => ExpenseModel.fromMap(e)).toList();
    });
  }

  getAllIncome() async {
    final showIncomeData = await IncomeController.getAllIncome();

    setState(() {
      showIncomeList =
          showIncomeData.map((e) => IncomeModel.fromMap(e)).toList();
    });
  }

  getAllExpensesUsed() async {
    final expenseUsedData =
        await ExpenseUsedController.getAllExpenseUsed(widget.taskNumber);

    expenseUsedList =
        expenseUsedData.map((e) => ExpenseUsedModel.fromMap(e)).toList();

    for (int index = 0; index < expenseUsedList.length; index++) {
      final expenseData = await ExpenseController.getOneExpense(
          expenseUsedList[index].expenseId);

      expenseList
          .add(expenseData.map((e) => ExpenseModel.fromMap(e)).toList().single);
    }

    setState(() {
      expenseList;
      expenseUsedList;
      isExpenseLoading = false;
    });
  }

  getAllIncomeUsed() async {
    final incomeUsedData =
        await IncomeUsedController.getAllIncomeUsed(widget.taskNumber);

    incomeUsedList =
        incomeUsedData.map((e) => IncomeUsedModel.fromMap(e)).toList();

    for (int index = 0; index < incomeUsedList.length; index++) {
      final incomeData =
          await IncomeController.getOneIncome(incomeUsedList[index].incomeId);

      incomeList
          .add(incomeData.map((e) => IncomeModel.fromMap(e)).toList().single);
    }

    setState(() {
      incomeList;
      incomeUsedList;
      isIncomeLoading = false;
    });
  }

  @override
  void initState() {
    getAllExpenses();
    getAllExpensesUsed();
    getAllIncome();
    getAllIncomeUsed();
    super.initState();
  }

  Future refreshExpenses() async {
    expenseList.clear();
    expenseUsedList.clear();
    getAllExpensesUsed();
  }

  Future refreshDeposit() async {
    incomeList.clear();
    incomeUsedList.clear();
    getAllIncomeUsed();
  }

  showExpenseListModal() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => ListView.builder(
              itemCount: showExpenseList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    child: ListTile(
                      dense: true,
                      title: showExpenseList[index].taskName == ''
                          ? Text(showExpenseList[index].expenseType)
                          : Text('${showExpenseList[index].expenseType}: '
                              '${showExpenseList[index].taskName}'),
                      subtitle: Text(showExpenseList[index].expenseDescription),
                      trailing: Text(
                          "\$ ${showExpenseList[index].amount.toStringAsFixed(2)}"),
                      onTap: () {
                        setState(() {
                          expenseList.add(showExpenseList[index]);

                          expenseUsedList.add(ExpenseUsedModel(
                            taskNumber: widget.taskNumber,
                            expenseId: showExpenseList[index].expenseId!,
                            expenseCost: showExpenseList[index].amount,
                          ));
                        });

                        if (!mounted) return;
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                );
              }),
            ));
  }

  showIncomeListModal() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => ListView.builder(
              itemCount: showIncomeList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    child: ListTile(
                      dense: true,
                      title: showIncomeList[index].taskName == ''
                          ? Text(showIncomeList[index].incomeType)
                          : Text('${showIncomeList[index].incomeType}: '
                              '${showIncomeList[index].taskName}'),
                      subtitle: Text(showIncomeList[index].incomeDescription),
                      trailing: Text(
                          "\$ ${showIncomeList[index].amount.toStringAsFixed(2)}"),
                      onTap: () {
                        setState(() {
                          incomeList.add(showIncomeList[index]);

                          incomeUsedList.add(
                            IncomeUsedModel(
                                incomeId: showIncomeList[index].incomeId!,
                                taskNumber: widget.taskNumber,
                                amount: showIncomeList[index].amount),
                          );
                        });

                        if (!mounted) return;
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                );
              }),
            ));
  }

  Future<void> _updateExpenseUsed() async {
    for (int index = 0; index < expenseUsedList.length; index++) {
      if (expenseUsedList[index].expenseUsedId != null) {
        ExpenseUsedModel expenseUsed = ExpenseUsedModel(
            expenseCost: expenseUsedList[index].expenseCost,
            expenseUsedId: expenseUsedList[index].expenseUsedId,
            taskNumber: widget.taskNumber,
            expenseId: expenseUsedList[index].expenseId);

        await ExpenseUsedController.updateExpenseUsed(expenseUsed);
      } else {
        ExpenseUsedModel expenseUsed = ExpenseUsedModel(
            expenseCost: expenseUsedList[index].expenseCost,
            taskNumber: widget.taskNumber,
            expenseId: expenseUsedList[index].expenseId);

        await ExpenseUsedController.createExpenseUsed(expenseUsed);
      }
    }
  }

  Future<void> _updateIncomeUsed() async {
    for (int index = 0; index < incomeUsedList.length; index++) {
      if (incomeUsedList[index].incomeUsedId != null) {
        IncomeUsedModel incomeUsed = IncomeUsedModel(
            incomeUsedId: incomeUsedList[index].incomeUsedId,
            incomeId: incomeUsedList[index].incomeId,
            taskNumber: widget.taskNumber,
            amount: incomeUsedList[index].amount);

        await IncomeUsedController.updateIncomeUsed(incomeUsed);
      } else {
        IncomeUsedModel incomeUsed = IncomeUsedModel(
            incomeId: incomeUsedList[index].incomeId,
            taskNumber: widget.taskNumber,
            amount: incomeUsedList[index].amount);

        await IncomeUsedController.createIncomeUsed(incomeUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses and Deposits"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Expense",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await _updateExpenseUsed();
                    //refreshExpenses();
                  },
                  icon: const Icon(Icons.save)),
            ],
          ),
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
              height: MediaQuery.of(context).size.width * 1,
              child: expenseList.isEmpty
                  ? const Center(child: Text("No expense currently"))
                  : ListView.builder(
                      itemCount: expenseList.length,
                      itemBuilder: (context, index) {
                        final expense = expenseList[index];

                        return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              setState(() {
                                if (expenseUsedList[index].expenseUsedId !=
                                    null) {
                                  ExpenseUsedController.deleteExpenseUsed(
                                      expenseUsedList[index].expenseUsedId!);
                                }

                                expenseList.removeAt(index);
                                expenseUsedList.removeAt(index);
                              });

                              refreshExpenses();

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("$expense dismissed")));
                            },
                            background: Container(color: Colors.pinkAccent),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title:
                                    Text(expenseList[index].expenseDescription),
                                trailing: Text(
                                    '\$ ${expenseUsedList[index].expenseCost!.toStringAsFixed(2)}'),
                              ),
                            ));
                      }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Deposits",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await _updateIncomeUsed();
                    //refreshDeposit();
                  },
                  icon: const Icon(Icons.save)),
            ],
          ),
          Flexible(
            child: Container(
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: incomeList.isEmpty
                  ? const Center(child: Text("No deposit"))
                  : ListView.builder(
                      itemCount: incomeList.length,
                      itemBuilder: (context, index) {
                        final income = incomeList[index];

                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            setState(() {
                              IncomeUsedController.deleteIncomeUsed(
                                  incomeUsedList[index].incomeUsedId!);

                              incomeList.removeAt(index);
                              incomeUsedList.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$income dismissed")));
                          },
                          background: Container(color: Colors.pinkAccent),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(incomeList[index].incomeDescription),
                              trailing: Text(
                                  '\$ ${incomeUsedList[index].amount.toStringAsFixed(2)}'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          ExpandableFabClass(distanceBetween: 80.0, subChildren: [
        TextButton.icon(
          onPressed: () => showExpenseListModal(),
          icon: const Icon(Icons.add),
          label: const Text("Expense"),
        ),
        TextButton.icon(
            onPressed: () => showIncomeListModal(),
            icon: const Icon(Icons.add),
            label: const Text("Deposit"))
      ]),
    );
  }
}
