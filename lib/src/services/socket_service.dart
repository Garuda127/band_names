import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  Function get emit => _socket.emit;
  set socket(IO.Socket value) {
    _socket = value;
    notifyListeners();
  }

  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://10.0.2.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
