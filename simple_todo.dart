/*
  Simple TODO App;
  Can create TODOs with a specific date.  List date shows RED if late, GREEN if not late.
  Checkmark to mark as done,
  NO SAVING FUNCTIONALITY.

  example image: https://gyazo.com/650ae262340a082621349317fe2bfcb0
*/

// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Pair<F, S> {
  final F first;
  final S second;
  const Pair(this.first, this.second);
  static Pair<F, S> create<F, S>(F f, S s) {
    return Pair<F, S>(f, s);
  }
  Pair<F, S> fromType(F f, S s) {
    return Pair<F, S>(f, s);
  }
  Pair<F, S> clone() {
    return Pair<F, S>(this.first, this.second);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key
  });

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  List<Pair<String, Pair<DateTime, bool>>> todos = [];
  bool isCreating = false;
  DateTime? chosenDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Simple TODO App"))
        ),
        body: Center(
          child: ListView.builder(
            itemCount: todos.length + (isCreating ? 1 : 0),
            itemBuilder: (context, index) {
              if(index == todos.length && isCreating) {
                return ListTile(
                  title: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Item',
                        ),
                        onSubmitted: (value) {
                          chosenDate ??= DateTime.now().add(Duration(days: 1));
                          setState(() {
                            todos.add(Pair.create(value, Pair.create(chosenDate!, false)));
                            isCreating = false;
                            todos.sort((a, b) => a.second.first.compareTo(b.second.first));
                          });
                        },
                        autofocus: true,
                      ),
                      CalendarDatePicker(
                        initialDate: DateTime.now(), 
                        firstDate: DateTime.now().add(Duration(days: -(365 * 10))), 
                        lastDate: DateTime.now().add(Duration(days: (365 * 10))), 
                        onDateChanged: (newDate) {
                          chosenDate = newDate;
                        }
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isCreating = false;
                      });
                    }
                  )
                );
              }
              DateTime date = todos[index].second.first;
              bool isLate = !date.isAfter(DateTime.now());
              return ListTile(
                title: Text(todos[index].first),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: [
                    Text(
                      '${date.month}/${date.day}/${date.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: (isLate ? Colors.red : Colors.green)
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          todos.removeAt(index);
                          todos.sort((a, b) => a.second.first.compareTo(b.second.first));
                        });
                      }
                    ),
                    Checkbox(
                      value: todos[index].second.second,
                      onChanged: (value) {
                        setState(() {
                          todos[index] = todos[index].fromType(
                            todos[index].first, todos[index].second.fromType(
                              todos[index].second.first, value!
                            )
                          );
                          todos.sort((a, b) => a.second.first.compareTo(b.second.first));
                        });
                      },
                    ),
                  ]
                ),
              );
            },
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isCreating = true;
            });
          },
          child: Icon(Icons.add),
        ),
      )
    );
  }
}
