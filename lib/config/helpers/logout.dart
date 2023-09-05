import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:chat_app/presentation/providers/login_form_provider.dart';
import 'package:chat_app/presentation/providers/register_form_provider.dart';
import 'package:chat_app/presentation/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Logout {
  void logoutUser(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context, listen: false);
    final registerForm =
        Provider.of<RegisterFormProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final socket = Provider.of<SocketProvider>(context, listen: false);

    Navigator.pushReplacementNamed(context, "login");
    socket.disconnect();
    loginForm.logout();
    registerForm.logout();
    auth.logout();
  }
}
