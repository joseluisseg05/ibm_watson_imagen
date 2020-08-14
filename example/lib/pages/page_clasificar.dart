import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibm_watson_imagen/ibm_watson_imagen.dart';

class PageClasificar extends StatefulWidget {
  PageClasificar({Key key}) : super(key: key);

  @override
  _PageClasificarState createState() => _PageClasificarState();
}

class _PageClasificarState extends State<PageClasificar> {
  String imagenPath;
  String _text;
  String datajson;
  String aux;
  var auxdata;

  String clasificador;
  String puntaje;
  String familia;

  StreamController controller = StreamController();

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    imagenPath = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Identificador'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Image.file(File(imagenPath), fit: BoxFit.cover),
            ),
            SizedBox(height: 30.0),
            StreamBuilder(
              stream: StreamIdentify(
                  imagen: File(imagenPath),
                  apikey: "VH1kpG25AwCapiLNjq9tKYJROK1TaGuY6cquuxmcHuYz",
                  urlApi: "https://api.us-south.visual-recognition.watson." +
                      "cloud.ibm.com/instances/8cf60f03-24d3-402f-9d61-710a90171303",
                  lenguaje: Language.SPANISH),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                datajson = snapshot.data;
                print(datajson);
                crear(datajson);
                return Center(
                  child: Column(
                    children: [
                      Text(
                        clasificador != null
                            ? 'La imagen es $clasificador'
                            : 'IBM Watson',
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        puntaje != null
                            ? 'Con un puntaje de $puntaje'
                            : 'IBM Watson',
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        familia != null
                            ? 'Pertenece a la familia de $familia'
                            : 'IBM Watson',
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  crear(String data) {
    var obj = jsonDecode(data);
    print("****:${obj["classes"]}***");
    Map<String, dynamic> map = json.decode(data);
    List<dynamic> datat = map["classes"];
    clasificador = datat[0]["class"];
    puntaje = (datat[0]["score"]).toString();
    familia = (datat[0]["type_hierarchy"]);
  }
}
