import 'package:flutter/material.dart';
import 'home.dart';
import 'detailed.dart';
//import 'request_view.dart';

class ZaloConnectApp extends StatelessWidget {
  const ZaloConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZALO CONNECT',
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => const HomePage(),
        //'/mapview': (context) => const MapView(), //Khôi
        //'/helprequest': (context) => const RequestPage(), //An
        //'/requestview': (context) => const RequestView(), //Delete
        '/detailedpage': (context) => const DetailedPage(),
      },
    );
  }
}
