import 'dart:ui';

//import 'package:create_page/screens/home.dart';
import 'package:flutter/material.dart';
import 'request_form.dart'

class NewRequest extends StatelessWidget {
  NewRequest({Key? key}) : super(key: key);

  var imp = Data();
  static String routeName = '/new_request';
  Image img1 = Image.network(
    'https://cdn1.iconfinder.com/data/icons/humanitarian-aid-filloutline/64/basket-food_and_restaurant-supply-healthy_food-diet-crate_-256.png',
    scale: 2,
  );
  Image img2 = Image.network(
    'https://cdn0.iconfinder.com/data/icons/back-to-school-filled-outline/512/supplies_school_education_pen_equipment_ruler_accessories-256.png',
    scale: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo yêu cầu mới'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 220, 178),
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Transform.scale(
                  scale: 1,
                  child: TextButton.icon(
                    icon: img1,
                    label: Text(
                      'Tiếp tế ',
                      textScaleFactor: 3,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/requestform');
                      imp.requestHelp = 'Tiếp tế';
                    },
                  ),
                ),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 220, 178),
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Transform.scale(
                  scale: 1,
                  child: TextButton.icon(
                    icon: img2,
                    label: Text(
                      'Dụng cụ học tập',
                      textScaleFactor: 3,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/requestform');
                      imp.requestHelp = 'Dụng cụ học tập';
                    },
                  ),
                ),
              ),
              Container(
                width: 350,
                height: 120,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 220, 178),
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Transform.scale(
                  scale: 1,
                  child: TextButton(
                    child: Text(
                      'Khác',
                      textScaleFactor: 3,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/requestform');
                      imp.requestHelp = 'Khác';
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
