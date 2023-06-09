import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_bin/navtabs/homepage.dart';
import 'package:smart_bin/navtabs/datalog.dart';
import 'package:smart_bin/navtabs/dashboard.dart';
import 'package:smart_bin/navtabs/statistic.dart';

// halaman navigasi utama yang terdapat 4 halaman
// perpindahan halaman menggunakan bottom nav bar dari google nav bar
class NavPage extends StatefulWidget {
  static const id = "NavPage";
  final String data;

  const NavPage({required this.data, super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  // index halaman yang sedang aktif pada navpage (default: 0 = home)
  int _selectedIndex = 0;

  // judul halaman yang akan ditampilkan pada appbar
  final List<String> _titles = const [
    'Home',
    'Dashboard',
    'Data Log',
    'Statistic',
  ];

  // halaman yang akan ditampilkan dalam navpage
  final List<Widget> _pages = const [
    HomePage(),
    Dashboard(),
    DataLog(),
    StatisticChart(),
  ];

  // fungsi untuk sign out user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope digunakan untuk mencegah user untuk kembali ke halaman login kecuali dengan menekan tombol logout
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Image.asset(
            'image/trashgif.gif',
          ),
          title: Text(
            _titles[_selectedIndex],
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout_outlined),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black.withOpacity(0.9),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: GNav(
          onTabChange: (index) => setState(() => _selectedIndex = index),
          iconSize: 20,
          gap: 5,
          color: Colors.white,
          activeColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          backgroundColor: Colors.black.withOpacity(0.9),
          tabBackgroundColor: Colors.white.withOpacity(0.1),
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.trash,
              text: 'Dashboard',
            ),
            GButton(
              icon: LineIcons.server,
              text: 'Data Log',
            ),
            GButton(
              icon: LineIcons.clock,
              text: 'Statistic',
            ),
          ],
        ),
      ),
    );
  }
}
