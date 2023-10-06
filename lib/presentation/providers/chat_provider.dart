import 'package:chat_app/domain/entities/usuario_entity.dart';
import 'package:chat_app/infrastructure/models/mensajes_response.dart';
import 'package:chat_app/infrastructure/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  late UsuarioEntity usuarioPara;

  Future<List<Mensaje>> cargarHistorial(String uid) async {
    final mensajes = await ChatService().getChat(uid);
    return mensajes;
  }
}
