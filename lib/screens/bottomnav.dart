import 'package:chat_app_flutter/utils/constant.dart';
import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/bottom/calls.dart';
import 'package:chat_app_flutter/screens/bottom/contacts.dart';
import 'package:chat_app_flutter/screens/bottom/home_screen/message.dart';
import 'package:chat_app_flutter/screens/bottom/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNav extends StatefulWidget {
  // int currentIndex;
  UserModel? user;
  BottomNav(
      {
      // required this.currentIndex,
      this.user,
      super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  List<Widget> pages = [];

  void _onItemTapped(int index) async {
    if (index >= 0 && index < pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pages = [
      MessagePage(user: widget.user!),
      const CallPage(),
      const ContactPage(),
      const SettingPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: pages.elementAt(_selectedIndex),
          bottomNavigationBar: Container(
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 10,
                )
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Color.fromRGBO(147, 147, 147, 1),
              selectedItemColor: MyColors.primaryColor,
              selectedFontSize: 15,
              unselectedFontSize: 12,
              unselectedLabelStyle: GoogleFonts.getFont(
                'Nunito',
                textStyle: TextStyle(
                  color: Color.fromRGBO(147, 147, 147, 1),
                ),
              ),
              selectedLabelStyle: GoogleFonts.getFont(
                'Nunito',
                textStyle: TextStyle(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              elevation: 10,
              backgroundColor: const Color.fromRGBO(243, 245, 247, 1),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.sms_outlined,
                    color: MyColors.primaryColor,
                  ),
                  icon: Icon(
                    Icons.sms_outlined,
                    color: Color.fromRGBO(147, 147, 147, 1),
                  ),
                  label: 'Message',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.phone_in_talk_outlined,
                    color: MyColors.primaryColor,
                  ),
                  icon: Icon(
                    Icons.phone_in_talk_outlined,
                    color: Color.fromRGBO(147, 147, 147, 1),
                  ),
                  label: 'Calls',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.perm_contact_calendar_outlined,
                    color: MyColors.primaryColor,
                  ),
                  icon: Icon(
                    Icons.perm_contact_calendar_outlined,
                    color: Color.fromRGBO(147, 147, 147, 1),
                  ),
                  label: 'Contacts',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.settings,
                    color: MyColors.primaryColor,
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: Color.fromRGBO(147, 147, 147, 1),
                  ),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          ),
        ),
      ],
    );
  }
}
