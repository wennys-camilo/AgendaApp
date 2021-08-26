import 'dart:collection';

import 'package:agendaapp/constants.dart';
import 'package:agendaapp/models/event.dart';
import 'package:agendaapp/models/event_manager.dart';
import 'package:agendaapp/models/user_maneger.dart';
import 'package:agendaapp/screens/events/components/event_card.dart';
import 'package:agendaapp/screens/login/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendaapp/screens/events/add_event.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  LinkedHashMap<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<Event> events) {
    selectedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(event.dateDay.toDate().year,
          event.dateDay.toDate().month, event.dateDay.toDate().day, 12);
      //print('aqui ${date}');
      if (selectedEvents[date] == null) selectedEvents[date] = [];
      selectedEvents[date].add(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EventManager, Usermanager>(
      builder: (_, eventManager, userManager, __) {
        List<Event> teste = userManager.isLoggedin ? eventManager.events : [];
        _groupEvents(teste);
        DateTime selectedDate = selectedDay;
        final _selectedEvents = selectedEvents[selectedDate] ?? [];
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                TableCalendar(
                  locale: 'pt_BR',
                  calendarBuilders: CalendarBuilders(),
                  focusedDay: selectedDay,
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2050),
                  availableCalendarFormats: {CalendarFormat.month: "Month"},
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,

                  //Day Changed
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                    print(focusedDay);
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },

                  eventLoader: _getEventsfromDay,

                  //To style the Calendar
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Color(0xff333652),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    weekendTextStyle: TextStyle(color: Colors.red),
                    todayDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: _selectedEvents.isNotEmpty
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          _selectedEvents.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 20.0, bottom: 20),
                                  child: Text(
                                    "Eventos de ${DateFormat("d 'de' MMMM", "pt").format(selectedDay)}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3.8,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: SvgPicture.asset(
                                            'assets/images/events.svg',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, right: 60),
                                      child: Center(
                                        child: Text(
                                          'Não há eventos para esse dia!',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 40),
                                      child: Center(
                                        child: Text(
                                          'Adicione um evento',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          userManager.isLoggedin
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _selectedEvents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Event event = _selectedEvents[index];
                                    return CardTile(
                                      event,
                                      index: index,
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ksecondaryColor,
              onPressed: () {
                print('DIA SENDO ENVIADO ${selectedDay.toString()}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userManager.isLoggedin
                        ? AddEvent(
                            selecteday:
                                selectedDay.add(Duration(seconds: 10800)),
                          )
                        : LoginScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
