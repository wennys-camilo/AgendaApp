import 'package:agendaapp/models/event.dart';
import 'package:agendaapp/models/event_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardTile extends StatefulWidget {
  const CardTile(this.event, {this.index});
  final Event event;
  final int index;

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  bool _cardBool = false;
  Event _eventremove;
  int _eventremovePos;
  @override
  Widget build(BuildContext context) {
    return Consumer<EventManager>(
      builder: (_, eventManager, __) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _cardBool = !_cardBool;
            });
          },
          child: Dismissible(
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              _eventremove = widget.event;
              eventManager.delete(widget.event);
              eventManager.events.removeAt(widget.index);
              _eventremovePos = widget.index;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  backgroundColor: Color(0xff333652),
                  content: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.yellow),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: "O evento "),
                              TextSpan(
                                text: "\"${_eventremove.title}\"",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: " foi removido!"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'Desfazer',
                    onPressed: () {
                      print(_eventremove.title);

                      eventManager.events.insert(_eventremovePos, _eventremove);
                      eventManager.add(_eventremove);
                    },
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            background: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.red,
              ),
              child: Align(
                alignment: Alignment(-0.9, 0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            key: Key(UniqueKey().toString()),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffE9EAEC),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 15.0,
                      // bottom: 10.0,
                      right: 12.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff90ADC6),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    widget.event.dateDay
                                        .toDate()
                                        .day
                                        .toString(),
                                    style: GoogleFonts.mcLaren(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    DateFormat(" MMM", "pt_BR").format(
                                      widget.event.dateDay.toDate(),
                                    ),
                                    style: GoogleFonts.mcLaren(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                maxLines: (_cardBool == true) ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.event.description,
                                  maxLines: (_cardBool == true) ? 20 : 1,
                                  style: TextStyle(
                                    color: Color(0xff333652),
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              widget.event.important == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.new_releases,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Importante',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
