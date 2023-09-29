import 'package:flutter/material.dart';
import 'package:studentlist/detailPage.dart';
import 'package:studentlist/frondPage.dart';
import 'package:studentlist/searchpage.dart';



void main() {
  runApp(const StudentRecord());
}

class StudentRecord extends StatefulWidget {
  const StudentRecord({super.key});

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  int currentIndex = 0;

  final tabs = [
    const FrondPage(),
    const DetailPage(),
    const SearchPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: tabs[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          // type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(
              icon:  Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.details),
              label: 'Detail',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.blue,
            ),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
