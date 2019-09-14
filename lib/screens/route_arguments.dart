import '../models/note.dart';

class RouteArguments {
  final Note note;
  final String title;

  RouteArguments(this.title, this.note);
}
