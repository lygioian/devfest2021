import 'package:flutter/material.dart';
import 'home.dart';
import 'detailed.dart';
import 'new_request.dart';
import 'request_form.dart';
import 'map.dart';
//import 'request_view.dart';

class LinkUpApp extends StatelessWidget {
  const LinkUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LINKUP',
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => const HomePage(),
        '/mapview': (context) => const MapPage(), //Khôi
        '/helprequest': (context) => NewRequest(), //An
        '/detailedpage': (context) => const DetailedPage(),
        '/requestform': (context) => const FormPage(),
      },
    );
  }
}
