import 'package:chat_app/config/const/environment.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketProvider with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;
  //Function get emit => _socket.emit;

  void connect() {
    _socket = io(Environment.socketUrl, {
      "transports": ["websocket"],
      "autoConnect": true,
      "forceNew": true
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
