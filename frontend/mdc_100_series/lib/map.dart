import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Data {
  final String id;
  final String name;
  final String title;
  final String tel;
  final String address;
  final String description;
  final String requestHelp;
  final Position coordinates;

  Data({
    required this.id,
    required this.name,
    required this.title,
    required this.tel,
    required this.address,
    required this.description,
    required this.requestHelp,
    required this.coordinates,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      tel: json['tel'],
      address: json['address'],
      description: json['description'],
      requestHelp: json['requestHelp'],
      coordinates: json['coordinates'],
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Future<Map> futureData;
  late Position currentPosition;
  final Set<Map> _data = {};
  final Set<Marker> _markers = {};

  //Actual fetch from API function
  Future<Map> parseData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Data>((json) => Data.fromJson(json)).toList();
  }

  Future<Map> _fetchData() async {
    final response = await http
        .get(Uri.parse('https://api.devfest.top/post')); //Paste URL here

    if (response.statusCode == 200) {
      final value = jsonDecode(response.body);
      value['payload'].forEach((dict) {
        _data.add(dict);
      });
      return value;
    } else {
      throw Exception('Failed to load data.');
    }
  }

  //Mock fetch from API function
  @override
  void initState() {
    super.initState();
    futureData = _fetchData();
    _getGeoLocationPosition();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      final marker = Marker(
        markerId: const MarkerId('Vị trí của tôi'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        infoWindow: const InfoWindow(
          title: 'Vị trí của tôi',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      _markers.add(marker);
      _getAllMarkers();
    });
  }

  void _getAllMarkers() {
    _data.forEach((user) {

      final marker = Marker(
        markerId: MarkerId(user['_id']),
        position: LatLng(double.parse(user['coordinates'][0]),
            double.parse(user['coordinates'][1])),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          Navigator.pushNamed(context, '/detailedpage', arguments: user['_id']);
        },
      );

      _markers.add(marker);
    });
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
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  'Người cần hỗ trợ quanh tôi',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.deepOrange,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back, // add custom icons also
                  ),
                )),
            body: FutureBuilder<Map>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currentPosition.latitude, currentPosition.longitude),
                      zoom: 13,
                    ),
                    markers: _markers,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}
