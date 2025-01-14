import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Home/home.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Profile/profile.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/all_review.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationPage> {
  int _page = 0;
  List<Widget> list = [HomePage(), ProfilePage(), ProfilePage(), ReviewsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: [
          CurvedNavigationBarItem(child: Icon(Icons.home), label: "Home"),
          CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity), label: "Profile"),
          CurvedNavigationBarItem(
              child: Icon(Icons.movie), label: "My Favorite Movies"),
          CurvedNavigationBarItem(
              child: Icon(Icons.reviews), label: "My reviews")
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
