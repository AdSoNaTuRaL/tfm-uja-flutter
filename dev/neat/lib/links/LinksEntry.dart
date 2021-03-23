import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'LinksDBWorker.dart';
import 'LinksModel.dart';
import '../utils.dart' show scanQR;

class LinksEntry extends StatelessWidget {
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LinksEntry() {
    _descriptionEditingController.addListener(() {
      linksModel.entityBeingEdited.description =
          _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LinksModel>(
      model: linksModel,
      child: ScopedModelDescendant<LinksModel>(
        builder: (BuildContext context, Widget child, LinksModel model) {
          if (model.entityBeingEdited != null) {
            _descriptionEditingController.text =
                model.entityBeingEdited.description;
          }

          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: [
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate('cancel')),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        model.setStackIndex(0);
                      },
                    ),
                    Spacer(),
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate('save')),
                      onPressed: () {
                        _save(context, linksModel);
                      },
                    ),
                  ],
                ),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.text_fields),
                      title: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context).translate('input_description')),
                        controller: _descriptionEditingController,
                        validator: (String value) {
                          if (value.length == 0) {
                            return AppLocalizations.of(context).translate('message_description');
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text(AppLocalizations.of(context).translate('qr_read')),
                      subtitle: Text(_actLink()),
                      trailing: IconButton(
                        icon: Icon(Icons.camera_alt),
                        color: Colors.blue,
                        onPressed: () async {
                          String chosenLink = await scanQR(context, linksModel,
                              linksModel.entityBeingEdited.actLink);
                          if (chosenLink != null) {
                            linksModel.entityBeingEdited.actLink = chosenLink;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _actLink() {
    if (linksModel.entityBeingEdited != null &&
        linksModel.entityBeingEdited.hasLink()) {
      return linksModel.entityBeingEdited.actLink;
    }
    return '';
  }

  void _save(BuildContext context, LinksModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (model.entityBeingEdited.id == null) {
      await LinksDBWorker.db.create(linksModel.entityBeingEdited);
    } else {
      await LinksDBWorker.db.update(linksModel.entityBeingEdited);
    }

    linksModel.loadData(LinksDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text(AppLocalizations.of(context).translate('link_saved')),
      ),
    );
  }
}
