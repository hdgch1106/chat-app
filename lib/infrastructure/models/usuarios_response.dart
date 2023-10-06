import 'dart:convert';

UsuariosResponse usuariosResponseFromJson(String str) =>
    UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) =>
    json.encode(data.toJson());

class UsuariosResponse {
  bool ok;
  List<Usuario> usuarios;

  UsuariosResponse({
    required this.ok,
    required this.usuarios,
  });

  UsuariosResponse copyWith({
    bool? ok,
    List<Usuario>? usuarios,
  }) =>
      UsuariosResponse(
        ok: ok ?? this.ok,
        usuarios: usuarios ?? this.usuarios,
      );

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(
            json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}

class Usuario {
  String name;
  String email;
  String uid;
  bool online;

  Usuario({
    required this.name,
    required this.email,
    required this.uid,
    required this.online,
  });

  Usuario copyWith({
    String? name,
    String? email,
    String? uid,
    bool? online,
  }) =>
      Usuario(
        name: name ?? this.name,
        email: email ?? this.email,
        uid: uid ?? this.uid,
        online: online ?? this.online,
      );

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "online": online,
      };
}
