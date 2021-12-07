import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Data {
  final String name;
  final String title;
  final String tel;
  final String address;
  final String description;
  final String requestHelp;
  final List<dynamic> media;

  Data({
    required this.name,
    required this.title,
    required this.tel,
    required this.address,
    required this.description,
    required this.requestHelp,
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
      media: json['media']
    );
  }
}

class DetailedPage extends StatefulWidget {
  const DetailedPage({Key? key}) : super(key: key);

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  late Future<Data> futureData;

  //Actual fetch from API function
  Future<Data> _fetchData(_id) async {
    final response = await http.get(Uri.parse('https://api.devfest.top/post/$_id')); //Paste URL here

    if (response.statusCode == 200) {
      final value = jsonDecode(response.body);
      return Data.fromJson(value['payload']);
    } else {
      throw Exception('Failed to load data.');
    }
  }

  // //Mock fetch from API function
  // Future<Data> _fetchData(_id) async {
  //   return await Future<Data>.delayed(
  //     const Duration(seconds: 5),
  //     () => Data(
  //       name: 'Lol$_id',
  //       title: 'Need a plumber',
  //       tel: '6996-6996',
  //       address: '123 Lamppost st., Ward 2, District 12, HCMC',
  //       description: 'My toilet broke.',
  //       requestHelp: 'I need someone who is handy.',
  //       media: ['linkToA', 'linkToB'],
  //     ),
  //   );
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _id = ModalRoute.of(context)!.settings.arguments.toString();
    futureData = _fetchData(_id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(100, 0, 10, 0),
          child: Text(
            'LinkUp',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }, //Navigate back to map view here
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            FutureBuilder<Data>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.title,
                    textScaleFactor: 2,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ), //API call to title
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FutureBuilder<Data>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int count = snapshot.data!.media.length;
                        List<Widget> images = [];
                        for(int i = 0; i < count; i++) {
                          images.add(
                            Image.network(snapshot.data!.media[i].toString()),
                          )
                        ;}
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: images,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const Center(child: CircularProgressIndicator(),);
                    },
                  ), //API call to fetch each image
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<Data>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.name);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ), //API call to name
                FutureBuilder<Data>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.tel);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ), //API call to tel
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<Data>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.address);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ), //API call to address
              ],
            ),
            const SizedBox(height: 15.0),
            const Text("Description:"),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              height: 100,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  FutureBuilder<Data>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.description);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ), //API call to description
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            const Text("Help request:"),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              height: 75,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  FutureBuilder<Data>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.requestHelp);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ), //API takes in help request
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
