import 'package:chat_app/presentation/pages/chat_page.dart';
import 'package:chat_app/presentation/pages/loading_page.dart';
import 'package:chat_app/presentation/pages/login_page.dart';
import 'package:chat_app/presentation/pages/register_page.dart';
import 'package:chat_app/presentation/pages/usuarios_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  "usuarios": (_) => const UsuariosPage(),
  "chat": (_) => const ChatPage(),
  "login": (_) => const LoginPage(),
  "register": (_) => const RegisterPage(),
  "loading": (_) => const LoadingPage(),
};
