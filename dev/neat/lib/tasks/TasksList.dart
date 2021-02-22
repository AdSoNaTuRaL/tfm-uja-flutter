import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'TasksDBWorker.dart';
import 'TasksModel.dart' show Task, TasksModel, tasksModel;
import '../utils.dart' show toFormattedDate;

class TasksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
          builder: (BuildContext context, Widget child, TasksModel model) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    tasksModel.entityBeingEdited = Task();
                    tasksModel.setStackIndex(1);
                  }
              ),
              body: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: tasksModel.entityList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Task task = tasksModel.entityList[index];
                    String dueDate;
                    if (task.dueDate != null) {
                      dueDate = toFormattedDate(task.dueDate);
                    }
                    return Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: .25,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: "Delete",
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => _deleteTask(context, task),
                            )
                          ],

                          child: ListTile(
                            leading: Checkbox(
                                value: task.completed,
                                onChanged: (value) async {
                                  task.completed = value;
                                  await TasksDBWorker.db.update(task);
                                  tasksModel.loadData(TasksDBWorker.db);
                                }
                            ),
                            title: Text(
                                "${task.description}",
                                style: task.completed ?
                                TextStyle(color: Theme
                                    .of(context)
                                    .disabledColor,
                                    decoration: TextDecoration.lineThrough) :
                                TextStyle(color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline6
                                    .color)),
                            subtitle: task.dueDate == null ? null :
                            Text(dueDate,
                                style: task.completed ?
                                TextStyle(color: Theme
                                    .of(context)
                                    .disabledColor,
                                    decoration: TextDecoration.lineThrough) :
                                TextStyle(color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline6
                                    .color)),
                            onTap: () async {
                              if (task.completed) {
                                return;
                              }
                              tasksModel.entityBeingEdited =
                              await TasksDBWorker.db.get(task.id);
                              if (tasksModel.entityBeingEdited.dueDate ==
                                  null) {
                                tasksModel.setChosenDate(null);
                              } else {
                                tasksModel.setChosenDate(dueDate);
                              }
                              tasksModel.setStackIndex(1);
                            },
                          )
                      ),
                    );
                  }
              )
            );
          }
      )
    );
  }

  Future _deleteTask(BuildContext context, Task note) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Really delete ${note.description}?'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () { Navigator.of(alertContext).pop(); },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await TasksDBWorker.db.delete(note.id);
                Navigator.of(alertContext).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text('Task deleted'),
                  )
                );
                tasksModel.loadData(TasksDBWorker.db);
              },
            )
          ]
        );
      }
    );
  }
}