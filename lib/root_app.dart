import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_shortener/link.dart';

import 'package:url_shortener/pages/history_page.dart';
import 'package:url_shortener/pages/home_page.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activePageIndex = 0;
  List<Link> links = [];

  @override
  Widget build(BuildContext context) {
    List<Widget>  pages = [
      HomePage(links: links,),
      HistoryPage(links: links,),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bite Link'),
        centerTitle: true,
        elevation: 0,
      ),
      body: pages[activePageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activePageIndex,
        onTap: (value){
          setState(() {
            activePageIndex = value;
          });
        },
        items: [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.home_outline),
          label: "Home",
          activeIcon: Icon(Ionicons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.document_attach_outline),
          label: "History",
          activeIcon: Icon(Ionicons.document_attach),
        ),
      ]),
    );
  }
}
