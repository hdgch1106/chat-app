import 'package:chat_app/config/const/environment.dart';
import 'package:chat_app/infrastructure/models/mensajes_response.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<List<Mensaje>> getChat(String usuarioID) async {
    final url = Uri.parse("${Environment.apiUrl}/mensajes/$usuarioID");

    final resp = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-token": await AuthProvider.getToken()
      },
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
