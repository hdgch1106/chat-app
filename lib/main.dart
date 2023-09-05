import 'package:chat_app/config/routes/routes.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:chat_app/presentation/providers/login_form_provider.dart';
import 'package:chat_app/presentation/providers/register_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LoginFormProvider()),
        ChangeNotifierProvider(
          create: (context) => RegisterFormProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(useMaterial3: true),
        initialRoute: "loading",
        routes: appRoutes,
      ),
    );
  }
}
