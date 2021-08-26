import 'dart:async';

class HomeEventsBloc {
  bool isSwitched = false;

  final StreamController _streamController = StreamController();
  Sink get input => _streamController.sink;
  Stream get output => _streamController.stream;

  void activatefilter(bool value) {
    isSwitched = value;
    input.add(isSwitched);
  }
}
