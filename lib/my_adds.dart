import 'package:flutter/material.dart';
import 'first_screen.dart';

class MyAdds extends StatefulWidget {
  @override
  _MyAddsState createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: Center(
            child: Text(
              'My Ads',
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  "ADs",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  "FAVORITE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FirstScreen(true),
            Container(),
          ],
        ),
      ),
    );
  }
}
