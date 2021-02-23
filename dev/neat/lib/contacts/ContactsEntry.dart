import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart';
import '../utils.dart' as utils;

class ContactsEntry extends StatelessWidget {

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
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        model.setStackIndex(0);
                      },
                    ),
                    Spacer(),
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () {
                        _save(context, model);
                      },
                    )
                  ]
                )
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                        leading: Icon(Icons.person),
                        title: TextFormField(
                            decoration: InputDecoration(hintText: 'Name'),
                            controller: _nameEditingController,
                            validator: (String value) {
                              if (value.length == 0) {
                                return 'Please enter a name';
                              }
                              return null;
                            }
                        )

                    ),

                    ListTile(
                      leading: Icon(Icons.phone),
                      title: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: "Phone"),
                        controller: _phoneEditingController,
                      )
                    ),

                    ListTile(
                      leading: Icon(Icons.email),
                      title: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "Email"),
                        controller: _emailEditingController,
                      ),
                    ),

                    ListTile(
                      leading: Icon(Icons.today),
                      title: Text("Birthday"),
                      subtitle: Text(contactsModel.chosenDate == null ? "" : contactsModel.chosenDate),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () async {
                            String chosenDate = await utils.selectDate(context,
                                contactsModel, contactsModel.entityBeingEdited.birthday);
                            if (chosenDate != null) {
                              contactsModel.entityBeingEdited.birthday = chosenDate;
                            }
                          }),
                    )
                  ]
                )
              )
            );
          }
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
            duration: Duration(seconds: 2), content: Text('Contact saved'),
        )
    );
  }
}