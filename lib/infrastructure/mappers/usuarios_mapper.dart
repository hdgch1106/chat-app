import 'package:chat_app/domain/entities/usuario_entity.dart';
import 'package:chat_app/infrastructure/models/usuarios_response.dart';

class UsuariosMapper {
  static List<UsuarioEntity> userJsonToEntityUsuarios(
      UsuariosResponse usuariosResponse) {
    List<UsuarioEntity> listaUsuarios = [];
    for (Usuario usuario in usuariosResponse.usuarios) {
      UsuarioEntity usuarioEntity = UsuarioEntity(
        online: usuario.online,
        name: usuario.name,
        email: usuario.email,
        uid: usuario.uid,
        token: "no-token",
      );
      listaUsuarios.add(usuarioEntity);
    }
    return listaUsuarios;
  }
}
