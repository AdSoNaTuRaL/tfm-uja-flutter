import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart';
import '../utils.dart' as utils;

class ContactsEntry extends StatelessWidget {
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactsEntry() {
    _nameEditingController.addListener(() {
      contactsModel.entityBeingEdited.name = _nameEditingController.text;
    });
    _phoneEditingController.addListener(() {
      contactsModel.entityBeingEdited.phone = _phoneEditingController.text;
    });
    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.email = _emailEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext context, Widget child, ContactsModel model) {
          if (model.entityBeingEdited != null) {
            _nameEditingController.text = model.entityBeingEdited.name;
            _phoneEditingController.text = model.entityBeingEdited.phone;
            _emailEditingController.text = model.entityBeingEdited.email;
          }

          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context).translate('cancel'),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );
                      model.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context).translate('save'),
                    ),
                    onPressed: () {
                      _save(context, model);
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
                    leading: Icon(Icons.person),
                    title: TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_phoneFocusNode),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('input_name'),
                      ),
                      controller: _nameEditingController,
                      validator: (String value) {
                        if (value.trim().length == 0) {
                          return AppLocalizations.of(context)
                              .translate('message_name');
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: _phoneFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('input_phone'),
                      ),
                      controller: _phoneEditingController,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: TextFormField(
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('input_email'),
                      ),
                      validator: (String value) {
                        if (value.trim().length == 0 ||
                            !value.trim().contains('@') ||
                            !value.trim().contains('.')) {
                          return AppLocalizations.of(context)
                              .translate('message_email');
                        }
                        return null;
                      },
                      controller: _emailEditingController,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text(
                      AppLocalizations.of(context).translate('birthday'),
                    ),
                    subtitle: Text(
                      contactsModel.chosenDate == null
                          ? ""
                          : contactsModel.chosenDate,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () async {
                        String chosenDate = await utils.selectDate(
                          context,
                          contactsModel,
                          contactsModel.entityBeingEdited.birthday,
                        );
                        if (chosenDate != null) {
                          contactsModel.entityBeingEdited.birthday = chosenDate;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _save(BuildContext context, ContactsModel model) async {
    // ignore: unused_local_variable
    int id = 0;

    if (!_formKey.currentState.validate()) {
      return;
    }

    if (model.entityBeingEdited.id == null) {
      id = await ContactsDBWorker.db.create(contactsModel.entityBeingEdited);
    } else {
      id = await ContactsDBWorker.db.update(contactsModel.entityBeingEdited);
    }

    contactsModel.loadData(ContactsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text(
          AppLocalizations.of(context).translate('contact_saved'),
        ),
      ),
    );
  }
}
