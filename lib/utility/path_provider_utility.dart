import 'dart:convert';
import 'dart:io';

import 'package:bubu_app/model/user_data.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

Future<bool> writeUserData(UserData data) async {
  try {
    final file = await _localFile("user");
    final toBase64 = data.imgList.map((data) => base64Encode(data)).toList();
    final Map<String, dynamic> setData = <String, dynamic>{
      "id": data.id,
      "name": data.name,
      "img": toBase64,
    };
    final jsonList = jsonEncode(setData);
    await file.writeAsString(jsonList);
    return true;
  } catch (e) {
    return false;
  }
}

Future<UserData?> readUserData() async {
  try {
    final file = await _localFile("user");
    final String contents = await file.readAsString();

    final toDecode = jsonDecode(contents) as Map<String, dynamic>;

    final imgListDecode = (toDecode["img"] as List<dynamic>)
        .map((dynamic base64String) => base64Decode(base64String as String))
        .toList();
    final setData = UserData(
      id: toDecode["id"] as String,
      name: toDecode["name"] as String,
      imgList: imgListDecode,
    );
    return setData;
  } catch (e) {
    return null;
  }
}

Future<void> deleteUserData() async {
  try {
    final file = await _localFile("user");
    file.delete();
  } catch (e) {
    return;
  }
}
