import 'package:flutter/material.dart';

import '../notes/Notes.dart';
import '../appointments/Appointments.dart';
import '../contacts/Contacts.dart';
import '../tasks/Tasks.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neat'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.date_range), text: 'Appointments'),
              Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
              Tab(icon: Icon(Icons.note), text: 'Notes'),
              Tab(
                icon: Icon(Icons.assignment_turned_in),
                text: 'Tasks',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Appointments(),
            Contacts(),
            Notes(),
            Tasks(),
          ],
        ),
      ),
    );
  }
}
