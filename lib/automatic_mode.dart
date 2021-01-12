import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Automatic extends StatefulWidget {
  Automatic({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AutomaticMode createState() => _AutomaticMode();
}

class _AutomaticMode extends State<Automatic> {
  int _val;
  final globalKey = GlobalKey<ScaffoldState>();
  final dbRef = FirebaseDatabase.instance.reference().child("select");
  void value() {
    dbRef.once().then((DataSnapshot data) {
      //print(data.value);
      //print(data.key);
      setState(() {
        _val = data.value;
      });
    });
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
            onPressed: () async {
              value();
              print(_val / 10);
              if (_val == 10) {
                bool result = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text(
                          'Automatic Mode is working do you want to continue in background'),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            int count = 0;
                            dbRef.set(0);
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () {
                            int count = 0;
                            dbRef.set(10);
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                            // dismisses only the dialog and returns true
                            _val = _val;
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              } else
                Navigator.pop(context);
            },
          ),
          title: Text("Automated Mode"),
        ),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    dbRef.set(10);
                    final snackBar = SnackBar(
                        content:
                            Text('Starting the automated mode in 2 seconds'));
                    globalKey.currentState.showSnackBar(snackBar);
                    //dbRef.child("Manual").set(0);
                    value();
                  },
                  child: Text("Start"),
                ),
                RaisedButton(
                  onPressed: () {
                    dbRef.set(0);
                    final snackBar = SnackBar(
                        content:
                            Text('Stoping the automated mode in 2 seconds'));
                    globalKey.currentState.showSnackBar(snackBar);
                    //dbRef.child("Manual").set(0);
                    value();
                  },
                  child: Text("Stop"),
                ),
              ]),
        ),
      ),
    );
  }
}
