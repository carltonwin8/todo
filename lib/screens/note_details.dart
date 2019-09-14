import 'package:flutter/material.dart';
import 'package:todo/models/note.dart';

import 'route_arguments.dart';
import '../utils/notes_db.dart';

class NoteDetails extends StatefulWidget {
  static const String routeID = 'listDetails';
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  var _formKey = GlobalKey<FormState>();
  NotesDb notesDb = NotesDb();
  String priority = notePrioritiesString[0];
  @override
  Widget build(BuildContext context) {
    void _showAlertDialog(String title, String message) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
        ),
      );
    }

    final RouteArguments args = ModalRoute.of(context).settings.arguments;
    final Note note = args.note;
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Item - ${args.title}'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: <Widget>[
                  Text('Priority'),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButton(
                      //value: priorityDefault,
                      //items: notePrioritiesString
                      value: priority,
                      items: notePrioritiesString
                          .map(
                            (val) => DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            ),
                          )
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          priority = newValue;
                        });
                        note.priority = Note.getPriorityFromString(newValue);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: TextEditingController(text: note.title),
                decoration: InputDecoration(
                    labelText: 'Title',
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    )),
                validator: (value) => value.isEmpty ? 'Enter a title.' : null,
                onChanged: (value) => note.title = value,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: TextEditingController(text: note.description),
                decoration: InputDecoration(
                    labelText: 'Description',
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                    )),
                validator: (value) =>
                    value.isEmpty ? 'Enter a description.' : null,
                onChanged: (value) => note.description = value,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text('Save'),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) return;
                        int result;
                        if (note.id != null)
                          result = await notesDb.update(note);
                        else
                          result = await notesDb.insert(note);
                        Navigator.pop(context);
                        if (result != 0)
                          _showAlertDialog('Status', 'Note Saved');
                        else
                          _showAlertDialog('Status', 'Error! Note NOT Saved');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text('Delete'),
                      color: Colors.blue,
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) return;
                        if (note.id != null) await notesDb.delete(note.id);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
