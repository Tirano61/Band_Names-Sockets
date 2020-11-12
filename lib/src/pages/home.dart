import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  




  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Los Redondos', votes: 10),
    Band(id: '3', name: 'Soda Estereo', votes: 3),
    Band(id: '4', name: 'Los Piojos', votes: 7),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, int index) { 
        return _bandTitle(bands[index]);
       },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 5,
        onPressed: _addNewBand,
        
      ),
    );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 10),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band',style: TextStyle(color: Colors.white),),
        ),
        
        
      ),
      
        child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),

        onTap: (){
          print(band.name);
        },
      ),
    );
  }


  _addNewBand(){
    final textController = new TextEditingController();

    // if(Platform.isAndroid){
    //   showDialog(
    //     context: context,
    //     builder: (context){
    //       return AlertDialog(
    //         title: Text('New Band Name'),
    //         content: TextField(
    //           controller: textController,
    //         ),

    //         actions: [
    //           MaterialButton(
    //             child: Text('Add'),
    //             textColor: Colors.blue,
    //             elevation: 5,
    //             onPressed: (){
    //               addBandToList(textController.text);
    //             } 
    //           ),
    //         ],
    //       );
    //     },

    //   );
    // }

    showCupertinoDialog(
      context: context, 
      builder: (_){
        return CupertinoAlertDialog(
          title: Text('New Band Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          
          actions: [
            CupertinoDialogAction(
              child: Text('Add'),
              isDefaultAction: true,
              onPressed: (){
                addBandToList(textController.text);
              },
            ),
            CupertinoDialogAction(
              child: Text('Close'),
              isDestructiveAction: true,
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  void addBandToList(String name){
    if(name.length > 1){
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});  
    }

    Navigator.pop(context);
  }


}