import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=1fc4714a";

void main() async {
  print(await getData());
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Exchange App \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Loading data...",
                    style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25),
                    textAlign: TextAlign.center,)
                );
              default:
                if(snapshot.hasError){
                  return Center(
                      child: Text("Error on Loading data :(",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25),
                        textAlign: TextAlign.center,)
                  );
                }else{
                  return Container();
                }

            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
