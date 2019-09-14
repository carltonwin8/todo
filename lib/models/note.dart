import '../utils/notes_db_var.dart';

enum NotePriority { Low, High }
notePriorityString(NotePriority np) => np.toString().split('.')[1];
final notePrioritiesString =
    NotePriority.values.fold([], (a, v) => [...a, notePriorityString(v)]);

class Note {
  int _id;
  String title;
  String description;
  String date;
  NotePriority priority;

  Note(this.title, this.date, this.priority, [this.description]);
  Note.withId(this._id, this.title, this.date, this.priority,
      [this.description]);

  int get id => _id;

  static NotePriority getPriorityFromString(String priority) {
    for (NotePriority np in NotePriority.values) {
      if (notePriorityString(np) == priority) return np;
    }
    return NotePriority.Low;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map[NotesDbVar.id] = _id;
    map[NotesDbVar.title] = title;
    map[NotesDbVar.description] = description;
    map[NotesDbVar.priority] = notePriorityString(priority);
    map[NotesDbVar.date] = date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map[NotesDbVar.id];
    this.title = map[NotesDbVar.title];
    this.description = map[NotesDbVar.description];
    this.priority = getPriorityFromString(map[NotesDbVar.priority]);
    this.date = map[NotesDbVar.date];
  }
}
