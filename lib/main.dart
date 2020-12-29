import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'Statics.dart';
import 'package:screen/screen.dart';

void main() {

// needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: false
  );
// Periodic task registration
  Workmanager.registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );
  Workmanager.registerOneOffTask("uniqueName", "callbackDispatcher");




  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {

    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android, IOS);
    flip.initialize(settings);

/*    for (int i =0 ;i<14;i++){
      sleep1().then((value) => {
        _showNotificationWithDefaultSound(flip)
      });
    }*/

//    while(true) {
//
//      sleep1().then((value) => {
//
//      });
//
//    }

    _showNotificationWithDefaultSound(flip);

    return Future.value(true);
  });
}

Future sleep1() {
  return new Future.delayed(const Duration(seconds: 60), () => "1");
}

Future _showNotificationWithDefaultSound(flip) async {

// Show a notification after every 15 minute with the first
// appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '5',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

// initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics
  );
  var rnd = new Random();
  int randomx=rnd.nextInt(Statics.map.length-1);
  //thread
  await flip.show(0, Statics.map[randomx],
      Statics.map[randomx],
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Words',
      theme: ThemeData(

        // This is the theme
        // of your application.
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: "English Words"),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String value="";


@override
  void initState() {
    // TODO: implement initState

  Timer.periodic(Duration(seconds: 10), (timer) {
    var rnd = new Random();
    int randomx=rnd.nextInt(Statics.map.length-1);
    value=Statics.map[randomx];
    //print(value);
    setState(() {

    });
  });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(


        title: Text(widget.title),
      ),
      body: new Container(
          padding: new EdgeInsets.all(10.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text('Words', style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                new SizedBox(height: 10,),
                new Text(value, style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                new SizedBox(height: 10,),
                new Expanded(
                    child: new ListView.builder(

                  itemCount: Statics.map.length,
                  itemBuilder: (BuildContext context, int index){
                    int key = Statics.map.keys.elementAt(index);
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new Row(

                        children: <Widget>[
                          new Text('${key} :[ '),
                          new Text(Statics.map[key]+" ]")
                        ],
                      ),
                    );
                  },

                ))

              ],
            ),
          )
      ),
    );
  }
}
