import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "LinkUp",
            textAlign: TextAlign.center,
          ),
        ),

        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Giúp những người cần bạn, hoặc tìm những người bạn cần!",
              style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Card(
                  elevation: 10,
                  child: InkWell(
                    splashColor: Colors.deepOrange.withAlpha(30),
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
                          icon: Icon(Icons.warning_rounded, color: Color.fromARGB(150, 181, 148, 27)),
                          iconSize: 100,
                          onPressed: null,
                        ),
                        Text("Cần sự giúp đỡ?"),
                        Text("Điền thông tin tại đây"),
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
                    splashColor: Colors.deepOrange.withAlpha(30),
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
                          icon: Icon(Icons.add_location, color: Color.fromARGB(150, 181, 148, 27)),
                          iconSize: 100,
                          onPressed: null,
                        ),
                        Text("Bạn muốn giúp đỡ?"),
                        Text("Bắt đầu ngay!"),
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
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
