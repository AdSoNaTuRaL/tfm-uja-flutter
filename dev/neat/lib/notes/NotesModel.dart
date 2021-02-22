import '../BaseModel.dart';

NotesModel notesModel = NotesModel();

class Note {
  int id;
  String title;
  String content;
  String color;
  String toString() {
    return "{ id=$id, title=$title, content=$content, color=$color }";
  }
}

class NotesModel extends BaseModel<Note> {
  String color;
  void setColor(String color) {
    this.color = color;
    notifyListeners();
  }
}
