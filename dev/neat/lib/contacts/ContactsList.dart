import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart' show Contact, ContactsModel, contactsModel;
import '../utils.dart' as utils;

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext context, Widget child, ContactsModel model) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                contactsModel.entityBeingEdited = Contact();
                contactsModel.setBirthday(null);
                contactsModel.setStackIndex(1);
              },
            ),
            body: ListView.builder(
              itemCount: contactsModel.entityList.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = contactsModel.entityList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: .25,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          child: Text(
                            contact.name.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text("${contact.name}"),
                        subtitle: contact.phone == null
                            ? null
                            : Text("${contact.phone}"),
                        onTap: () async {
                          contactsModel.entityBeingEdited =
                              await ContactsDBWorker.db.get(contact.id);
                          if (contactsModel.entityBeingEdited.birthday ==
                              null) {
                            contactsModel.setBirthday(null);
                          } else {
                            contactsModel.setBirthday(
                              utils.toFormattedDate(
                                contactsModel.entityBeingEdited.birthday,
                                context,
                              ),
                            );
                          }
                          contactsModel.setStackIndex(1);
                        },
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption:
                              AppLocalizations.of(context).translate('delete'),
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _deleteContact(context, contact),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[350],
                            width: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future _deleteContact(BuildContext context, Contact contact) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('contact_delete'),
          ),
          content: Text(
              '${AppLocalizations.of(context).translate('really_delete')} ${contact.name}?'),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
              ),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context).translate('delete'),
              ),
              onPressed: () async {
                await ContactsDBWorker.db.delete(contact.id);
                Navigator.of(alertContext).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text(
                      AppLocalizations.of(context).translate('contact_deleted'),
                    ),
                  ),
                );
                contactsModel.loadData(ContactsDBWorker.db);
              },
            ),
          ],
        );
      },
    );
  }
}
