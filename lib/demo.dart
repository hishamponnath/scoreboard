import 'package:flutter/material.dart';

class MyDropDownButton extends StatefulWidget {
  const MyDropDownButton({super.key});

  @override
  State<MyDropDownButton> createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  String? _selectedItem = 'item 1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text("DropDownButton"),
          centerTitle: true,
        ),
        body: Center(
          child: DropdownButton(
              value: _selectedItem,
              items: ['item1', 'item2', 'item3', 'item4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                     child: Text(value),
                     );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              }),
        ));
  }
}
