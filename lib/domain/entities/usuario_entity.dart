import 'dart:convert';

UsuarioEntity usuarioEntityFromJson(String str) =>
    UsuarioEntity.fromJson(json.decode(str));

String usuarioEntityToJson(UsuarioEntity data) => json.encode(data.toJson());

class UsuarioEntity {
  final bool online;
  final String name;
  final String email;
  final String uid;
  final String token;

  UsuarioEntity({
    required this.online,
    required this.name,
    required this.email,
    required this.uid,
    required this.token,
  });

  factory UsuarioEntity.fromJson(Map<String, dynamic> json) => UsuarioEntity(
        online: json["online"],
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "uid": uid,
        "token": token,
      };
}
