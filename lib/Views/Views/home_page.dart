import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/home_page_controller.dart';
import '../left_main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//orientationBuilder

  double income = 0.0, expense = 0.0, incoming = 0.0, outgoing = 0.0;
  double wallet = 0.0;
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
        wallet = 0.00;
      } else {
        wallet = sum;
      }
    });
  }

  @override
  void initState() {
    homePage();
    super.initState();
  }

  Widget _flexiblePortraitLayout() {
    return Container(
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
      child: Column(
        children: [
          Flexible(
            flex: 6,
            child: SizedBox(
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffE5B80B), width: 3.0),
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                              Stack(
                                children: [
                                  Text(
                                    '$current',
                                    style: TextStyle(
                                      fontSize: 80,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = Colors.teal,
                                    ),
                                  ),
                                  Text(
                                    '$current',
                                    style: const TextStyle(
                                        fontSize: 80, color: Colors.white),
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
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffE5B80B), width: 3.0),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffE5B80B), width: 3.0),
                              image: const DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage('images/expense.jpeg'),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
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
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffE5B80B), width: 3.0),
                              image: const DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage('images/income.jpeg'),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
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
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffE5B80B), width: 3.0),
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox( 
                        height: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffE5B80B), width: 3.0),
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
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE5B80B), width: 3.0),
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
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _flexibleLandscapeLayout() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
          Color(0xffe7d0f5),
            Color(0xff301934)
            
          ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //wallet
                Flexible(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE5B80B), width: 3.0),
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
                const SizedBox(height: 10),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 5),
                        //in progress
                        Container(
                          width: MediaQuery.of(context).size.width / 4 - 5,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffE5B80B), width: 3.0),
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                              Stack(
                                children: [
                                  Text(
                                    '$current',
                                    style: TextStyle(
                                      fontSize: 80,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = Colors.teal,
                                    ),
                                  ),
                                  Text(
                                    '$current',
                                    style: const TextStyle(
                                        fontSize: 80, color: Colors.white),
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
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        //pending
                        Container(
                          width: MediaQuery.of(context).size.width / 4 - 5,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffE5B80B), width: 3.0),
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                              Stack(
                                children: [
                                  Text(
                                    '$pending',
                                    style: TextStyle(
                                      fontSize: 80,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 4
                                        ..color = Colors.teal,
                                    ),
                                  ),
                                  Text('$pending',
                                      style: const TextStyle(
                                          fontSize: 80, color: Colors.white))
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
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            child: Column(
              children: [
                //income
                Flexible(
                  flex: 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4 - 5,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffE5B80B), width: 3.0),
                        image: const DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('images/income.jpeg'),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white))
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
                const SizedBox(
                  height: 10,
                ),
                //out
                Flexible(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4 - 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE5B80B), width: 3.0),
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
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
              child: Column(
            children: [
              //in
              Flexible(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width / 4 - 5,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE5B80B), width: 3.0),
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
              const SizedBox(
                height: 10,
              ),
              //expense
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width / 4 - 5,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE5B80B), width: 3.0),
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('images/expense.jpeg'),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white))
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

              const SizedBox(
                height: 5,
              ),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Twisted Twine Workshoppe',
          ),
          //backgroundColor: const Color(0xffe7d0f5),
        ),
        drawer: const LeftMainDrawer(),
        body: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _flexiblePortraitLayout()
              : _flexibleLandscapeLayout();
        }));
  }
}
