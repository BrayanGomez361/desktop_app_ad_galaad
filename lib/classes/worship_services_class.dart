
import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum WorshipServiceType{
  general('Culto general', Color(0xFF1E88E5) ),
  oracion('Culto de oración', Color(0xFF43A047)),
  meidad('Culto de MEIDAD', Color(0xFF8E24AA)),
  cmf('Culto del Concilio Misionero Femenil', Color(0xFFFB8C00)),
  ensenanza('Culto de Enseñanza', null),
  fraternidad('Culto de Fraternidad', null),
  ecad('Culto juvenil', null),
  escueldom('Culto de Escuela Dominical', null),
  exploradores('Culto de Exploradores del Rey', null),
  santaCena('Culto de Santa Cena', null),
  misioneritas('Culto de Misioneritas', null);

  final String etiqueta;
  final Color? colorPredefinido;

  const WorshipServiceType(this.etiqueta, this.colorPredefinido);

  Color get color => colorPredefinido ?? Colors.black;

}

class WorshipService{
  String? id;
  String? weekId;
  Color color;
  int order; // Posicion dentro del arreglo de programas dentro de la semana
  String type; // Tipo de culto
  DateTime dateTime;
  List<Privilege> privileges;
  Map<String, DateTime> lastUpdated;
  

  WorshipService({
    this.id,
    this.weekId,
    this.color = Colors.black,
    required this.order,
    required this.type,
    required this.dateTime,
    required this.privileges,
    required this.lastUpdated
  });

  factory WorshipService.fromMap(Map<String, dynamic> map) {
    return WorshipService(
      id: map['id'],
      weekId: map['week_id'],
      order: map['service_index'] ?? 0,
      type: map['type'] ?? '',
      dateTime: DateTime.parse(map['date_time']),
      privileges: map['privileges'] != null
          ? (map['privileges'] as List)
              .map((p) => Privilege.fromMap(p))
              .toList()
          : [],
          color: map['color'] != null 
            ? Color(map['color'] as int) 
            : Colors.black,
      // Mapea el objeto JSONB a Map<String, DateTime>
      lastUpdated: map['last_updated'] != null
          ? (map['last_updated'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, DateTime.parse(value.toString())),
            )
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'week_id': weekId,
      'type': type,
      'date_time': dateTime.toIso8601String(),
      'service_index': order,
      // Convierte DateTime a String ISO para guardarlo como JSONB en Supabase
      'last_updated': lastUpdated.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'color': color.value,
    };
  }

  WorshipService copyWith({
    String? id,
    String? weekId,
    Color? color,
    int? order, // Posicion dentro del arreglo de programas dentro de la semana
    String? type, // Tipo de culto
    DateTime? dateTime,
    List<Privilege>? privileges,
    Map<String, DateTime>? lastUpdated
  }){
    return WorshipService(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      color: color ?? this.color,
      order: order ?? this.order, 
      type: type ?? this.type, 
      dateTime: dateTime ?? this.dateTime, 
      privileges: privileges ?? this.privileges, 
      lastUpdated: lastUpdated ?? this.lastUpdated);
  }


}