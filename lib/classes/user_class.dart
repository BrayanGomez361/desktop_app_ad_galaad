
class UsuarioApp {
  final String? id; // nullable para dejar que Supabase genere el ID
  final DateTime? createdAt;
  final String name;
  final String email;
  final DateTime? birthday;
  final String? rol;
  final String? photoUrl;
  final int? carne;

  UsuarioApp({
    this.id,
    this.createdAt,
    required this.name,
    required this.email,
    this.birthday,
    this.rol,
    this.photoUrl,
    this.carne
  });

  factory UsuarioApp.fromMap(Map<String, dynamic> map) {
    return UsuarioApp(
      id: map['id']?.toString(),
      // Parseo seguro de ISO-8601 a DateTime
      createdAt: map['created_at'] != null 
          ? DateTime.tryParse(map['created_at'].toString()) 
          : null,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      birthday: map['birthday'] != null 
          ? DateTime.tryParse(map['birthday'].toString()) 
          : null,
      rol: map['rol'] as String?,
      photoUrl: map['photo_url'] as String?,
      carne: map['carne'] != null 
        ? int.tryParse(map['carne'].toString())
        : null,
    );
  }

  /// Método esencial para enviar datos a Supabase al crear/editar
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // Solo incluye ID si ya existe
      'name': name,
      'email': email,
      'birthday': birthday?.toIso8601String(),
      'rol': rol,
      'photo_url': photoUrl,
      if(carne != null) 'carne': carne
    };
  }

  UsuarioApp copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? email,
    DateTime? birthday,
    String? rol,
    String? photoUrl,
  }) {
    return UsuarioApp(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      rol: rol ?? this.rol,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
  
}