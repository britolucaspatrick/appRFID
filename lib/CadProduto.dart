import 'package:apprfid/Utils/alert.dart';
import 'package:apprfid/Utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/Produto.dart';

class CadProduto extends StatefulWidget {

  @override
  _CadProdutoState createState() => new _CadProdutoState();
}

class _CadProdutoState extends State<CadProduto> {
  final campo1 = new TextEditingController();
  final campo2 = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> postProduto (Produto prod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = prefs.getString('URL');
    await http.post(URL + "/Produto",
        body: {
          'ValueTag': '${prod.ValueTag}',
          'CodBarras': '${prod.CodBarras}'},
        headers: {
          "Accept": "application/json"
        });
      campo1 .text = "";
      campo2 .text = "";

      new Alert().showAlertDialog(context, "Salvo com sucesso.");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Cadastro Produto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(hintText: 'TAG'),
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: campo1,
            ),
            new TextFormField(
              decoration: new InputDecoration(hintText: 'Cód. Barras'),
              keyboardType: TextInputType.number,
              maxLength: 10,
              controller: campo2,
            ),
            new RaisedButton(
              onPressed: () {
                Produto produto = new Produto();
                produto.ValueTag = campo1.text;
                produto.CodBarras = campo2.text;
                postProduto(produto);
                return true;
              },
              child: Text("Salvar"),
              textTheme: ButtonTextTheme.primary,
            )
          ],
        ),
      ),
    );
  }
}