import 'package:agendaapp/screens/HomePage.dart';
import 'package:agendaapp/screens/events/add_event.dart';
import 'package:agendaapp/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static String initialRoute = '/base';
  static Route<MaterialPageRoute> onGerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/addevent':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddEvent(),
        );

      case '/login':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(),
        );

      case '/base':
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FirsPage(),
        );
    }
  }
}
