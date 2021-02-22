import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsModel.dart' show Appointment, AppointmentsModel, appointmentsModel;
import '../utils.dart';
import '../constants.dart';

class AppointmentsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    EventList<Event> markedDateMap = EventList<Event>();
    for (Appointment app in appointmentsModel.entityList) {
      DateTime date = toDate(app.date);
      markedDateMap.add(date, Event(date: date,
          icon: Container(decoration: BoxDecoration(color: Colors.black))));
    }
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
          builder: (BuildContext context, Widget child, AppointmentsModel model) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    appointmentsModel.entityBeingEdited = Appointment();
                    DateTime now = DateTime.now();
                    appointmentsModel.entityBeingEdited.date =
                    "${now.year},${now.month},${now.day}";
                    appointmentsModel.setDate(formatDate(now));
                    appointmentsModel.setTime(null);
                    appointmentsModel.setStackIndex(1);
                  }
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: CalendarCarousel<Event>(
                        iconColor: bFourColor,
                        headerTextStyle: TextStyle(fontSize: 20.0, color: bFourColor),
                        weekendTextStyle: TextStyle(color: bFourColor),
                        weekdayTextStyle: TextStyle(color: bFourColor),
                        todayBorderColor: Colors.grey,
                        todayButtonColor: bPrimaryColor,
                        thisMonthDayBorderColor: Colors.grey,
                        daysHaveCircularBorder: true,
                        markedDatesMap: markedDateMap,
                        onDayPressed: (DateTime date, List<Event> events) {
                          _showAppointments(date, context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      )
    );
  }

  void _showAppointments(DateTime date, BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ScopedModel<AppointmentsModel>(
            model: appointmentsModel,
            child: ScopedModelDescendant<AppointmentsModel>(
                builder: (BuildContext context, Widget child, AppointmentsModel model) {
                  return Scaffold(
                    body: Container(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Text(formatDate(date),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24)),
                                Divider(),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: appointmentsModel.entityList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Appointment app = appointmentsModel.entityList[index];
                                        if (app.date != "${date.year},${date.month},${date.day}") {
                                          return Container(height: 0);
                                        }
                                        String time = "";
                                        if (app.time != null) {
                                          time = " (${toFormattedTime(app.time, context)})";
                                        }
                                        return Slidable(
                                          actionPane: SlidableDrawerActionPane(),
                                          actionExtentRatio: .25,
                                          child: Container(
                                              margin: EdgeInsets.only(bottom: 8),
                                              color: Colors.grey.shade300,
                                              child: ListTile(
                                                title: Text("${app.title}$time"),
                                                subtitle: app.description == null ? null :
                                                Text("${app.description}"),
                                                onTap: () async {
                                                  _editAppointment(context, app);
                                                },
                                              )
                                          ),
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: "Delete",
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () => _deleteAppointment(context, app),
                                            )
                                          ],
                                        );
                                      })
                                ),
                              ],
                            )
                          )
                        )
                    )

                  );
                }
                )
          );
        });
  }

  void _editAppointment(BuildContext context, Appointment app) async {
    appointmentsModel.entityBeingEdited = await AppointmentsDBWorker.db.get(app.id);
    if (appointmentsModel.entityBeingEdited.date == null) {
      appointmentsModel.setDate(null);
    } else {
      appointmentsModel.setDate(toFormattedDate(appointmentsModel.entityBeingEdited.date));
    }
    if (appointmentsModel.entityBeingEdited.time == null) {
      appointmentsModel.setTime(null);
    } else {
      appointmentsModel.setTime(toFormattedTime(appointmentsModel.entityBeingEdited.time, context));
    }
    appointmentsModel.setStackIndex(1);
    Navigator.pop(context);
  }

  Future _deleteAppointment(BuildContext context, Appointment app) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Delete Appointment'),
          content: Text('Really delete ${app.title}?'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () { Navigator.of(alertContext).pop(); },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await AppointmentsDBWorker.db.delete(app.id);
                Navigator.of(alertContext).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text('Appointment deleted'),
                  )
                );
                appointmentsModel.loadData(AppointmentsDBWorker.db);
              },
            )
          ]
        );
      }
    );
  }
}