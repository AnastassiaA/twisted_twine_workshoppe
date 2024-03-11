import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/home_page_controller.dart';
import '../left_main_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//create a staggard grid to contain
//# of inprogress and pending orders
//business wallet
//expense
//income
//transfer in
//transfer out

  double income = 0.0, expense = 0.0, incoming = 0.0, outgoing = 0.0;
  String wallet = '';
  int pending = 0, current = 0;

  Future homePage() async {
    final incomeData = (await HomePageController.allIncome())[0]['income'];
    final expenseData = (await HomePageController.allExpense())[0]['expense'];
    final pendingData =
        (await HomePageController.allPendingComms())[0]['pendingcount'];
    final currentData =
        (await HomePageController.allCurrentComms())[0]['currentcount'];
    final incomingData =
        (await HomePageController.allIncoming())[0]['incoming'];
    final outgoingData =
        (await HomePageController.allOutgoing())[0]['outgoing'];

    setState(() {
      if (incomeData != null) {
        income = incomeData;
        income.toStringAsFixed(2);
      }

      if (expenseData != null) {
        expense = expenseData;
      }

      if (pendingData != null) {
        pending = pendingData;
      }

      if (currentData != null) {
        current = currentData;
      }

      if (incomingData != null) {
        incoming = incomingData;
      }

      if (outgoingData != null) {
        outgoing = outgoingData;
      }

      // income.toStringAsFixed(2);
      // expense.toStringAsFixed(2);
      // incoming.toStringAsFixed(2);
      // outgoing.toStringAsFixed(2);

      double sum = ((income + incoming) - (expense + outgoing));
      
      if (sum.isNegative) {
        wallet = '0.00';
      } else {
        wallet = sum.toStringAsFixed(2);
      }
    });
  }

  @override
  void initState() {
    homePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenLength = MediaQuery.of(context).size.height;
    //can i use this to ascertain how many cells will fit the screen length?

    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Twisted Twine Workshoppe',
        ),
        //backgroundColor: const Color(0xffe7d0f5),
      ),
      drawer: const LeftMainDrawer(),
      body: Container(
        //height: screenLength,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              //Color(0xffefdff9),
              Color(0xffe7d0f5),
              Color(0xff301934)
              // Color(0xffC079D9),
              // Color(0xffB26CCE),
              // Color(0xffA460C3),
              // Color(0xff9653B8),
            ])),
        child: StaggeredGrid.count(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 6,
              //(MediaQuery.of(context).size.height / 6),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE5B80B), width: 3.0),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('images/order_inprogress.jpeg'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Commissions',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text('Commissions',
                            style: TextStyle(fontSize: 25, color: Colors.white))
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          '$current',
                          style: TextStyle(
                            fontSize: 90,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        Text(
                          '$current',
                          style: const TextStyle(
                              fontSize: 90, color: Colors.white),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          'In Progress',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text(
                          'In Progress',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 4,
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffE5B80B), width: 3.0),
                    image: const DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('images/income.jpeg'),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text('Income',
                            style: TextStyle(fontSize: 25, color: Colors.white))
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          '\$' '$income',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        Text('\$' '$income',
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 6,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE5B80B), width: 3.0),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('images/orders_pending.jpeg'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Commissions',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text('Commissions',
                            style: TextStyle(fontSize: 25, color: Colors.white))
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          '$pending',
                          style: TextStyle(
                            fontSize: 90,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        Text('$pending',
                            style: const TextStyle(
                                fontSize: 90, color: Colors.white))
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text('Pending',
                            style: TextStyle(fontSize: 25, color: Colors.white))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 2,
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffE5B80B), width: 3.0),
                    image: const DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('images/money_in.jpeg'),
                    )),
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        'In: ' '\$' '$incoming',
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.deepPurple,
                        ),
                      ),
                      Text('In: ' '\$' '$incoming',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 4,
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffE5B80B), width: 3.0),
                    image: const DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('images/expense.jpeg'),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        const Text('Expense',
                            style: TextStyle(fontSize: 25, color: Colors.white))
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          '\$' '$expense',
                          style: TextStyle(
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.teal,
                          ),
                        ),
                        Text('\$' '$expense',
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 2,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE5B80B), width: 3.0),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('images/out_red_arrow.jpeg'),
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        'Out: ' '\$' '$outgoing',
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.deepPurple,
                        ),
                      ),
                      Text('Out: ' '\$' '$outgoing',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 8,
              mainAxisCellCount: 2,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xffE5B80B), width: 3.0),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('images/ttc_wallet.jpeg'),
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        'Wallet: ' '\$' '$wallet',
                        style: TextStyle(
                          fontSize: 25,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.teal,
                        ),
                      ),
                      Text('Wallet: ' '\$' '$wallet',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
