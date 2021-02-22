import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AppointmentsEntry.dart';
import 'AppointmentsModel.dart' show AppointmentsModel, appointmentsModel;
import 'AppointmentsDBWorker.dart';
import 'AppointmentsList.dart';

class Appointments extends StatelessWidget {

  Appointments() {
    appointmentsModel.loadData(AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
          builder: (BuildContext context, Widget child, AppointmentsModel model) {
            return IndexedStack(
              index: model.stackIndex,
              children: <Widget>[ AppointmentsList(), AppointmentsEntry()],
            );
          }
      )
    );
  }

}