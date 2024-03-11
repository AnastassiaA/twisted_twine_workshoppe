import 'package:flutter/material.dart';

import 'Views/Views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'CabinSketch',
          //primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            color: Color(0xffe7d0f5),
          ),
          scaffoldBackgroundColor:
              //const Color(0xffe7d0f5),
              const Color(0xffefdff9),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xff997ABD)),
        ),
        home: const HomePage());
  }
}
