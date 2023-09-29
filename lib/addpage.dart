import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentlist/db_Management.dart';
import 'dart:io';
import 'Photo_DB_manage.dart';


class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String? _imagePath;
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController onclass = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
   
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
         print('picked file $_imagePath');
      });
    }
  }

  Future<void> _addDataToDatabase() async {
    if (_imagePath == null) {
      // Handle the case when no image is selected
      return;
    }

    final studentDb = studentDatabase();
    await studentDb.addDatatoDB(
      name: name.text,
      age: int.tryParse(age.text) ?? 0,
      gender: gender.text,
      onclass: int.tryParse(onclass.text) ?? 0,
    );
    final Imagedatabase = ImageDatabase();
    await Imagedatabase.addImageLocally(
      image: _imagePath
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enter the Details'),
                  _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          width: 150,
                          height: 150,
                        )
                      : const Text("No image selected"),
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
                    onPressed: _pickImage,
                    onLongPress: () {
                      setState(() {
                        print('che $_imagePath');
                      });
                    },
                    child: const Text("Select Image"),
                  ),
                  _imagePath == null
                      ? const Text(" ")
                      : const Text("Long press to clear"),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                     _addDataToDatabase();
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go back"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  saveButtnfunction()async {
    _addDataToDatabase;
      await ImageDatabase().addImageLocally(image: _imagePath);
  }
}