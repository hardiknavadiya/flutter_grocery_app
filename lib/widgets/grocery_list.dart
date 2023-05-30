import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/data/dummy_category.dart';
import 'package:flutter_application_4/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import '../models/grocery.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryList = [];
  bool spinner = true;
  loadGroceryList() async {
    var url = Uri.https(
        'shopping-974cb-default-rtdb.firebaseio.com', 'shopping-list.json');
    var response = await http.get(url);
    print(response.body);
    if (response.body == 'null') {
      setState(() {
        spinner = false;
      });
      return;
    }
    Map<String, dynamic> newGroceryList = json.decode(response.body);
    List<GroceryItem> updatedGroceryList = [];
    for (var item in newGroceryList.entries) {
      var category = categories.entries
          .firstWhere((cat) => cat.value.title == item.value['category']);
      updatedGroceryList.add(GroceryItem(
          name: item.value['name']!,
          id: item.key,
          quantity: item.value['quantity'],
          category: category.value));
    }
    setState(() {
      groceryList = updatedGroceryList;
      spinner = false;
    });
  }

  addItemnav() async {
    var item = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));
    setState(() {
      groceryList.add(item);
    });
  }

  void removeGrocery(GroceryItem item) {
    var url = Uri.https('shopping-974cb-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    http.delete(url);
    setState(() {
      groceryList.remove(item);
    });
  }

  @override
  void initState() {
    loadGroceryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Grocery'), actions: [
          IconButton(onPressed: addItemnav, icon: const Icon(Icons.add))
        ]),
        body: spinner
            ? const Center(child: CircularProgressIndicator())
            : groceryList.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: groceryList.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: ValueKey(groceryList[index].id),
                        onDismissed: (direction) {
                          removeGrocery(groceryList[index]);
                        },
                        child: ListTile(
                          leading: Container(
                            height: 24,
                            width: 24,
                            color: groceryList[index].category.color,
                          ),
                          title: Text(groceryList[index].name),
                          trailing:
                              Text(groceryList[index].quantity.toString()),
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text("No Item Added Yet")));
  }
}
