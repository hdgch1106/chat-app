import 'package:chat_app/config/helpers/logout.dart';
import 'package:chat_app/domain/entities/usuario_entity.dart';
import 'package:chat_app/infrastructure/models/login_response.dart';
import 'package:chat_app/infrastructure/services/usuarios_service.dart';
import 'package:chat_app/presentation/providers/chat_provider.dart';
import 'package:chat_app/presentation/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../providers/auth_provider.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsuarioService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<UsuarioEntity> usuarios = [];

  /* final usuarios = [
    UsuarioEntity(
        uid: "1",
        name: "Massiel",
        email: "test1@test.com",
        online: true,
        token: ""),
    UsuarioEntity(
        uid: "2",
        name: "Kanko",
        email: "test2@test.com",
        online: true,
        token: ""),
    UsuarioEntity(
        uid: "3",
        name: "Salomon",
        email: "test2@test.com",
        online: false,
        token: "")
  ]; */

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final socket = Provider.of<SocketProvider>(context);
    final usuario = auth.state.usuario ??
        UsuarioEntity(
          online: false,
          name: "no-name",
          email: "no-email",
          uid: "no-uid",
          token: "no-token",
        );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(usuario.name),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            if (context.mounted) {
              Logout().logoutUser(context);
            }
          },
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: socket.serverStatus == ServerStatus.online
                  ? Icon(Icons.check_circle, color: Colors.blue[400])
                  : const Icon(Icons.offline_bolt, color: Colors.red))
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      itemCount: usuarios.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return _usuarioListTile(usuarios[index]);
      },
    );
  }

  ListTile _usuarioListTile(UsuarioEntity usuario) {
    return ListTile(
      title: Text(usuario.name),
      subtitle: Text(
        usuario.email,
        style: const TextStyle(color: Colors.black54),
      ),
      leading: CircleAvatar(
        child: Text(usuario.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.usuarioPara = usuario;
        Navigator.pushNamed(context, "chat");
      },
    );
  }

  void _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}
