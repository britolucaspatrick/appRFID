import 'package:apprfid/Utils/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Model/Produto.dart';
import 'Service/ProdutoService.dart';

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
                postProduto(produto, context);
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

  void postProduto(Produto produto, BuildContext context) {
    new Alert().showAlertDialog(context, ProdutoService().postProduto(produto).toString());
    campo1.text = "";
    campo2.text = "";
  }
}