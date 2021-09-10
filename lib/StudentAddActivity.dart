import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentapp/helper/DatabaseHelper.dart';
import 'package:studentapp/helper/UtilityString.dart';

import 'model/Student.dart';

class StudentAddActivity extends StatefulWidget {
  const StudentAddActivity({Key key}) : super(key: key);

  @override
  _StudentAddActivityState createState() => _StudentAddActivityState();
}

class _StudentAddActivityState extends State<StudentAddActivity> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mathController = TextEditingController();
  TextEditingController englishController = TextEditingController();
  TextEditingController scienceController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String imgString;
  DBHelper dbHelper;

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      imgString = UtilityString.base64String(imgFile.readAsBytesSync());
    });
  }

  @override
  void initState() {
    dbHelper = DBHelper();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,appBar: AppBar(title : Text("Add Student Data"), backgroundColor: Colors.cyan,),resizeToAvoidBottomInset: false,
      body: Container(child: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text('Student Photo Chooses'),
            style: ElevatedButton.styleFrom(primary: Colors.cyan),
            onPressed: () {
              pickImageFromGallery();
              }
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student Name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: mathController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Maths Mark',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: englishController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'English Mark',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: scienceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Science Mark',
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Add Student'),
            style: ElevatedButton.styleFrom(primary: Colors.cyan),
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  mathController.text.trim().isEmpty ||
                  englishController.text.trim().isEmpty ||
                  scienceController.text.trim().isEmpty)
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Fill all filed')));
              else {
                if(imgString.isNotEmpty)
                  dbHelper.addStudentData(Student(null,nameController.text, mathController.text, englishController.text, scienceController.text, imgString));
                else
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Add Image')));
              }
            },
          ),
        ],
      ),),
    );
  }
}
