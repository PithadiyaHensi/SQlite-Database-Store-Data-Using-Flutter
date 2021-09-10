class Student {
  int id;
  String name;
  String maths;
  String english;
  String science;
  String image;
  Student(this.id, this.name,this.maths, this.english, this.science, this.image);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'maths': maths,
      'english': english,
      'science': science,
      'image' : image,
    };
    return map;
  }

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    maths = map['maths'];
    english = map['english'];
    science = map['science'];
    image = map['image'];
  }
}