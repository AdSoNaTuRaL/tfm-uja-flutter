import 'package:Neat/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsModel.dart';
import '../utils.dart';

class AppointmentsEntry extends StatelessWidget {
  final _descriptionFocusNode = FocusNode();

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AppointmentsEntry() {
    _titleEditingController.addListener(() {
      appointmentsModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      appointmentsModel.entityBeingEdited.description =
          _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder: (BuildContext context, Widget child, AppointmentsModel model) {
          //- Correction:
          // add the following two lines for "editing" an existing note
          if (model.entityBeingEdited != null) {
            _titleEditingController.text = model.entityBeingEdited.title;
            _descriptionEditingController.text =
                model.entityBeingEdited.description;
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
                      _save(context, appointmentsModel);
                    },
                  )
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('input_title'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      controller: _titleEditingController,
                      validator: (String value) {
                        if (value.length == 0) {
                          return AppLocalizations.of(context)
                              .translate('message_title');
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      focusNode: _descriptionFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('input_description'),
                      ),
                      controller: _descriptionEditingController,
                      validator: (String value) {
                        if (value.length == 0) {
                          return AppLocalizations.of(context)
                              .translate('message_description');
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text(
                      AppLocalizations.of(context).translate('date'),
                    ),
                    subtitle: Text(
                      _date(),
                    ), //tasksModel.chosenDate == null ? "" : tasksModel.chosenDate),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.green[900],
                      onPressed: () async {
                        String chosenDate = await selectDate(
                          context,
                          appointmentsModel,
                          appointmentsModel.entityBeingEdited.date,
                        );
                        if (chosenDate != null) {
                          appointmentsModel.entityBeingEdited.date = chosenDate;
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text(
                      AppLocalizations.of(context).translate('time'),
                    ),
                    subtitle: Text(appointmentsModel.time ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.green[900],
                      onPressed: () => _selectTime(context),
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (appointmentsModel.entityBeingEdited.time != null) {
      initialTime = toTime(appointmentsModel.entityBeingEdited.time);
    }
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      appointmentsModel.entityBeingEdited.time =
          "${picked.hour},${picked.minute}";
      appointmentsModel.setTime(
        picked.format(context),
      );
    }
  }

  String _date() {
    if (appointmentsModel.entityBeingEdited != null) {
      return appointmentsModel.entityBeingEdited.date;
    }
    return '';
  }

  void _save(BuildContext context, AppointmentsModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (model.entityBeingEdited.id == null) {
      await AppointmentsDBWorker.db.create(appointmentsModel.entityBeingEdited);
    } else {
      await AppointmentsDBWorker.db.update(appointmentsModel.entityBeingEdited);
    }
    appointmentsModel.loadData(AppointmentsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text(
          AppLocalizations.of(context).translate('appointment_saved'),
        ),
      ),
    );
  }
}
