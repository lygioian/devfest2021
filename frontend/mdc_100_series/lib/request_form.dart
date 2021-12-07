// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'new_request.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Data {
  final String name;
  final String title;
  final String tel;
  final String address;
  final String description;
  final String requestHelp;
  final List<double> coordinates;
  final List<String> media;

  Data({
    required this.name,
    required this.title,
    required this.tel,
    required this.address,
    required this.description,
    required this.requestHelp,
    required this.coordinates,
    required this.media,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      title: json['title'],
      tel: json['tel'],
      address: json['address'],
      description: json['description'],
      requestHelp: json['requestHelp'],
      coordinates: json['coordinates'],
      media: json['media'],
    );
  }
}


class FormPage extends StatelessWidget {
  static String routeName = '/new_request/request_form';
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Tạo yêu cầu mới';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(appTitle),
      ),
      body: const RequestForm(),
    );
  }
}



// Create a Form widget.
class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  RequestFormState createState() {
    return RequestFormState();
  }
}

class RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  late Position currentPosition;
  late Data _imp;
  var imp;


  Future<Data> createData() async {
    final response = await http.post(
      Uri.parse('https://api.devfest.top/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_imp),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Dịch vụ truy cập vị trí đang tắt');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền truy cập vị trí bị từ chối');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Quyền truy cập bị chặn vĩnh viễn, không thể lấy được vị trí.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
            child: Transform.scale(
              scale: 1.2,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Họ & Tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else imp.name = value;
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
            child: Transform.scale(
              scale: 1.2,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số Điện Thoại',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else imp.tel = value;
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
            child: Transform.scale(
              scale: 1.2,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else imp.address = value;
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
            child: Transform.scale(
              scale: 1.2,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  else imp.title = value;
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 32),
            child: Transform.scale(
              scale: 1.2,
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập mô tả';
                  }
                  else imp.description = value;
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(280, 16, 36, 16),
            child: Transform.scale(
              scale: 1.2,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _getGeoLocationPosition();
                    imp.coordinates = currentPosition;
                    _imp = Data(
                      name: imp.name,
                      tel: imp.tel,
                      address: imp.address,
                      description: imp.description,
                      title: imp.title,
                      requestHelp: imp.requestHelp,
                      coordinates: imp.coordinates,
                      media: ['https://pic/1', 'https://pic/2', 'https://pic/3', 'https://pic/4', 'https://pic/5'],
                    );
                    createData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã gửi')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Gửi'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}