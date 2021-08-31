import 'dart:async';

import 'package:agendaapp/models/event.dart';
import 'package:agendaapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EventManager extends ChangeNotifier {
  Usuario usuario;
  List<Event> events = [];

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(Usuario usuario) {
    this.usuario = usuario;
    events.clear();

    _subscription?.cancel();
    if (usuario != null) {
      _listenToEvents();
    }
  }

  void _listenToEvents() {
    _subscription = firebaseFirestore
        .collection('events')
        .where('user', isEqualTo: usuario.id)
        .snapshots()
        .listen(
      (event) {
        events.clear();
        for (final doc in event.docs) {
          events.add(Event.fromDocument(doc));
        }
        notifyListeners();
      },
    );
    //print(events);
  }

  void update(Event event) {
    events.removeWhere((p) => p.id == event.id);
    events.add(event);
    notifyListeners();
  }

  Future<void> delete(Event event) async {
    firebaseFirestore.collection('events').doc(event.id).delete();
    notifyListeners();
  }

  Future<void> editEvent(Event event) async {
    firebaseFirestore.collection('events').doc(event.id).update(event.toMap());
    notifyListeners();
  }

  void add(Event event) {
    firebaseFirestore.collection('events').add(event.toMap());
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
