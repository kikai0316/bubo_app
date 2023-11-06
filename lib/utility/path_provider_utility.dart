import 'dart:convert';
import 'dart:io';

import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/ticket_list.dart';
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
      "instagram": data.instagram,
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
      instagram: toDecode["instagram"] as String,
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

Future<void> writeHistoryData(List<String> data) async {
  try {
    final file = await _localFile("history");
    final jsonList = jsonEncode([data]);
    await file.writeAsString(jsonList);
  } catch (e) {
    return;
  }
}

Future<List<String>> readHistoryData() async {
  try {
    final file = await _localFile("history");
    final rawData = await file.readAsString();
    final List<String> storyList = List<String>.from(
      jsonDecode(rawData) as Iterable<dynamic>,
    );
    return storyList;
  } catch (e) {
    return [];
  }
}

Future<bool> writeTicketData(TicketList data) async {
  try {
    final freeList = data.free
        .map(
          (data) => {
            "id": data.id,
            "date": data.acquisitionAt.toString(),
          },
        )
        .toList();
    final ad = data.ad
        .map(
          (data) => {
            "id": data.id,
            "date": data.acquisitionAt.toString(),
          },
        )
        .toList();
    final setData = [freeList, ad];
    final file = await _localFile("ticket");
    final jsonList = jsonEncode(setData);
    await file.writeAsString(jsonList);
    return true;
  } catch (e) {
    return false;
  }
}

Future<TicketList> readTicketData() async {
  try {
    final file = await _localFile("ticket");
    final rawData = await file.readAsString();
    final List<dynamic> decodedJson = List<dynamic>.from(
      jsonDecode(rawData) as Iterable<dynamic>,
    );
    final List<List<Map<String, dynamic>>> ticketyList =
        decodedJson.map((dynamicList) {
      return (dynamicList as List<dynamic>).map((mapItem) {
        return mapItem as Map<String, dynamic>;
      }).toList();
    }).toList();
    final free = ticketyList[0]
        .map(
          (Map<String, dynamic> value) => TicketData(
            id: value["id"]! as String,
            acquisitionAt: DateTime.parse(value["date"]! as String),
          ),
        )
        .toList();
    final ad = ticketyList[1]
        .map(
          (Map<String, dynamic> value) => TicketData(
            id: value["id"]! as String,
            acquisitionAt: DateTime.parse(value["date"]! as String),
          ),
        )
        .toList();
    return TicketList(free: free, ad: ad);
  } catch (e) {
    return const TicketList(free: [], ad: []);
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
        "instagram": item.instagram,
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
        instagram: item["instagram"] as String,
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

Future<bool> writeMessageData(List<MessageList> data) async {
  try {
    final list = [];
    for (final item in data) {
      final setData = <String, dynamic>{
        "id": item.userData.id,
        "name": item.userData.name,
        "message": item.message
            .map(
              (m) => {
                "isMyMessage": m.isMyMessage,
                "message": m.message,
                "isRead": m.isRead,
                "dateTime": m.dateTime.toString(),
              },
            )
            .toList(),
      };
      list.add(setData);
    }
    final file = await _localFile("message");
    final jsonList = jsonEncode(list);
    await file.writeAsString(jsonList);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<MessageList>> readeMessageData() async {
  try {
    final List<MessageList> list = [];
    final file = await _localFile("message");
    final rawData = await file.readAsString();
    final List<Map<String, dynamic>> storyList =
        List<Map<String, dynamic>>.from(
      jsonDecode(rawData) as Iterable<dynamic>,
    );
    for (final item in storyList) {
      final messageListDecode =
          (item["message"] as List<dynamic>).map((dynamic m) {
        final Map<String, dynamic> cast = m as Map<String, dynamic>;
        return MessageData(
          isMyMessage: cast["isMyMessage"] as bool,
          message: cast["message"] as String,
          dateTime: DateTime.parse(
            cast["dateTime"] as String,
          ),
          isRead: cast["isRead"] as bool,
        );
      }).toList();
      final setData = MessageList(
        userData: UserData(
          id: item["id"] as String,
          name: item["name"] as String,
          imgList: [],
          birthday: "",
          family: "",
          instagram: "",
          isGetData: false,
          isView: false,
          acquisitionAt: null,
        ),
        message: messageListDecode,
      );
      list.add(setData);
    }
    return list;
  } catch (e) {
    return [];
  }
}

Future<bool> deleteAllFile(String id) async {
  final fileName = ["user", "story", "message", "history", "ticket"];
  try {
    for (int i = 0; i < fileName.length; i++) {
      final file = await _localFile(fileName[i]);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}
