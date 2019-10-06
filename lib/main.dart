import 'dart:convert' as convert;
import 'package:apprfid/CadProduto.dart';
import 'package:apprfid/ConfigApp.dart';
import 'package:apprfid/Utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  List dados;
  bool _inputIsValid = true;

  @override
  void initState() {
    super.initState();
    getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    //ListView Custom Itens
    final _biggerFont = const TextStyle(fontSize: 18.0);
    final _biggerFontSubt = const TextStyle(fontSize: 9.0);

    Widget _buildRow(String CodBarras, String Quantidade){
      return ListTile(
        title: Text(
          'Cód Barras: $CodBarras',
          style: _biggerFont,
        ),
        subtitle: Text(
          'Quant: $Quantidade',
          style: _biggerFontSubt,
        ),
      );
    }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 5.0, width: 5.0,),
          Expanded(
            flex: 1,
            child:
            TextField(
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.display1,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'TAG',
                errorText: _inputIsValid ? null :'Aproxime o leitor do produto com a TAG',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onChanged: (String val){
                if (val.length == 10){
                  setState(() => _addQuantidadeItem(val));
                }else{
                  setState(() => _inputIsValid = false);
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child:
            new ListView.builder(
              itemCount: dados == null ? 0 : dados.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, i) {
                dados[i]["Quantidade"] = '0';
                return _buildRow(dados[i]["CodBarras"].toString().trim(), dados[i]["Quantidade"].toString().trim());
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exportProdutos();
          return true;
        },
        child: Icon(Icons.cloud_upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addQuantidadeItem(String ValueTag){
    dados.forEach((value) =>
    {
      if (value["ValueTag"].toString() == ValueTag) {
        value["Quantidade"] = (int.parse(value["Quantidade"]) + 1).toString(),
        Fluttertoast.showToast( msg: 'entrou')
      }
    });
  }

  Future<String> getProdutos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = prefs.getString('URL');
    await http.get(URL + "/Produto",
        headers: { "Accept": "application/json" }).then((value)
    {
      setState(() {
        if (value.statusCode == 200) {
          dados = convert.jsonDecode(value.body);
        } else {
          Fluttertoast.showToast( msg: 'Error status-code: ${value.statusCode}');
        }
      });
    }).catchError((error)
    {
      Fluttertoast.showToast( msg: 'Error: ${error.toString()}');
    });
  }

  _exportProdutos() {
    getProdutos();
  }

}


