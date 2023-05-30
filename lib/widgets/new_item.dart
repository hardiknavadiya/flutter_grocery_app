import 'dart:convert';
import 'package:flutter_application_4/models/grocery.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../data/dummy_category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var formKey = GlobalKey<FormState>();
  var enteredName = "";
  int enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;
  bool spinner = false;

  saveItem() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        spinner = true;
      });

      formKey.currentState?.save();
      var url = Uri.https(
          'shopping-974cb-default-rtdb.firebaseio.com', 'shopping-list.json');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': selectedCategory.title
          }));

      Map<String, dynamic> resData = json.decode(response.body);
      setState(() {
        spinner = false;
      });
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          name: enteredName,
          id: resData['name'],
          quantity: enteredQuantity,
          category: selectedCategory));
      spinner = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Grocery Item')),
        body: spinner
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextFormField(
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  label: Text("Enter Name")),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1 ||
                                    value.trim().length > 50) {
                                  return 'Must be between 1 to 50 character';
                                }
                                return null;
                              },
                              onSaved: (newValue) => enteredName = newValue!,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        label: Text("Enter Quantity")),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          int.tryParse(value) == null ||
                                          int.tryParse(value)! <= 0) {
                                        return 'Must be Positive number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    initialValue: enteredQuantity.toString(),
                                    onSaved: (newValue) => enteredQuantity =
                                        int.tryParse(newValue!)!,
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    items: [
                                      for (var category in categories.entries)
                                        DropdownMenuItem(
                                            value: category.value,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  color: category.value.color,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(category.value.title)
                                              ],
                                            ))
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        selectedCategory = val!;
                                      });
                                    },
                                    value: selectedCategory,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  formKey.currentState!.reset();
                                },
                                child: const Text("Clear")),
                            const SizedBox(
                              width: 35,
                            ),
                            ElevatedButton(
                                onPressed: saveItem,
                                child: const Text("Add Item"))
                          ],
                        )
                      ],
                    )),
              ));
  }
}
