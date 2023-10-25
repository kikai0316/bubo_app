import 'dart:convert';

import 'package:bubu_app/model/user_data.dart';

UserData toUserDataCast(Map<String, dynamic> data) {
  final imgListDecode = (data["img"] as List<dynamic>)
      .map((dynamic base64String) => base64Decode(base64String as String))
      .toList();
  final setData = UserData(
    id: data["id"] as String,
    name: data["name"] as String,
    birthday: data["birthday"] as String,
    family: "dsas",
    imgList: imgListDecode,
    isGetData: true,
    isView: data["isView"] as bool,
    acquisitionAt: null,
  );
  return setData;
}

Map<String, dynamic> toMapCast(UserData data) {
  final toBase64 = data.imgList.map((data) => base64Encode(data)).toList();
  final Map<String, dynamic> setData = <String, dynamic>{
    "id": data.id,
    "name": data.name,
    "img": toBase64,
    "birthday": data.birthday,
    "family": data.family,
    "isView": data.isView,
  };
  return setData;
}
