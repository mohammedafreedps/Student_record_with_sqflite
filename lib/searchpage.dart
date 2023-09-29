import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studentlist/Photo_DB_manage.dart';
import 'package:studentlist/addpage.dart';
import 'package:studentlist/db_Management.dart';
import 'package:studentlist/editpage.dart';

List<Map<String, dynamic>> WholeDataList = [];
List<Map<String, dynamic>> WholeImageList = [];

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

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
      // Ensure the filtered data is updated when fetching all data
      _filterData(searchController.text);
    });
  }

  _loadImageFromDatabase() async {
    if (mounted) {
      dynamic imageFile = await ImageDatabase().readImageData();
      setState(() {
        if (imageFile != null) {
          WholeImageList = List.from(imageFile);
          WholeDataList.addAll(imageFile);
        }
      });
    }
  }

  @override
  void initState() {
    _fetchData();
    _loadImageFromDatabase();
    super.initState();
  }

  void _filterData(String query) {
    setState(() {
      filteredData = WholeDataList
          .where((data) =>
              data['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
          title: const Text("All Detail"),
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
                  String? profileImage = (index < WholeDataList.length)
                      ? WholeImageList[index]['image']
                      : null;
                  return Container(
                    color: Colors.black54,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: 30),
                          width: 220,
                          height: 120,
                          child: ClipOval(
                            child: Image(
                              image: FileImage(File(profileImage!)),
                            ),
                          ),
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
                                Text(
                                    filteredData[index]['age'].toString()),
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
                                Text(
                                    filteredData[index]['onclass'].toString()),
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
                                setState(() {
                                  studentDatabase().DeletestudfromDB(
                                      id: filteredData[index]['id']);
                                  _fetchData();
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
              return const AddPage();
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
