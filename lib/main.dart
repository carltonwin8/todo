import 'package:flutter/material.dart';
import 'package:todo/screens/note_details.dart';
import 'package:todo/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: NoteList.routeID,
      routes: {
        NoteList.routeID: (context) => NoteList(),
        NoteDetails.routeID: (context) => NoteDetails(),
      },
    );
  }
}
