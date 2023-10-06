import 'package:chat_app/config/const/environment.dart';
import 'package:chat_app/domain/entities/usuario_entity.dart';
import 'package:chat_app/infrastructure/mappers/usuarios_mapper.dart';
import 'package:chat_app/infrastructure/models/usuarios_response.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  Future<List<UsuarioEntity>> getUsuarios() async {
    try {
      final url = Uri.parse("${Environment.apiUrl}/usuarios");

      final resp = await http.get(url, headers: {
        "Content-Type": "application/json",
        "x-token": await AuthProvider.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      final usuariosEntity =
          UsuariosMapper.userJsonToEntityUsuarios(usuariosResponse);
      return usuariosEntity;
    } catch (e) {
      return [];
    }
  }
}
