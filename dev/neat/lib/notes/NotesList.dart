import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesModel.dart' show Note, NotesModel;
import 'NotesDBWorker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                model.entityBeingEdited = Note();
                model.setColor(null);
                model.setStackIndex(1);
              }),
          body: ListView.builder(
              itemCount: model.entityList.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = model.entityList[index];
                Color color = _toColor(note.color);
                return Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        secondaryActions: [
                          IconSlideAction(
                              caption: AppLocalizations.of(context).translate('delete'),
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => _deleteNote(context, model, note))
                        ],
                        child: Card(
                            elevation: 8,
                            color: color,
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(note.content),
                              onTap: () {
                                model.entityBeingEdited = note;
                                model.setColor(model.entityBeingEdited.color);
                                model.setStackIndex(1);
                              },
                            ))));
              }));
    });
  }

  _deleteNote(BuildContext context, NotesModel model, Note note) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context).translate('note_delete')),
              content: Text("${AppLocalizations.of(context).translate('really_delete')} ${note.title}?"),
              actions: [
                TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(alertContext).pop();
                    }),
                TextButton(
                    child: Text(AppLocalizations.of(context).translate('delete')),
                    onPressed: () async {
                      await NotesDBWorker.db.delete(note.id);
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context).translate('note_deleted'))));
                      model.loadData(NotesDBWorker.db);
                    })
              ]);
        });
  }

  Color _toColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'grey':
        return Colors.grey;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}
