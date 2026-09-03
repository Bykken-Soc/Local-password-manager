import 'dart:convert';

// Data model representing a password credential entry within the application
class PasswordModel {
  final int? id; // Optional ID since new passwords do not have a database ID yet
  final String site;
  final String user;
  final String contrasenaEncriptada;
  final String category;

  PasswordModel({
    this.id,
    required this.site,
    required this.user,
    required this.contrasenaEncriptada,
    required this.category,
  });

  // Utility method to clone the model while changing specific properties safely
  PasswordModel copyWith({
    int? id,
    String? site,
    String? user,
    String? contrasenaEncriptada,
    String? category,
  }) {
    return PasswordModel(
      id: id ?? this.id,
      site: site ?? this.site,
      user: user ?? this.user,
      contrasenaEncriptada: contrasenaEncriptada ?? this.contrasenaEncriptada,
      category: category ?? this.category,
    );
  }

  // Deserialization: Converts an incoming JSON map from the API into a Dart object instance
  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'] as int?,
      site: json['WebSite'] as String? ?? json['title'] as String? ?? '', 
      user: json['user'] as String? ?? 'No user',
      contrasenaEncriptada: json['contrasenaEncriptada'] as String? ?? '',
      category: json["Category"] as String? ?? 'without category',
    );
  }

  // Serialization: Converts the Dart object instance into a JSON map to send to the API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sitioWeb': site,
      'usuario': user,
      'contrasenaEncriptada': contrasenaEncriptada,
    };
  }
}