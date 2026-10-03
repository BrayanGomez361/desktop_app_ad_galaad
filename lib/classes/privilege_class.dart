class Privilege {
  final String? id;
  final String? weekId;
  final String? serviceId;
  final String? userId;
  final String? type;
  final String? guidelines;
  final bool? isAnnouncement;
  final int order;
  


  Privilege({
    this.id,
    this.weekId,
    this.serviceId,
    this.userId,
    required this.type,
    this.guidelines,
    this.isAnnouncement = false,
    required this.order
  });

  factory Privilege.fromMap(Map<String, dynamic> map) {
    return Privilege(
      id: map['id'],
      weekId: map['week_id'],
      serviceId: map['service_id'],
      userId: map['user_id'],
      type: map['type'],
      guidelines: map['guidelines'],
      isAnnouncement: map['is_announcement'] ?? false,
      order: map['order']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      if (id != null) 'id': id, // solo incluye ID si ya existe

      if (weekId != null) 'week_id': weekId,
      if (serviceId != null) 'service_id': serviceId,
      if (userId != null) 'user_id': userId,
      'type': type,
      'guidelines': guidelines,
      'is_announcement': isAnnouncement,
      'order': order
    };
  }

  Privilege copyWith({
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

}