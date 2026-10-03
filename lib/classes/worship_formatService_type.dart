


import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorshipServiceFormat{
  String? id;
  String type;
  Color color;
  //String format; /// No utilizado
  DateTime dateTime;
  List<Privilege> privileges;
  int order;

  WorshipServiceFormat({
    this.id,
    required this.type,
    required this.color,
    //required this.format,
    required this.dateTime,
    required this.privileges,
    required this.order
  });

  factory WorshipServiceFormat.fromMap( Map<String, dynamic> map ){
    return WorshipServiceFormat(
      id: map['id'],
      type: map['type'], 
      color: map['color'] != null 
            ? Color(map['color'] as int) 
            : Colors.black,
//      format: map['format'],
      dateTime: DateTime.parse(map['date_time']),
      privileges: map['privileges'] != null
          ? (map['privileges'] as List)
              .map((p) => Privilege.fromMap(p as Map<String, dynamic>))
              .toList()
          : [],
          order: map['order'] as int
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'type': type,
      'color': color.value,
      //'format': format,
      'date_time': dateTime.toIso8601String(),
      'privileges': privileges.map((privilege) => privilege.toMap()).toList(),
      'order': order
    };
  }  

  WorshipServiceFormat copyWith({
    String? id,
    String? type,
    Color? color,
    //String? format,
    DateTime? dateTime,
    List<Privilege>? privileges,
    int? order
  }){
    return WorshipServiceFormat(
      id: id ?? this.id,
      type: type ?? this.type, 
      color: color ?? this.color, 
      //format: format ?? this.format,
      dateTime: dateTime ?? this.dateTime,
      privileges: privileges ?? this.privileges,
      order: order ?? this.order
    );
  }

}