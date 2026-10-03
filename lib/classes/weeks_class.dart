import 'package:ad_galaad_app/classes/privilege_class.dart';
import 'package:ad_galaad_app/classes/worship_services_class.dart';

class WeeklySchedule {
  String? weekId; // automatico
  bool isCurrentWeek;
  List<Privilege> announcements;
  List<WorshipService> programs;
  String titulo;


  
  
  // Dejar que Supabase asigne el weekId porque localmente pudieran haber duplicados
  WeeklySchedule({
    this.weekId,
    this.isCurrentWeek = false,
    required this.announcements,
    required this.programs,
    required this.titulo
  });

  factory WeeklySchedule.fromMap(Map<String, dynamic> map) {
    return WeeklySchedule(
      weekId: map['id'],
      isCurrentWeek: map['is_current_week'] ?? false,
      announcements: map['announcements'] != null
          ? (map['announcements'] as List)
              .map((a) => Privilege.fromMap(a))
              .toList()
          : [],
      programs: map['services'] != null
          ? (map['services'] as List)
              .map((s) => WorshipService.fromMap(s))
              .toList()
          : [],
      titulo: map['titulo'] ?? 'Programas de la semana'
    );
  }

  Map<String, dynamic> toMap() {
  return {
    if (weekId != null) 'id': weekId, //[cite: 5]
    'is_current_week': isCurrentWeek, //[cite: 5]
    'titulo': titulo,
    'announcements': announcements.map((a) => a.toMap()).toList(),
    'services': programs.map((p) => p.toMap()).toList(), // ✅ Sin argumentos
  };
}

  WeeklySchedule copyWith({
    String? weekId,
    bool? isCurrentWeek,
    List<Privilege>? announcements,
    List<WorshipService>? programs,
    String? titulo
  }) {
    return WeeklySchedule(
      weekId: weekId ?? this.weekId,
      isCurrentWeek: isCurrentWeek ?? this.isCurrentWeek,
      // Usamos List.from para asegurarnos de pasar una copia nueva de la lista si no se especifica una nueva
      announcements: announcements ?? List<Privilege>.from(this.announcements),
      programs: programs ?? List<WorshipService>.from(this.programs),
      titulo: titulo ?? this.titulo
    );
  }

    /**
     * Privilege copyWith({
    String? id,
    String? weekId,
    String? serviceId,
    String? userId,
    String? type,
    String? guidelines,
    bool? isAnnouncement,
    int? order
  }){
    return Privilege(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      serviceId: serviceId ?? this.serviceId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      guidelines: guidelines ?? this.guidelines,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      order: order ?? this.order
    );
  }
     * 
     * 
     * 
     */


   


  
}