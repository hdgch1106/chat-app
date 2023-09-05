import 'package:chat_app/presentation/pages/login_page.dart';
import 'package:chat_app/presentation/pages/usuarios_page.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/socket_provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text("Espere..."),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    final socket = Provider.of<SocketProvider>(context, listen: false);

    await authService.isLoggedIn();

    if (authService.state.authStatus == AuthStatus.authenticated) {
      if (context.mounted) {
        //Navigator.pushReplacementNamed(context, "usuarios");
        socket.connect();
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const UsuariosPage(),
              transitionDuration: const Duration(milliseconds: 0),
            ));
      }
    } else {
      //Navigator.pushReplacementNamed(context, "login");
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginPage(),
              transitionDuration: const Duration(milliseconds: 0),
            ));
      }
    }
  }
}
