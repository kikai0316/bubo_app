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

Future<bool> writeUserData(
  UserData data,
) async {
  try {
    final file = await _localFile("user");
    final toBase64 = data.imgList.map((data) => base64Encode(data)).toList();
    final Map<String, dynamic> setData = <String, dynamic>{
      "id": data.id,
      "name": data.name,
      "img": toBase64,
      "birthday": data.birthday,
      "family": data.family,
      "isView": data.isView,
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
      birthday: toDecode["birthday"] as String,
      family: "dsas",
      imgList: imgListDecode,
      isGetData: true,
      isView: toDecode["isView"] as bool,
      acquisitionAt: null,
    );
    return setData;
  } catch (e) {
    return null;
  }
}

Future<bool> writeStoryData(List<UserData> data) async {
  try {
    final list = [];
    for (final item in data) {
      final toBase64 = item.imgList.map((data) => base64Encode(data)).toList();
      final setData = <String, dynamic>{
        "img": toBase64,
        "id": item.id,
        "name": item.name,
        "birthday": item.birthday,
        "family": item.family,
        "isGetData": item.isGetData,
        "isView": item.isView,
        "acquisitionAt": item.acquisitionAt.toString(),
      };
      list.add(setData);
    }
    final file = await _localFile("story");
    final jsonList = jsonEncode(list);
    await file.writeAsString(jsonList);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<UserData>> readStoryData() async {
  try {
    final List<UserData> list = [];
    final file = await _localFile("story");
    final rawData = await file.readAsString();
    final List<Map<String, dynamic>> storyList =
        List<Map<String, dynamic>>.from(
      jsonDecode(rawData) as Iterable<dynamic>,
    );

    for (final item in storyList) {
      final imgListDecode = (item["img"] as List<dynamic>)
          .map((dynamic base64String) => base64Decode(base64String as String))
          .toList();
      final setData = UserData(
        imgList: imgListDecode,
        id: item["id"] as String,
        name: item["name"] as String,
        birthday: item["birthday"] as String,
        family: item["family"] as String,
        isGetData: item["isGetData"] as bool,
        isView: item["isView"] as bool,
        acquisitionAt: DateTime.parse(
          item["acquisitionAt"] as String,
        ),
      );
      list.add(setData);
    }
    return list;
  } catch (e) {
    return [];
  }
}

// Future<void> deleteUserData() async {
//   try {
//     final file = await _localFile("user");
//     file.delete();
//   } catch (e) {
//     return;
//   }
// }

// Future<UserData?> read() async {
//   try {
//     final file = await _localFile("user");
//     if (await file.exists()) {
//       final jsonString = await file.readAsString();
//       final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
//       final imgListDecode = (jsonData["img"] as List<dynamic>)
//           .map((dynamic base64String) => base64Decode(base64String as String))
//           .toList();
//       return UserData(
//         id: jsonData["id"] as String,
//         name: jsonData["name"] as String,
//         imgList: imgListDecode,
//         birthday: jsonData["birthday"] as String,
//         family: jsonData["family"] as String,
//       );
//     } else {
//       return null;
//     }
//   } catch (e) {
//     return null;
//   }
// }
