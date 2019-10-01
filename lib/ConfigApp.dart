import 'package:apprfid/Utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfigApp extends StatefulWidget {

  @override
  _ConfigAppState createState() => new _ConfigAppState();
}

class _ConfigAppState extends State<ConfigApp> {
  final campo1 = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    campo1.text = prefs.getString('URL');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Configuração App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(hintText: 'URL'),
              keyboardType: TextInputType.text,
              controller: campo1,
            ),
            new RaisedButton(
              onPressed: _saveURLSharedPrefences,
              child: Text("Salvar"),
              textTheme: ButtonTextTheme.primary,
            )
          ],
        ),
      ),
    );
  }

  _saveURLSharedPrefences() async  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('URL', campo1.text.toString())
          .then((onValue)
          {
            new Alert().showAlertDialog(context, "Salvo com sucesso. \n"
                "URL: " + prefs.getString('URL'));
          }).catchError((onError)
          {
            new Alert().showAlertDialog(context, onError.toString());
          });
  }
}