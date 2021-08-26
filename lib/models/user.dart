import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  Usuario(
      {this.email, this.password, this.name, this.confirmPassword, this.id});

  Usuario.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get eventReference => firestoreRef.collection('events');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
