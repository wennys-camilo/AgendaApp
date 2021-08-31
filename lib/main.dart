import 'package:agendaapp/models/event_manager.dart';
import 'package:agendaapp/models/user_maneger.dart';
import 'package:agendaapp/routes/routes.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Usermanager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<Usermanager, EventManager>(
          create: (context) => EventManager(),
          lazy: false,
          update: (__, userManager, eventsManager) =>
              eventsManager..updateUser(userManager.usuario),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [const Locale('pt', 'BR')],
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.mcLarenTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryTextTheme: TextTheme(
            subtitle1: TextStyle(color: Colors.blue),
          ),
          primaryColor: Color(0xffFAD02C),
          accentColor: Colors.white,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Color(0xffFAD02C),
          appBarTheme: AppBarTheme(
            centerTitle: true,
          ),
          accentTextTheme: TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        onGenerateRoute: Routes.onGerateRoute,
      ),
    );
  }
}
