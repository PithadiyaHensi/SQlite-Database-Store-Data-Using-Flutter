import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:studentapp/model/Student.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'student.db');
    var db = await openDatabase(path, version: 1, onCreate: createTable);
    return db;
  }

  createTable(Database db, int version) async {
    await db.execute('CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, maths TEXT, english TEXT, science TEXT, image TEXT)');
  }

  Future<Student> addStudentData(Student student) async {
    var dbHelper = await db;
    student.id = await dbHelper.insert('student', student.toMap());
    return student;
  }

  Future<List<Student>> getStudentData() async {
    var dbHelper = await db;
    List<Map> maps = await dbHelper.query('student', columns: ['id', 'name','maths', 'english', 'science', 'image']);
    List<Student> student = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        student.add(Student.fromMap(maps[i]));
      }
    }
    return student;
  }

  Future<int> deleteStudentData(int id) async {
    var dbHelper = await db;
    return await dbHelper.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> editStudentData(Student student) async {
    var dbHelper = await db;
    return await dbHelper.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future closeDatabase() async {
    var dbHelper = await db;
    dbHelper.close();
  }
}