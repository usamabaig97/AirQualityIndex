import 'dart:convert';
import 'dart:html';
import 'airquality.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHome(),
    );
  }
}
class MyHome extends StatefulWidget {
  const MyHome({Key, key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  Location location = Location();
  bool serviceisEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  bool isListenLocation=false;
  bool isGetLocation =false;

  void latlong() async{
    serviceisEnabled = await location.serviceEnabled();
    if(!serviceisEnabled) {
      serviceisEnabled = await location.requestService();
      if(serviceisEnabled) return;
    };
    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted) return;
    };
    locationData = await location.getLocation();
    setState(() {
      isGetLocation = true;
    });

  }

  String time;


  Future<void> getData() async {
    try{
      http.Response response =await http.get(Uri.parse('https://api.waqi.info/feed/lahore/?token=452d4d9aa80481470f162f9bb71ec7290621e718'));
     // print(response.body);
      Map data = jsonDecode(response.body);
       //print(data);
      AirQuality airQuality = AirQuality.fromjson(data);

      String dominentpol = airQuality.dominentpol;
      String geo = airQuality.city['geo'].toString();
      String cityname = airQuality.city['name'];
      String measurementTime = airQuality.time['iso'];

      DateTime now = DateTime.parse(measurementTime);
      time = DateFormat.jm().format(now) + ' ' + DateFormat.yMMMEd().format(now) ;
      //time = now.toString();

      print(geo);
      print(dominentpol);
      print(cityname);
      print(time);
    }
    catch (e){
      print('Error Is $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality Index'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(onPressed: latlong,
              child: Text('get location'), color: Colors.amber,),
            isGetLocation ? Text('location: ${locationData.latitude} , ${locationData.longitude}') : Text('Unable to find location'),

            //SizedBox(height: 10.0,),
            FlatButton(onPressed: () {}, child: Text('listen location'), color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

