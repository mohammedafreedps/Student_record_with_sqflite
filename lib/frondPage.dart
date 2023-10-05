 import 'dart:io';

import 'package:flutter/material.dart';

import 'package:studentlist/addpage.dart';
import 'package:studentlist/editpage.dart';
import 'db_Management.dart';

class FrondPage extends StatefulWidget {
  const FrondPage({super.key});

  @override
  State<FrondPage> createState() => _FrondPageState();
}

class _FrondPageState extends State<FrondPage> {
  List<Map<String, dynamic>> students = [];
  int dataLimit = 20;
  int dataOffset = 0;
  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  refreshData(){
    _loadDataFromDatabase();
  }

  Future _loadDataFromDatabase() async {
    final data = await studentDatabase()
        .readDataFromDB(limit: dataLimit, offset: dataOffset);

    if (mounted) {
      setState(() {
        students.clear();
        students.addAll(data);
        dataOffset += dataLimit;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                _loadDataFromDatabase();
              });
            },
            icon: const Icon(Icons.refresh)),
        title: const Text('Students'),
        centerTitle: true,
      ),
      body: students.isNotEmpty
          ? ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                final String? profileImage = (index < students.length)
                    ? students[index]['image']
                    : null;
                final String studetname = students[index]['name'];
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content:
                                const Text("Do you want to Delete or Edit"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await studentDatabase().DeletestudfromDB(
                                        id: students[index]['id']);
                                    await studentDatabase().readDataFromDB();
                                    refreshData();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Delete")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return EditPage(
                                        id: students[index]['id'],
                                        // imgid: WholeImageList[index]['id'],
                                      );
                                    }));
                                  },
                                  child: const Text("Edit"))
                            ],
                          );
                        });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profileImage != null
                          ? FileImage(File(profileImage))
                          : const AssetImage('asset/logo.png') as ImageProvider,
                    ),
                    title: Text(studetname),
                  ),
                );
              },
            )
          : const Center(child: Text('No Students were added')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage(DataAdded: refreshData,)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
