import 'package:flutter/material.dart';
import 'package:flutter_application_4/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Your Grocery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GroceryList());
  }
}
