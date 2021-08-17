import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// when app is in background
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        "second": (_) => SecondPage(),
      },
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Second Page"),
      ),
      body: Center(
        child: Text("Welcome man!"),
      ),

    );
  }

}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    // ForeGround
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null) {
        print(message.notification.body);
        print(message.notification.title);
      }
    });

    // When the app is in background but opened and the user taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeMessage = message.data["route"];
      if(routeMessage != null && routeMessage == "second"){
        Navigator.of(context).pushNamed("second");
      }
      print(routeMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notification Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Push Notification Demo',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.send),
      ),
    );
  }
}
