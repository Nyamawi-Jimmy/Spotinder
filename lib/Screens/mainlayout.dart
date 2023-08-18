import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotinda/Screens/users.dart';

import '../pages/store_page_view.dart';
import '../widget/match.dart';
import '../widget/sportify_login.dart';
import 'messenger.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int _currentPage=0;
  final PageController _page=PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _page,
        onPageChanged: ((value){
          setState(() {
            _currentPage=value;
          });
        }),
        children: [
          StoryPageView(),
           FavouritePage(),
          Users(),
          MusicPage(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (page){
          setState(() {
            _currentPage=page;
            _page.animateToPage(
                page,
                duration: Duration(microseconds: 500),
                curve: Curves.easeInOut
            );
          });
        }, items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: "Home"),
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.message),

            label: "Messenger"),
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.music),
            label: "Users"),
/*
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: "Your Library"),
*/
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidUser),
            label: "Profile"),
      ],
      ),
    );
  }
}
