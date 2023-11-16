import 'dart:collection';




class ModelQuickWorkout {
  int? id;
  String? name;
  String? image;

  ModelQuickWorkout.fromMap(dynamic dynamicObj) {
    image = dynamicObj['image'];
    name = dynamicObj['name'];
    id = dynamicObj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}
