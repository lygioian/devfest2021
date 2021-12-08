import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed( context, '/requestview'); //Navigate to post help request here
          },
        ),
        title: const Text("Zalo Connect"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Help others in need, or post a request if you're in need!",
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Card(
                  elevation: 10,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          '/helprequest',
                      ); //Navigate to post help request here
                    },
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 25,
                          width: 165,
                        ),
                        IconButton(
                          icon: Icon(Icons.warning_rounded),
                          iconSize: 100,
                          onPressed: null,
                        ),
                        Text("Seeking help?"),
                        Text("Fill out some info"),
                        SizedBox(
                          height: 25,
                          width: 165,
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  elevation: 10,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pushNamed(context, '/mapview'); //Navigate to map view here
                    },
                    child: Column(
                      children: const [
                        SizedBox(
                            height: 25,
                            width: 165
                        ),
                        IconButton(
                          icon: Icon(Icons.add_location),
                          iconSize: 100,
                          onPressed: null,
                        ),
                        Text("Offering help?"),
                        Text("Get started"),
                        SizedBox(
                          height: 25,
                          width: 165,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/helprequest',
          ); //Navigate to post help request here
        },
        tooltip: 'Get help!',
        child: const Icon(Icons.warning_rounded, size: 35),
      ),
    );
  }
}
