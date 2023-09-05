import 'dart:convert';

import 'package:chat_app/config/const/environment.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthService {
  Future<Response> login(String email, String password) async {
    try {
      final url = Uri.parse("${Environment.apiUrl}/login");
      final data = {"email": email, "password": password};

      final resp = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      return resp;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      final url = Uri.parse("${Environment.apiUrl}/login/new");
      final data = {
        "name": name,
        "email": email,
        "password": password,
      };

      final resp = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      return resp;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> renewToken(String token) async {
    try {
      final url = Uri.parse("${Environment.apiUrl}/login/renew");

      final resp = await http.get(url,
          headers: {"Content-Type": "application/json", "x-token": token});

      return resp;
    } catch (e) {
      throw Exception(e);
    }
  }
}
