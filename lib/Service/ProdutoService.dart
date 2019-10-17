import 'dart:convert' as convert;
import 'package:apprfid/Model/Produto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  static SharedPreferences prefs;
  static String URL;

  ProdutoService(){
    SharedPreferences.getInstance().then((value){
      prefs = value;
    });

    URL = prefs.getString('URL');

  }

  Future<String> postProduto (Produto prod) async {
    await http.post(URL + "/Produto",
        body: {
          'ValueTag': '${prod.ValueTag}',
          'CodBarras': '${prod.CodBarras}'},
        headers: {
          "Accept": "application/json"
        })
        .then((onValue)
    {
      return "Salvo com sucesso.";
    })
        .catchError((onError)
    {
      return onError.toString();
    });
  }

  void IncrementTag(String ValueTag) {
    Produto prod;
    http.get(URL + "/values/${ValueTag}",
        headers: { "Accept": "application/json" })
        .then((value)
    {
      if (value.statusCode == 200) {
        prod = convert.jsonDecode(value.body);

        prod.Quantidade == null || prod.Quantidade == 0 ? prod.Quantidade = 1 : prod.Quantidade++;

        http.post(URL + "/Produto",
            body: {
              'ID_Produto': '${prod.ID_Produto}',
              'Qualidade': '${prod.Quantidade}',
              'ValueTag': '${prod.ValueTag}',
              'CodBarras': '${prod.CodBarras}'},
            headers: {
              "Accept": "application/json"
            });
      }
    });
  }

}

