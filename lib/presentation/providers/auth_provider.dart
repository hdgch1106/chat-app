import 'dart:convert';
import 'dart:io';

import 'package:chat_app/domain/entities/usuario_entity.dart';
import 'package:chat_app/infrastructure/models/login_response.dart';
import 'package:chat_app/infrastructure/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  AuthProviderState _state = AuthProviderState();

  AuthProviderState get state => _state;
  set state(AuthProviderState valor) {
    _state = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    if (token != null) return token;
    return "no-token";
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await AuthService().login(email, password);

      //Comprueba si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final loginResponse = loginResponseFromJson(response.body);
        UsuarioEntity usuario = _userJsonToLoginResponse(loginResponse);
        _saveToken(usuario.token);
        _setLoggedUser(usuario);
      } else {
        state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
      }
    } on SocketException catch (e) {
      state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
      throw Exception(e);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await AuthService().register(name, email, password);

      //Comprueba si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final loginResponse = loginResponseFromJson(response.body);
        UsuarioEntity usuario = _userJsonToLoginResponse(loginResponse);
        await _saveToken(usuario.token);
        _setLoggedUser(usuario);
      } else {
        //Almacena el error en el estado
        final respBody = jsonDecode(response.body);
        state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: respBody["msg"].toString(),
        );
      }
    } on SocketException catch (e) {
      state = state.copyWith(authStatus: AuthStatus.notAuthenticated);

      throw Exception(e);
    }
  }

  Future<void> isLoggedIn() async {
    final token = await _storage.read(key: "token");

    if (token == null) return;
    final response = await AuthService().renewToken(token);

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      UsuarioEntity usuario = _userJsonToLoginResponse(loginResponse);
      await _saveToken(usuario.token);
      _setLoggedUser(usuario);
    } else {
      logout();
    }
  }

  void _setLoggedUser(UsuarioEntity usuario) async {
    state = state.copyWith(
      usuario: usuario,
      authStatus: AuthStatus.authenticated,
      errorMessage: "",
    );
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: "token", value: token);
  }

  UsuarioEntity _userJsonToLoginResponse(LoginResponse loginResponse) =>
      UsuarioEntity(
        name: loginResponse.usuario.name,
        email: loginResponse.usuario.email,
        uid: loginResponse.usuario.uid,
        token: loginResponse.token,
        online: true,
      );

  Future logout([String? errorMessage]) async {
    await _storage.delete(key: "token");
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage ?? "",
    );
  }
}

//State
enum AuthStatus { authenticated, notAuthenticated }

class AuthProviderState {
  final AuthStatus authStatus;
  final UsuarioEntity? usuario;
  final String errorMessage;

  AuthProviderState({
    this.authStatus = AuthStatus.notAuthenticated,
    this.usuario,
    this.errorMessage = "",
  });

  AuthProviderState copyWith({
    AuthStatus? authStatus,
    UsuarioEntity? usuario,
    String? errorMessage,
  }) =>
      AuthProviderState(
        authStatus: authStatus ?? this.authStatus,
        usuario: usuario ?? this.usuario,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
