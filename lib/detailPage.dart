import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studentlist/addpage.dart';
import 'package:studentlist/db_Management.dart';
import 'package:studentlist/editpage.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    _fechData();
  }

  _fechData() async {
    // dynamic picdatareceved = await ImageDatabase().readImageData();
    final data = await studentDatabase().readDataFromDB();

    setState(() {
      WholeDataList = data;
      print(WholeDataList);
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
                _fechData();
              },
              icon: const Icon(Icons.refresh)),
          centerTitle: true,
          title: const Text("All Detail"),
        ),
        body: WholeDataList.isNotEmpty
            ? ListView.separated(
                itemCount: WholeDataList.length,
                separatorBuilder: (BuildContext, context) {
                  return Container(
                    color: Colors.black87,
                    height: 2,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final String? profileImage = (index < WholeDataList.length)
                      ? WholeDataList[index]['image']
                      : null;
                  return Container(
                    color: const Color.fromARGB(221, 223, 223, 223),
                    child: Row(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 40),
                            width: 170,
                            height: 120,
                            child: ClipRect(
                              child: WholeDataList != null
                                  ? Image(image: FileImage(File(profileImage!)))
                                  : const SizedBox(), // Handle null value with an empty SizedBox
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text('Name:  '),
                                Text(WholeDataList[index]['name']),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Age:  '),
                                Text(WholeDataList[index]['age'].toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Gender: '),
                                Text(WholeDataList[index]['gender'])
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('Class:  '),
                                Text(WholeDataList[index]['onclass'].toString())
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
                                              id: WholeDataList[index]['id'],
                                            )));
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
                                              "Do you really want to delet"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  studentDatabase()
                                                      .DeletestudfromDB(
                                                          id: WholeDataList[
                                                              index]['id']);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DetailPage()));
                                                });
                                              },
                                              child: const Text("YES"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: const Text("Delete"))
                          ],
                        )
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text("No Students were added"),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddPage(
                DataAdded: _fechData,
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
