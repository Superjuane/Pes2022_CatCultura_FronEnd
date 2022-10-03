import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:tryproject2/views/screens/home.dart';
import 'package:tryproject2/views/screens/login.dart';
import 'package:tryproject2/views/screens/profile.dart';
import 'package:tryproject2/views/screens/events.dart';
import 'package:tryproject2/views/screens/map.dart';

void main() {
  debugPaintSizeEnabled=false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'tryProject2',
        theme: ThemeData(fontFamily: 'OpenSans'),
        initialRoute: "/login",
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/login": (BuildContext context) => const Login(),
          "/home": (BuildContext context) => Home(),
          "/profile":(BuildContext context) => const Profile(),
          "/events":(BuildContext context) => Events(),
          "/map":(BuildContext context) => Map(),
        });
  }
}

