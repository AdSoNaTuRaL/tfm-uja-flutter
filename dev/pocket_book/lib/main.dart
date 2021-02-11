import 'package:flutter/material.dart';
import 'notes/Notes.dart';
import 'appointments/Appointments.dart';
import 'contacts/Contacts.dart';
import 'tasks/Tasks.dart';

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(PocketBook());
  }
  startMeUp();
}

class PocketBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pocket Book',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Pocket Book'),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.date_range), text: 'Appointments'),
                  Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                  Tab(icon: Icon(Icons.note), text: 'Notes'),
                  Tab(icon: Icon(Icons.assignment_turned_in), text: 'Tasks'),
                ]
              )
            ),
            body: TabBarView(
                children: [
                  Appointments(),
                  Contacts(),
                  Notes(),
                  Tasks(),
                ]
            )
          )
      )
    );
  }
}