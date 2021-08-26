import 'package:agendaapp/models/user_maneger.dart';

import 'package:agendaapp/screens/calendar/calendar.dart';
import 'package:agendaapp/screens/events/home_events.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirsPage extends StatefulWidget {
  @override
  _FirsPageState createState() => _FirsPageState();
}

class _FirsPageState extends State<FirsPage> {
  int _seletedPage = 1;

  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  List<TabItem> buildBottomNavBarItems() {
    return [
      TabItem(
        icon: Icon(Icons.calendar_today),
      ),
      TabItem(
        icon: Icon(Icons.home),
      ),
    ];
  }

  void pageChanged(int index) {
    setState(() {
      _seletedPage = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _seletedPage = index;
      pageController.jumpToPage(index);
    });
  }

  Widget buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [
        CalendarPage(),
        HomeEvents(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      drawer: Consumer<Usermanager>(
        builder: (_, userManager, __) {
          return Drawer(
            child: ListView(
              children: [
                TextButton(
                  child: Text(userManager.isLoggedin ? 'SAIR' : 'ENTRAR'),
                  onPressed: userManager.isLoggedin
                      ? () {
                          userManager.signOut();
                          Navigator.of(context).pushReplacementNamed('/base');
                        }
                      : () {
                          Navigator.of(context).pushNamed('/login');
                        },
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: _seletedPage,
        onTap: (index) {
          bottomTapped(index);
        },

        backgroundColor: Color(0xffFAD02C),
        //selectedItemColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
