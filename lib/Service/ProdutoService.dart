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
    String str = "";

    await http.post(URL + "/Produto",
        body: {
          'ValueTag': '${prod.ValueTag}',
          'CodBarras': '${prod.CodBarras}',
          'Quantidade': '${prod.Quantidade}'
        },
        headers: {
          "Accept": "application/json"
        })
        .then((onValue)
    {
      str = "Salvo com sucesso";
    })
        .catchError((onError)
    {
      str = onError.toString();
    });

    return str;
  }

  void updateQuantidade (String ValueTag) {
    http.put(URL + "/values/${ValueTag}",
        headers: { "Accept": "application/json" }).then((value){print(value);}).catchError((error){print(error);});
  }



}

