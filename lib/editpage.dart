import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentlist/Photo_DB_manage.dart';
import 'package:studentlist/db_Management.dart';

class EditPage extends StatefulWidget {
  final id;
  final imgid;

  const EditPage({super.key, required this.id, this.imgid});

  @override
  State<EditPage> createState() => _EditPageState();
}

ImageDatabase imageDatabase = ImageDatabase();

class _EditPageState extends State<EditPage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController onclass = TextEditingController();
  File? _selectedImage;
  String? _picselectd;

  @override
  void initState() {
    super.initState();

    if (_picselectd != null) {
      _selectedImage = File(_picselectd!);
    }
  }

  Future _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _picselectd = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Update"),
        ),
        body: Center(
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: 120,
                        height: 120,
                      )
                    : const Text("Select an image"),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: age,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                ),
                TextField(
                  controller: onclass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                  ),
                ),
                TextField(
                  controller: gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Male or Female',
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  child: const Text("Select Image"),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (name.text.isNotEmpty &&
                        int.tryParse(age.text) != null &&
                        int.tryParse(onclass.text) != null &&
                        gender.text.isNotEmpty &&
                        _selectedImage != null) {
                      String nameValue = name.text;
                      int ageValue = int.tryParse(age.text) ?? 0;
                      int onclassValue = int.tryParse(onclass.text) ?? 0;
                      String genderValue = gender.text;
                      studentDatabase().updatefromDB(
                        name: nameValue,
                        age: ageValue,
                        onclass: onclassValue,
                        gender: genderValue,
                        id: widget.id,
                      );
                      await studentDatabase().readDataFromDB();
                      imageDatabase.updateImage(id: widget.imgid, name: _picselectd);
                      await ImageDatabase().readImageData();
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Check"),
                            content: const Text(
                                "Check the fields for any invalid entry"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text("Update"),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Go back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
