import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dota2 match'),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Text("LOGIN",style: TextStyle(fontSize: 20),),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email '),
            )
          ],
        ),),
      ),
    );
  }
}
