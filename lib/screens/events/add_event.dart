import 'package:agendaapp/models/event.dart';
import 'package:agendaapp/models/event_manager.dart';
import 'package:agendaapp/models/user_maneger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatelessWidget {
  final Event event = Event();
  AddEvent({this.selecteday});
  final DateTime selecteday;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: event,
      child: Scaffold(
        backgroundColor: Color(0xffE9EAEC),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Adicionar Evento', style: GoogleFonts.mcLaren()),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Form(
          key: formkey,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10),
                      hintText: 'Título',
                      border: InputBorder.none,
                    ),
                    onSaved: (title) => event.title = title,
                    validator: (title) {
                      if (title.length < 1) return 'Descrição Muito Curta';
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 4,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descrição',
                    ),
                    validator: (description) {
                      if (description.length < 1)
                        return 'Descrição Muito Curta';
                      return null;
                    },
                    onSaved: (description) => event.description = description,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: FormBuilderSwitch(
                  activeColor: Theme.of(context).primaryColor,
                  name: "important",
                  initialValue: false,
                  title: Text(
                    "Importante",
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSaved: (important) => event.important = important,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
                child: FormBuilderDateTimePicker(
                    name: "date",
                    initialValue: selecteday,
                    initialDate: DateTime.now(),
                    fieldHintText: "Add Date",
                    initialDatePickerMode: DatePickerMode.day,
                    inputType: InputType.date,
                    format: DateFormat('EEEE, dd MMMM, yyyy', 'pt_Br'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_today_sharp),
                    ),
                    onSaved: (dateday) {
                      event.dateDay = Timestamp.fromDate(dateday);
                      print("${Timestamp.fromDate(dateday)}");
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<Usermanager>(
          builder: (_, userManager, __) {
            return FloatingActionButton(
              onPressed: !event.loading
                  ? () async {
                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        await event.save(usermanager: userManager);
                        context.read<EventManager>().update(event);
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
              child: const Icon(Icons.save, color: Colors.white),
              backgroundColor: Color(0xff333652),
            );
          },
        ),
      ),
    );
  }
}
