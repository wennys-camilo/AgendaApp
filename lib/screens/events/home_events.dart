import 'package:agendaapp/bloc/homeevents_bloc.dart';
import 'package:agendaapp/models/event.dart';
import 'package:agendaapp/models/event_manager.dart';
import 'package:agendaapp/models/user_maneger.dart';
import 'package:agendaapp/screens/events/components/event_card.dart';
import 'package:agendaapp/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeEvents extends StatefulWidget {
  HomeEvents({Key key}) : super(key: key);

  @override
  _HomeEventsState createState() => _HomeEventsState();
}

class _HomeEventsState extends State<HomeEvents> {
  HomeEventsBloc bloc = HomeEventsBloc();

  DateTime dateTime = DateTime.now();
  bool isCurrentMonth(List<Event> event, int index) {
    if (event[index].dateDay.toDate().month == dateTime.month &&
        event[index].dateDay.toDate().year == dateTime.year) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Usermanager>(context).isLoggedin;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Meus Eventos', style: GoogleFonts.mcLaren()),
        backgroundColor: Color(0xffFAD02C),
      ),
      body: user
          ? StreamBuilder<Object>(
              stream: bloc.output,
              builder: (context, snapshot) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: AspectRatio(
                        aspectRatio: 3.4,
                        child: SvgPicture.asset(
                          'assets/images/events_home.svg',
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: Center(
                        child: Text(
                          'Todos os eventos do mês serão listados aqui!',
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
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Center(
                        child: Text(
                          'Atente-se aos seus eventos importantes',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    user
                        ? Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Switch(
                                      value: bloc.isSwitched,
                                      onChanged: (value) =>
                                          bloc.activatefilter(value),
                                      activeTrackColor: Colors.yellow[200],
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Filtrar',
                                    style: TextStyle(),
                                  )
                                ],
                              ),
                              bloc.isSwitched
                                  ? Container(
                                      child: Text(
                                        'Filtrando eventos importantes',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 14,
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : Container(),
                    Consumer<EventManager>(
                      builder: (_, eventManager, __) {
                        return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: eventManager.events.length,
                          itemBuilder: (BuildContext context, int index) {
                            final eventSort = eventManager.events;
                            eventSort.sort((a, b) => a.dateDay
                                .toDate()
                                .day
                                .compareTo(b.dateDay.toDate().day));
                            if (bloc.isSwitched && eventSort.isNotEmpty) {
                              return isCurrentMonth(eventSort, index) &&
                                      eventSort[index].important
                                  ? CardTile(eventSort[index], index: index)
                                  : Container();
                            } else {
                              return isCurrentMonth(eventSort, index)
                                  ? CardTile(eventSort[index], index: index)
                                  : Container();
                            }
                          },
                        );
                      },
                    )
                  ],
                );
              })
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: AspectRatio(
                        aspectRatio: 3.4,
                        child: SvgPicture.asset(
                          'assets/images/login.svg',
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Center(
                    child: Text(
                      'Faça login para adicionar e visualizar seus eventos!',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
