import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: "1", nombre: "Massiel", email: "test1@test.com", online: true),
    Usuario(uid: "2", nombre: "Kanko", email: "test2@test.com", online: true),
    Usuario(uid: "3", nombre: "Salomon", email: "test2@test.com", online: false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mi Nombre"),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            // Icon(Icons.offline_bolt, color: Colors.red)
          )
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

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(
        usuario.email,
        style: const TextStyle(color: Colors.black54),
      ),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  void _cargarUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}
