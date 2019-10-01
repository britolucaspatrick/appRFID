import 'dart:convert' as convert;
import 'package:apprfid/CadProduto.dart';
import 'package:apprfid/ConfigApp.dart';
import 'package:apprfid/Utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BK - RFID',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BK - RFID'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;

  @override
  void initState() {
    super.initState();
    getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Cad. Produto"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    CadProduto()));
              },
            ),
            new ListTile(
              title: new Text("Config. App"),
              onTap: (){
                Navigator.push(context,  MaterialPageRoute(builder: (context) =>
                  ConfigApp()));
              },
            ),
          ],
        ),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return new ListTile(
            title: new Text(data[i]["ValueTag"].toString().trim()),
            subtitle: new Text(data[i]["CodBarras"].toString().trim()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exportProdutos();
          return true;
        },
        tooltip: 'Exportar',
        child: Icon(Icons.cloud_upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> getProdutos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = prefs.getString('URL');
    var response = await http.get(URL + "/Produto",
        headers: { "Accept": "application/json" });
    setState(() {
      if (response.statusCode == 200) {
        data = convert.jsonDecode(response.body);
      } else {
        new Alert().showAlertDialog(context, "Request failed with status: ${response.statusCode}.");
      }
    });
  }

  _exportProdutos() {
    getProdutos();
  }

}


