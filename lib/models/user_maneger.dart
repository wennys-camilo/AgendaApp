import 'package:agendaapp/helpers/firebase_erros.dart';
import 'package:agendaapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Usermanager extends ChangeNotifier {
  Usermanager() {
    _loadCurrentUser();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Usuario usuario;
  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedin => usuario != null;

  Future<void> signIn(
      {Usuario usuario, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.password);
      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signup(
      {Usuario usuario, Function onFail, Function onSucess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.password);

      usuario.id = result.user.uid;
      this.usuario = usuario;

      await usuario.saveData();

      onSucess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    usuario = null;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? await auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      usuario = Usuario.fromDocument(docUser);

      notifyListeners();
    }
  }
}
