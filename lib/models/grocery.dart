import 'package:flutter_application_4/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;
  GroceryItem(
      {required this.name,
      required this.id,
      required this.quantity,
      required this.category});
}
