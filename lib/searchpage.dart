import 'package:flutter/material.dart';
import 'package:studentlist/addpage.dart';
import 'package:studentlist/db_Management.dart';
import 'package:studentlist/editpage.dart';
import 'dart:io';

List<Map<String, dynamic>> WholeDataList = [];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredData = [];

  _fetchData() async {
    final data = await studentDatabase().readDataFromDB();
    setState(() {
      WholeDataList = data;
      filteredData = data;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _filterData(String query) {
    setState(() {
      filteredData = WholeDataList.where((data) =>
          data['name'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              _fetchData();
            },
            icon: const Icon(Icons.refresh),
          ),
          centerTitle: true,
          title: const Text("Search"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  _filterData(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: const Color.fromARGB(221, 223, 223, 223),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: 30),
                          width: 170,
                          height: 120,
                          child: ClipRRect(
                              child: Image(
                                  image: FileImage(
                                      File(filteredData[index]['image']!)))),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text('Name:  '),
                                Text(filteredData[index]['name']),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Age:  '),
                                Text(filteredData[index]['age'].toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Gender: '),
                                Text(filteredData[index]['gender']),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Class:  '),
                                Text(filteredData[index]['onclass'].toString()),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPage(
                                            id: filteredData[index]['id'])));
                              },
                              child: const Text("Edit"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Do you ?"),
                                        content: const Text(
                                            "DO you really want to delet"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  studentDatabase()
                                                      .DeletestudfromDB(
                                                          id: filteredData[
                                                              index]['id']);
                                                  _fetchData();
                                                });
                                              },
                                              child: const Text("Yes"))
                                        ],
                                      );
                                    });
                              },
                              child: const Text("Delete"),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddPage(
                DataAdded: _fetchData,
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

void main() {
  runApp(const SearchPage());
}
