import 'package:flutter/material.dart';
import 'package:flutter_programming_fundamentals/Pages/home_page.dart';
import 'package:flutter_programming_fundamentals/Pages/profile_page.dart';
import 'package:flutter_programming_fundamentals/Pages/setting_page.dart';
// import 'package:flutter_programming_fundamentals/Pages/second_page.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  //this keep track of current page to display
  int _selectIndex = 0;

  //this method update the new selected index
  void _navigateBottomBar(int index) {
    _selectIndex = index;
  }

  final List _pages = [
    //Home page
    HomePage(),
    //Profile page
    Profile(),
    //Setting page
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("1st Page")),
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: _pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: _navigateBottomBar,
        items: [
          //Home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          //Profile
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

          //Settings
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),

      // drawer: Drawer(
      //   backgroundColor: Colors.deepPurple[100],
      //   child: Column(
      //     children: [
      //       DrawerHeader(child: Icon(Icons.favorite, size: 50)),
      //       //home page list tile
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text("Home"),
      //         onTap: () {
      //           Navigator.of(context).pop();
      //           Navigator.of(context).pushNamed('/HomePage');
      //         },
      //       ),
      //       //setting page list tile
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text("Setting"),
      //         onTap: () {
      //           Navigator.of(context).pop();
      //           Navigator.of(context).pushNamed('/SettingPage');
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      // body:
      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       //navigate to second page.
      //       Navigator.pushNamed(context, '/SecondPage');
      //       // Navigator.push(
      //       //   context,
      //       //   MaterialPageRoute(builder: (context) => SecondPage()),
      //     // );
      //     },
      //     child: Text("Go To Second Page"),
      //   ),
      // ),
    );
  }
}
