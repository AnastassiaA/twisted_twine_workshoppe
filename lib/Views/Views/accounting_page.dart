import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Views/Views/expense_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/income_page.dart';
import 'package:twisted_twine_workshopppe/Views/Views/payment_methods_page.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: const [
              Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,

            ),
            
          ),
            ],
            title: const Text("Accounting"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text("Expense"),
                ),
                Tab(
                  child: Text("Income"),
                ),
                Tab(
                  child: Icon(Icons.credit_card_outlined),
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ExpensePage(),
              IncomePage(),
              PaymentMethodsPage(),
            ],
          ),
        ));
  }
}
