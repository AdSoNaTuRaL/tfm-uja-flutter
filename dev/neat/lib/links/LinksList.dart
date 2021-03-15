import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
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
                Link link = linksModel.entityList[index];
                String actLink;
                if (link.actLink != null) {
                  actLink = link.actLink;
                }
                return GestureDetector(
                  child: Container(
                    color: iterateColor(),
                    child: Center(
                      child: Text(
                        "${link.description}",
                        style: link.completed
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
                  onDoubleTap: () async {
                    if (await canLaunch(link.actLink)) {
                      await launch(link.actLink, forceWebView: true);
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context).translate('error_url')),
                        ),
                      );
                    }
                  },
                  onTap: () async {
                    if (link.actLink != null) {
                      return;
                    }

                    linksModel.entityBeingEdited =
                        await LinksDBWorker.db.get(link.id);
                    if (linksModel.entityBeingEdited.actLink == null) {
                      linksModel.setChosenLink(null);
                    } else {
                      linksModel.setChosenLink(actLink);
                    }
                    linksModel.setStackIndex(1);
                  },
                  onLongPress: () => _deleteLink(context, link),
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
          title: Text(AppLocalizations.of(context).translate('link_delete')),
          content: Text(
              '${AppLocalizations.of(context).translate('really_delete')} ${note.description}?'),
          actions: [
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('cancel')),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('delete')),
              onPressed: () async {
                await LinksDBWorker.db.delete(note.id);
                Navigator.of(alertContext).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text(
                        AppLocalizations.of(context).translate('link_deleted')),
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
