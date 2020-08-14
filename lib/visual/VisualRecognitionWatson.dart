import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ibm_watson_imagen/api/ApiOpciones.dart';
import 'package:ibm_watson_imagen/lang/LanguajeIbm.dart';
import 'package:meta/meta.dart';

class ClassResult {
  String className;
  double score;
  String typeHierarchy;

  ClassResult(Map result) {
    this.className = result["class"] ?? "";
    this.score = result["score"] ?? "";
    this.typeHierarchy = result["type_hierarchy"] ?? "";
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  dynamic toJson() {
    return {
      "class": this.className,
      "score": this.score,
      "type_hierarchy": this.typeHierarchy
    };
  }
}

class ClassifierResult {
  String _classifierId;
  String _name;
  List<ClassResult> _classes;

  ClassifierResult(Map item) {
    this._classifierId = item["classifier_id"] ?? "";
    this._name = item["name"] ?? "";
    _classes = new List<ClassResult>();
    for (Map result in item["classes"]) {
      _classes.add(new ClassResult(result));
    }
  }

  @override
  String toString() {
    return json.encode({
      "classifier_id": this._classifierId,
      "name": this._name,
      "classes": json.decode(this._classes.toString())
    });
  }

  List<ClassResult> getClasses() {
    return this._classes;
  }

  String getClassifierId() {
    return this._classifierId;
  }

  String getClassifierName() {
    return this._name;
  }
}

class ClassifiedImage {
  List<ClassifierResult> _classifiers;
  String sourceUrl;
  String resolvedUrl;
  String image;

  ClassifiedImage(Map resultImage) {
    this.sourceUrl = resultImage["source_url"] ?? "";
    this.resolvedUrl = resultImage["resolved_url"] ?? "";
    this.image = resultImage["image"] ?? "";
    _classifiers = new List<ClassifierResult>();
    for (Map item in resultImage["classifiers"]) {
      _classifiers.add(new ClassifierResult(item));
    }
  }

  List<ClassifierResult> getClassifiers() {
    return this._classifiers;
  }

  @override
  String toString() {
    return json.encode({
      "classifiers": json.decode(this._classifiers.toString()),
      "source_url": this.sourceUrl,
      "resolved_url": this.resolvedUrl,
      "image": this.image
    });
  }
}

class ClassifiedImages {
  List<ClassifiedImage> _images;
  int imagesProcessed;
  int customClasses;

  ClassifiedImages(Map response) {
    this.imagesProcessed = response["images_processed"] ?? "";
    this.customClasses = response["custom_classes"] ?? "";
    this._images = new List<ClassifiedImage>();
    for (Map image in response["images"]) {
      _images.add(new ClassifiedImage(image));
    }
  }

  List<ClassifiedImage> getImages() {
    return this._images;
  }

  @override
  String toString() {
    return json.encode({
      "images": json.decode(this._images.toString()),
      "images_processed": this.imagesProcessed,
      "custom_classes": this.customClasses
    });
  }
}

class VisualRecognitionWatsonImage {
  String urlApi = "https://gateway.watsonplatform.net/visual-recognition/api";
  ApiOpciones apiOptions;
  final String version;
  double threshold;
  String language;

  VisualRecognitionWatsonImage(
      {@required this.apiOptions,
      this.language = "en",
      this.version = "2018-03-19",
      this.threshold = 0.5});

  String _getUrlFile(String method) {
    String url = apiOptions.url;
    if (apiOptions.url == "" || apiOptions.url == null) {
      url = urlApi;
    }
    return "$url/v3/$method?version=$version";
  }

  Future<ClassifiedImages> classifyImageFile(String filePath) async {
    ClassifiedImages classifiedImages;
    String token = this.apiOptions.accessToken;
    var request = new http.MultipartRequest(
        "POST", Uri.parse(_getUrlFile("classify"))) //;
      ..fields['threshold'] = this.threshold.toString();
    var file = await http.MultipartFile.fromPath("images_file", filePath,
        contentType: new MediaType('application', '*'));
    await print('here inside the class ' + filePath);
    request.files.add(file);
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.acceptLanguageHeader: this.language ?? Language.ENGLISH,
    });
    var response = await request.send();
    var value = await response.stream.bytesToString();
    dynamic result;
    result = json.decode(value);
    classifiedImages = new ClassifiedImages(result);
    return classifiedImages;
  }
}
