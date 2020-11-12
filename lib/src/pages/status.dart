import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class StatusPage extends StatelessWidget {
  
  
  

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ServerStatus : ${ socketServices.serverStatus }'),
          ],
        ),
      ),
      
    );
  }
}