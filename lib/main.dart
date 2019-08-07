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
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realController = TextEditingController();
  final _usdController = TextEditingController();
  final _eurController = TextEditingController();

  double _dolar;
  double _euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    _usdController.text = (real / _dolar).toStringAsFixed(2);
    _eurController.text = (real / _euro).toStringAsFixed(2);
  }

  void _usdChanged(String text) {
    double usd = double.parse(text);
    _realController.text = (usd * this._dolar).toStringAsFixed(2);
    _eurController.text = (usd * this._dolar / _euro).toStringAsFixed(2);
  }

  void _eurChanged(String text) {
    double eur = double.parse(text);
    _realController.text = (eur * this._euro).toStringAsFixed(2);
    _usdController.text = (eur * this._euro / _dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Exchange Converter \$"),
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
                    child: Text(
                  "Loading data...",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error on Loading data :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  _dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  _euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        buildTextField(
                            "BRL", "R\$", _realController, _realChanged),
                        Divider(),
                        buildTextField(
                            "USD", "US\$", _usdController, _usdChanged),
                        Divider(),
                        buildTextField("EUR", "€", _eurController, _eurChanged),
                      ],
                    ),
                  );
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

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}
