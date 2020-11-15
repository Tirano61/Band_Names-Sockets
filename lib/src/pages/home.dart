

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:band_names/models/band.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:pie_chart/pie_chart.dart';


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Los Redondos', votes: 10),
    // Band(id: '3', name: 'Soda Estereo', votes: 3),
    // Band(id: '4', name: 'Los Piojos', votes: 7),
  ];


  @override
  void initState() { 
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.on('active-bands', _handleActiveBands);

    super.initState( );
    
  }

  _handleActiveBands( dynamic payload){
    this.bands = (payload as List).map(
        (band) => Band.fromMap(band)).toList();
        setState(() {});
  }


  @override
  void dispose() {
    //Dejar de escuchar el evento
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketService>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketServices.serverStatus == ServerStatus.Online) 
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.check_circle, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGrafic(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, int index) { 
              return _bandTitle(bands[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 5,
        onPressed: _addNewBand,
        
      ),
    );
  }

  Widget _showGrafic(){

    final List<Color> colorList=[
      Colors.blue[50],
      Colors.yellow[200],
      Colors.pink[50],
      Colors.blue[200],
      Colors.orange[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.orange[200],
      Colors.deepPurple[50],
      Colors.deepPurple[200],

    ];


    Map<String, double> dataMap = new Map();
     // dataMap.putIfAbsent(key, () => null)
    bands.forEach((band) { 
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });  

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(

      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 15,
      centerText: "BANDS",
      
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        decimalPlaces: 0,
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        chartValueStyle: TextStyle(fontWeight: FontWeight.w300,color: Colors.black87, fontSize: 12),
      ),
    )
      
      
      
      );
  }

  Widget _bandTitle(Band band) {
    //No nesecito que se redibuje el widget cuando reciba la notifivcacion por ese va listen: false
    final socketServices = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ){
        socketServices.socket.emit('delete-band', {'id': band.id});
      },
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
          socketServices.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  _addNewBand(){
    final textController = new TextEditingController();
    
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
    final socketServices = Provider.of<SocketService>(context, listen: false);
    if(name.length > 1){
      socketServices.socket.emit('new-band',{'band': name });
    }
    Navigator.pop(context);
  }
}