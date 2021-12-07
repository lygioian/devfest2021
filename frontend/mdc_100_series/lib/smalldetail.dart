import 'package:flutter/material.dart';

class SmallDetail extends StatefulWidget {
  const SmallDetail({Key? key}) : super(key: key);

  @override
  _SmallDetailState createState() => _SmallDetailState();
}

class _SmallDetailState extends State<SmallDetail> {

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    return MaterialApp(
      home: Container(
        child: ListView(children: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () {
            Navigator.pushNamed(
            context,
            '/detailedpage',
            arguments: {'id': id},
          ); //Navigate to post help request here} ),
          }
        )]),
      ),  
    );
  }
}