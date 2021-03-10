import 'package:Neat/links/LinksDBWorker.dart';
import 'package:Neat/links/LinksEntry.dart';
import 'package:Neat/links/LinksList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksModel.dart' show LinksModel, linksModel;

class Links extends StatelessWidget {
  Links() {
    linksModel.loadData(LinksDBWorker.db);
  }

  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
      model: linksModel,
      child: ScopedModelDescendant<LinksModel>(
        builder: (BuildContext context, Widget child, LinksModel model) {
          return IndexedStack(
            index: model.stackIndex,
            children: [
              LinksList(),
              LinksEntry(),
            ],
          );
        },
      ),
    );
  }
}
