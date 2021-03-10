import 'package:Neat/app_localizations.dart';
import 'package:Neat/links/Links.dart';
import 'package:flutter/material.dart';

import '../notes/Notes.dart';
import '../appointments/Appointments.dart';
import '../contacts/Contacts.dart';
import '../tasks/Tasks.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neat'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.date_range), 
                text: AppLocalizations.of(context).translate('tab_text_title_appointment'),
              ),
              Tab(
                icon: Icon(Icons.contacts), 
                text: AppLocalizations.of(context).translate('tab_text_title_contact'),
              ),
              Tab(
                icon: Icon(Icons.note), 
                text: AppLocalizations.of(context).translate('tab_text_title_note'),
              ),
              Tab(
                icon: Icon(Icons.assignment_turned_in),
                text: AppLocalizations.of(context).translate('tab_text_title_task'),
              ),
              Tab(
                icon: Icon(Icons.settings_overscan),
                text: 'QR Reader' //AppLocalizations.of(context).translate('tab_text_title_task'),
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
            Links(),
          ],
        ),
      ),
    );
  }
}
