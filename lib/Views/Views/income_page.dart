import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twisted_twine_workshopppe/Controllers/income_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/income_model.dart';

import '../Forms/add_income.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List<IncomeModel> incomeList = [];
  bool isLoading = true;

  getAllIncome() async {
    final incomeData = await IncomeController.getAllIncome();

    setState(() {
      incomeList = incomeData.map((e) => IncomeModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllIncome();
    super.initState();
  }

  Future refresh() async {
    incomeList.clear();
    getAllIncome();
  }

  void deleteIncome(
      {required IncomeModel income, required BuildContext context}) async {
    IncomeController.deleteIncome(income.incomeId!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${income.incomeDescription} deleted')));
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
              itemCount: incomeList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      DateFormat("MMMM-dd-yyyy").format(incomeList[index].date),
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
                        title: Text(incomeList[index].incomeType),
                        subtitle: Text('${incomeList[index].disbursedFrom}'
                            '\n'
                            '${incomeList[index].incomeDescription}'),
                        trailing: Text('\$ ' '${incomeList[index].amount}'),
                        onLongPress: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '
                                    '"'
                                    '${incomeList[index].incomeType}'
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
                                        deleteIncome(
                                            income: incomeList[index],
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
            MaterialPageRoute(builder: (context) => const AddIncomeForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
