import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksDBWorker.dart';
import 'LinksModel.dart' show Link, LinksModel, linksModel;

class LinksList extends StatelessWidget {
  static num colorPicker = 0;
  static final colors = [
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.greenAccent
  ];

  Color iterateColor() {
    colorPicker = (colorPicker + 1) % 4;
    return colors[colorPicker];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
      model: linksModel,
      child: ScopedModelDescendant<LinksModel>(
        builder: (BuildContext context, Widget child, LinksModel model) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                linksModel.entityBeingEdited = Link();
                linksModel.setStackIndex(1);
              },
            ),
            body: GridView.builder(
              itemCount: linksModel.entityList.length,
              itemBuilder: (BuildContext context, int index) {
                Link task = linksModel.entityList[index];
                String actLink;
                if (task.actLink != null) {
                  actLink = task.actLink;
                }
                return GestureDetector(
                  child: Container(
                    color: iterateColor(),
                    child: Center(
                      child: Text(
                        "${task.description}",
                        style: task.completed
                            ? TextStyle(
                                color: Theme.of(context).disabledColor,
                                decoration: TextDecoration.lineThrough,
                              )
                            : TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (task.completed) {
                      return;
                    }
                    linksModel.entityBeingEdited =
                        await LinksDBWorker.db.get(task.id);
                    if (linksModel.entityBeingEdited.actLink == null) {
                      linksModel.setChosenLink(null);
                    } else {
                      linksModel.setChosenLink(actLink);
                    }
                    linksModel.setStackIndex(1);
                  },
                  onLongPress: () => _deleteLink(context, task),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Future _deleteLink(BuildContext context, Link note) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Delete QR Scan'),
          content: Text('Really delete ${note.description}?'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await LinksDBWorker.db.delete(note.id);
                Navigator.of(alertContext).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text('Link deleted'),
                  ),
                );
                linksModel.loadData(LinksDBWorker.db);
              },
            )
          ],
        );
      },
    );
  }
}
