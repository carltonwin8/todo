import 'package:flutter/material.dart';

import '../models/note.dart';
import '../utils/notes_db.dart';

import 'route_arguments.dart';

class NoteList extends StatefulWidget {
  static const String routeID = 'listItems';
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesDb notesDb = NotesDb();
  List<Note> notes = List<Note>();
  int count = 0;

  @override
  initState() {
    super.initState();
    _updateListView();
  }

  _updateListView() async {
    notes = await notesDb.getNotes();
    setState(() {
      count = notes.length;
    });
  }

  _delete(BuildContext context, Note note) async {
    int result = await notesDb.delete(note.id);
    if (result != 0) _showSnackBar(context, 'Note deleted successfully');
    _updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: (notes.length == 0)
          ? Center(child: Text('No notes'))
          : getNotesView(notes),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add item to list',
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            'listDetails',
            arguments: RouteArguments('Add', Note('', '', NotePriority.Low)),
          );
          _updateListView();
        },
      ),
    );
  }

  ListView getNotesView(List<Note> notes) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, idx) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notes[idx].priority == NotePriority.Low
                  ? Colors.yellow
                  : Colors.red,
              child: Icon(Icons.chevron_right),
            ),
            title: Text(notes[idx].title),
            subtitle: Text(notes[idx].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () => _delete(context, notes[idx]),
            ),
            onTap: () async {
              await Navigator.pushNamed(context, 'listDetails',
                  arguments: RouteArguments('Edit', notes[idx]));
              _updateListView();
            },
          ),
        );
      },
    );
  }
}
