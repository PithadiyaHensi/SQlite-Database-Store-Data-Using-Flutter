import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentapp/helper/DatabaseHelper.dart';
import 'package:studentapp/helper/UtilityString.dart';

import 'model/Student.dart';

class StudentEditActivity extends StatefulWidget {
  int id;
  String name,maths,english,science, image;
  StudentEditActivity({Key key, this.id,this.name,this.maths,this.english,this.science,this.image}) : super(key: key);

  @override
  _StudentEditActivityState createState() => _StudentEditActivityState();
}

class _StudentEditActivityState extends State<StudentEditActivity> {
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
    nameController = TextEditingController(text: widget.name);
    mathController = TextEditingController(text: widget.maths);
    englishController = TextEditingController(text: widget.english);
    scienceController = TextEditingController(text: widget.science);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,appBar: AppBar(title : Text("Edit Student Data"), backgroundColor: Colors.cyan,),resizeToAvoidBottomInset: false,
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
            child: Text('Edit Student'),
            style: ElevatedButton.styleFrom(primary: Colors.cyan),
            onPressed: () {
              if (nameController.text.trim().isEmpty ||
                  mathController.text.trim().isEmpty ||
                  englishController.text.trim().isEmpty ||
                  scienceController.text.trim().isEmpty)
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Fill all filed')));
              else {
                if(imgString.isNotEmpty)
                  dbHelper.editStudentData(Student(widget.id,nameController.text, mathController.text, englishController.text, scienceController.text, imgString));
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
