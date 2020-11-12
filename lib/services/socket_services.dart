

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  OnLine,
  OffLine,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  get serverStatus => this._serverStatus;

  SocketService(){
    this._initConfig();
  }

  IO.Socket get socket => this._socket;

  void _initConfig(){

    // Dart client
    this._socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true
    // optional
  });
 

    // this._socket = IO.io('http://192.168.0.143:3000',{
    //   'transports': ['websocket'],
    //   'autoConnect': true
    // });
    this._socket.on('connect', (_) {
     print('connect flutter');
     this._serverStatus = ServerStatus.OnLine;
     notifyListeners();
     
    });
    
    this._socket.on('disconnect', (_){
      print('disconnect');
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });
    
  }







}