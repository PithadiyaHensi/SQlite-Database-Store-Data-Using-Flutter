import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentapp/StudentAddActivity.dart';
import 'package:studentapp/StudentEditActivity.dart';
import 'package:studentapp/helper/DatabaseHelper.dart';
import 'package:studentapp/helper/UtilityString.dart';
import 'package:studentapp/model/Student.dart';

class StudentActivity extends StatefulWidget {
  const StudentActivity({Key key}) : super(key: key);

  @override
  _StudentActivityState createState() => _StudentActivityState();
}

class _StudentActivityState extends State<StudentActivity> {
  DBHelper dbHelper;
  Future<List<Student>> student;
  List<Student> studentList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    dbHelper = DBHelper();
    refresheStudentList();
    super.initState();
  }

  refresheStudentList() {
    setState(() {
      dbHelper.getStudentData().then((value) {
        print(value.length);
        studentList.addAll(value);
        setState(() {});
      });
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    refresheStudentList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Colors.cyan,shadowColor: Colors.transparent,
        title: const Text("Student App", style: TextStyle(color: Colors.white)),actions: [IconButton(icon: Icon(Icons.add, color: Colors.white), onPressed:(){Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => StudentAddActivity()));}),
          IconButton(icon: Icon(Icons.refresh, color: Colors.white), onPressed:(){refresheStudentList();}),
        ],
      ),
      body: Container(child: FutureBuilder(
          future: dbHelper.getStudentData(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: studentList.length,
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10.0
                    ),
                    child: ListTile(tileColor: Colors.cyan,
                        leading: UtilityString.imageFromBase64String(
                            studentList[index].image,
                          ),
                        //),
                        trailing: Container(width: MediaQuery.of(context).size.width/6,
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap:(){setState(() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => StudentEditActivity(id: studentList[index].id, name: studentList[index].name, maths: studentList[index].maths, english: studentList[index].english, science: studentList[index].science, image : studentList[index].image)));
                                  });
                                  },child: Icon(Icons.edit, color: Colors.black)),
                              GestureDetector(
                                  onTap:(){setState(() {
                                    dbHelper.deleteStudentData(studentList[index].id);
                                    studentList.removeAt(index);
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Delete Successfully..!!')));
                                    refresheStudentList();
                                  });
                                  },child: Icon(Icons.delete, color: Colors.black)),
                            ],
                          ),
                        ),
                        title: Text((studentList[index].name)+" "+(studentList[index].maths)+" "+(studentList[index].english)+" "+(studentList[index].science)),
                        subtitle: Text(((int.parse(studentList[index].maths)+int.parse(studentList[index].english)+int.parse(studentList[index].science))*100/300).toString()),
                        onTap:(){
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ContactDetailActivity(id: contactList[index].id.toString(),avatar: contactList[index].avatar, firstName: contactList[index].fname,lastName: contactList[index].lname,email: contactList[index].email, from: "local")));
                        }
                    ),
                  ),
                );
              },
            );
          }
      )),
    );
  }
}
