import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  OffLine,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
 
    _socket = IO.io('http://192.168.0.143:3000',<String, dynamic> {
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': true,
      'path': "/socket.io/socket.io"
    });

    _socket.on('connect', (_) {
     print('connect');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    
    _socket.on('disconnect', (_){ 
      print('disconnect');
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
     });

    //  _socket.on('nuevo-mensaje', (payload){
    //    print('nuevo-mensaje:');
    //    print('Nombre : '+ payload['nombre']);
    //    print('Mensaje : '+ payload['mensaje']);

    //  });
  }
}