import 'dart:collection';




class ModelExerciseDetail
{

  int? id;
  String? name;
  String? detail;
  String? image;


  ModelExerciseDetail.fromMap(dynamic objects)
  {
    image=objects['image'];
    detail=objects['detail'];
    name=objects['name'];
    id=objects['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['image']=image;
    map['detail']=detail;
    map['name']=name;
    map['id']=id;
    return map;
  }

  }