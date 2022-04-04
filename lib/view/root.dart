import 'package:flutter/material.dart';
import 'package:veguide/view/pages/favorites_page.dart';
import 'package:veguide/view/pages/home_page.dart';
import 'package:veguide/view/pages/about_page.dart';
import 'package:veguide/view/pages/restau_suggestion_page.dart';
import 'package:veguide/view/styles.dart';
import 'package:veguide/view/widgets/app_title.dart';

class Root extends StatefulWidget {
  const Root({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    // Text(
    //   'Fav tab',
    // ),
    FavoritesPage(),
    // PlusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTitle(),
        actions: [
         PopupMenuButton<int>(
             onSelected: (item)=> onSelected(context, item),
             itemBuilder: (context)=>
  [
    PopupMenuItem(child: Text("A propos"), value: 0,),
    PopupMenuItem(child: Text("Suggérer un restaurant"), value: 1,),
    PopupMenuItem(child: Text("Contact & Feedback"),value: 2,),


  ])
        ],
      ),
      body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favoris',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.more_horiz),
          //   label: 'Plus',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onSelected(BuildContext context, int item) {
    switch(item){
      case 0:  // About
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutPage()));
        break;
      case 1:  // Restaurant suggestion
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantSuggestionPage()));
        break;
      case 2: // Feedback
        break;
      default:break;
    }
  }
}
