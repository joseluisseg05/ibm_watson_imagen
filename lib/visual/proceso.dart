import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:ibm_watson_imagen/ibm_watson_imagen.dart';

Stream<String> StreamIdentify({
  @required File imagen,
  @required String apikey,
  @required String urlApi,
  @required String lenguaje,
}) async* {
  ApiOpciones options = await ApiOpciones(apiKey: apikey, url: urlApi).build();
  VisualRecognitionWatsonImage visualRecognition =
      new VisualRecognitionWatsonImage(apiOptions: options, language: lenguaje);
  ClassifiedImages classifiedImages =
      await visualRecognition.classifyImageFile(imagen.path);
  String out = classifiedImages
      .getImages()[0]
      .getClassifiers()[0]
      //.getClasses()[0]
      //.className;
      .toString();
  yield out;
}
