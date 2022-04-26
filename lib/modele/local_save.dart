import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalSave{

  static final favoritesFileName = "favorites";
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    var file = File("$path/$favoritesFileName");
    if(file.existsSync()) return file;
    else{
      file = await File("$path/$favoritesFileName").create(recursive: true);
      return file;
    }
  }

  Future<List<int>> readIds() async{
    List<int> ids = [];
    try{
      final file = await _localFile;
      String content=  await file.readAsString();
      var stringIdList = content.split(";");
      stringIdList.removeLast();
      for(String stringId in stringIdList ){
        ids.add(int.parse(stringId));
      }
    }catch(e){
      print(e);
    }
    return ids;
  }

  Future<File> addId(int id) async{
    final file = await _localFile;
    String content=  await file.readAsString();
    return file.writeAsString(content + id.toString() +";");
  }

  Future<File> removeId(int id) async{
    final file = await _localFile;
    String content=  await file.readAsString();
    var splitted = content.split(";");
    splitted.removeWhere((item) => item == id.toString() || item.isEmpty);
    String modifiedContent = "";
    for(String id in splitted){
      modifiedContent += id + ";";
    }
    return file.writeAsString(modifiedContent);
  }
  
  Future<bool> isInFile(int id) async{
    final file = await _localFile;
    String content=  await file.readAsString();
    return content.split(";").contains(id.toString());
  }


}