import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Manual extends StatefulWidget {
  Manual({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ManualMode createState() => _ManualMode();
}

class _ManualMode extends State<Manual> {
  int _val = 0;
  //int _straight = 0;
  String data;
  final globalKey = GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference().child("select");
  //final dbstrref = FirebaseDatabase.instance.reference().child("data");
  //final wateref = FirebaseDatabase.instance.reference().child("mop");
  void value() {
    dbRef.once().then((DataSnapshot data) {
      //print(data.value);
      //print(data.key);
      setState(() {
        _val = data.value;
      });
    });
    //data = "Next obstacle is at" + _straight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        key: globalKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("Manual Mode"),
        ),
        body: new Center(
          child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.end,

              children: <Widget>[
                //Text("hello"),
                if (_val == 21) Text("Going Straight"),
                if (_val == 22) Text("Going back"),
                if (_val == 23) Text("Turning left"),
                if (_val == 24) Text("Turning right"),
                if (_val == 29) Text("Water will be pumped in 1 sec"),

                Align(
                  alignment: FractionalOffset(0.2, 0.6),
                  child: RaisedButton(
                    onPressed: () {
                      //dbRef.child("Automatic").set(0);
                      dbRef.set(20);
                      final snackBar = SnackBar(
                          content:
                              Text('Starting the manual mode in 2 seconds'));
                      globalKey.currentState.showSnackBar(snackBar);
                      value();
                    },
                    child: Text("Start"),
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.5, 0.2),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      if (_val / 10 >= 2.0) dbRef.set(21);
                      value();
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.3, 0.3),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_val / 10 >= 2.0) dbRef.set(24);
                      value();
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.7, 0.3),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (_val / 10 >= 2.0) dbRef.set(23);
                      //dbRef.set(21);
                      value();
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.5, 0.4),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      if (_val / 10 >= 2.0) dbRef.set(22);
                      value();
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.8, 0.6),
                  child: RaisedButton(
                    onPressed: () {
                      //dbRef.child("Automatic").set(0);
                      if (_val / 10 >= 2.0) dbRef.set(0);
                      value();
                      final snackBar = SnackBar(
                          content:
                              Text('Stoping the manual mode in 2 seconds'));
                      globalKey.currentState.showSnackBar(snackBar);
                    },
                    child: Text("Stop"),
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.5, 0.8),
                  child: RaisedButton(
                    onPressed: () {
                      //dbRef.child("Automatic").set(0);
                      if (_val / 10 >= 2.0) dbRef.set(29);
                      value();
                    },
                    child: Text("Water pump"),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
