import 'package:agendaapp/models/user_maneger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:agendaapp/models/user.dart';

class Event extends ChangeNotifier {
  String id;
  String userId;
  String title;
  String description;
  Timestamp dateDay;
  bool important;

  Event({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.dateDay,
  });
  Usuario usuario;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Event.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;

    userId = doc.data()['user'] as String;

    title = doc.data()['title'] as String;

    description = doc.data()['description'] as String;

    dateDay = doc.data()['date'] as Timestamp;

    important = doc.data()['important'] as bool;
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      firebaseFirestore.collection('events').doc(id);

  Future<void> save({Usermanager usermanager}) async {
    loading = true;
    firebaseFirestore.collection('events').doc(id).set(
      {
        'title': title,
        'user': usermanager.usuario.id,
        'description': description,
        'date': dateDay,
        'important': important,
      },
    );
    loading = false;
  }

  Event.fromMap(Map<String, dynamic> map) {
    title = map['title'] as String;
    userId = map['user'] as String;
    description = map['description'] as String;
    dateDay = map['date'] as Timestamp;
    important = map['important'] as bool;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user': userId,
      'description': description,
      'date': dateDay,
      'important': important
    };
  }
}
