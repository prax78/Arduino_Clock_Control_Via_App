import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';




void main()=>runApp(new MaterialApp(
  home: Bluetooth(),

));

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {




  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  BluetoothDevice mydevice;
  String op="Press ConnectBT Button";
  Color status;
  bool isConnectButtonEnabled=true;
  bool isDisConnectButtonEnabled=false;

  bool isSetDate=false;
  bool isHourPlus=false;
  bool isHourMinus=false;
  bool isMinutePlus=false;
  bool isMinuteMinus=false;
  bool isAlarmClaer=false;
  bool isAlarmset=false;










  void _connect() async  {
    List<BluetoothDevice> devices = [];
    setState(() {
      isConnectButtonEnabled=false;
      isDisConnectButtonEnabled=true;
      isSetDate=true;
      isHourPlus=true;
      isHourMinus=true;
      isMinutePlus=true;
      isMinuteMinus=true;
      isAlarmset=true;
      isAlarmClaer=true;
    });
    devices = await _bluetooth.getBondedDevices();
    // ignore: unnecessary_statements
    devices.forEach((device) {

      print(device);
      if(device.name=="HC-05")
      {
        mydevice=device;
      }
    });

    await BluetoothConnection.toAddress(mydevice.address)
        .then((_connection) {
      print('Connected to the device'+ mydevice.toString());
      _showtoastConnect(context);

      connection = _connection;});




    connection.input.listen(null).onDone(() {

      print('Disconnected remotely!');
    });

  }
  void _setdatetime()
  {

    connection.output.add(ascii.encode("${DateTime.now().year.toString()}:"));
    connection.output.add(ascii.encode("${DateTime.now().month.toString()}:"));
    connection.output.add(ascii.encode("${DateTime.now().day.toString()}:"));
    connection.output.add(ascii.encode("${DateTime.now().hour.toString()}:"));
    connection.output.add(ascii.encode("${DateTime.now().minute.toString()}:"));
    connection.output.add(ascii.encode("${DateTime.now().second.toString()}:"));
   print("${DateTime.now().year.toString()}:");
  }

void _hourplus()
{
  connection.output.add(ascii.encode("+"));

}

void _hourminus()
{
  connection.output.add(ascii.encode("-"));
}

void _minuteplus()
{
  connection.output.add(ascii.encode("p"));

}

void _minuteminus()
{
  connection.output.add(ascii.encode("m"));
}


  void _showalarm()
  {
    connection.output.add(ascii.encode("s"));
  }

void _clearalarm()
{
  connection.output.add(ascii.encode("c"));
}
  void _disconnect()
  {

    setState(() {
      op="Disconnected";
      isConnectButtonEnabled=true;
      isDisConnectButtonEnabled=false;
      isSetDate=false;
      isHourPlus =false;
      isHourMinus=false;
      isMinutePlus=false;
      isMinuteMinus=false;
      isAlarmset=false;
      isAlarmClaer=false;
    });
    connection.close();
    connection.dispose();
    _showtoastDisConnect(context);
  }

  void _showtoastConnect(context){
    final scaffold=ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: const Text("Connected"),duration: const Duration(seconds: 2),action: SnackBarAction(label: "Close",onPressed: scaffold.hideCurrentSnackBar,),),);
  }

  void _showtoastDisConnect(context){
    final scaffolds=ScaffoldMessenger.of(context);
    scaffolds.showSnackBar(SnackBar(content: const Text("Disconnected"),duration: const Duration(seconds: 2),action: SnackBarAction(label: "Close",onPressed: scaffolds.hideCurrentSnackBar,),),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Arduino Clock Assist ",style: TextStyle(color: Colors.black),),

        backgroundColor:Colors.blue,
      ),


      body:
      Column(
        children: [

          Center(
              child: Column(

                children: [

                  Card(color: Colors.white,elevation: 50,shadowColor: Colors.grey,
                    child:Text("Please make sure you paired your HC-05, its default password is 1234",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                  )
                ],
              )
          ),


          Container(
            child: Row(

              children: [

                Container(padding: EdgeInsets.all(5),child:TextButton(onPressed:isConnectButtonEnabled?_connect:null ,child: Text("Connect BT",style: TextStyle(fontSize: 17),) ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)))
                  ,),
                SizedBox(width: 5,),


                Container(padding: EdgeInsets.all(5),child:TextButton(onPressed:isDisConnectButtonEnabled?_disconnect:null,child: Text("Disconnect BT",style:TextStyle(fontSize: 17)),style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)))
                  ,),

              ],
            ),
          ),
          SizedBox(height: 50),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(child: TextButton(onPressed:isSetDate?_setdatetime:null, child: Text("Set Date/Time",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: Center(child: Text("SET ALARM",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),)),
                  Container(child: TextButton(onPressed:isHourPlus?_hourplus:null, child: Text("Hour+",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: TextButton(onPressed:isHourMinus?_hourminus:null, child: Text("Hour-",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: TextButton(onPressed:isMinutePlus?_minuteplus:null, child: Text("Minute+",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: TextButton(onPressed:isMinuteMinus?_minuteminus:null, child: Text("Minute-",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: TextButton(onPressed:isAlarmset?_showalarm:null, child: Text("Show Alarm on Device",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                  Container(child: TextButton(onPressed:isAlarmClaer?_clearalarm:null, child: Text("Clear Alarm",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent))),padding: EdgeInsets.all(10),),
                ],
              ),

            ],
          )





        ],

      ),



    );
  }
}
