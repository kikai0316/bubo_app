import 'package:bubu_app/model/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

Future<bool> upLoadImg({
  required UserData userData,
  required List<Uint8List> imgList,
  required void Function(int) onStream,
}) async {
  final storagedb = FirebaseStorage.instance;
  try {
    for (int i = 0; i < imgList.length; i++) {
      if (i == 0) {
        await storagedb
            .ref(
              '${userData.id}/main/${"${userData.name}@${userData.birthday.split(' / ').join()}@${userData.family}@$i"} ',
            )
            .putData(imgList[i]);
      } else {
        await storagedb
            .ref(
              '${userData.id}/others/${"${userData.name}@${userData.birthday.split(' / ').join()}@${userData.family}@$i"} ',
            )
            .putData(imgList[i]);
      }

      onStream(i + 1);
    }

    return true;
  } catch (e) {
    return false;
  }
}

Future<UserData?> myDataGet(String id) async {
  try {
    final List<Uint8List> imgList = [];
    final List<String> userDataList = [];
    final resultMain = await FirebaseStorage.instance.ref("$id/main").listAll();
    final mainImgGet = await resultMain.items.first.getData();
    if (mainImgGet != null) {
      imgList.add(mainImgGet);
      final List<String> parts = resultMain.items.first.name.split('@');
      userDataList.addAll(parts);
    }
    final resultOthers =
        await FirebaseStorage.instance.ref("$id/others").listAll();
    for (final ref in resultOthers.items) {
      final Uint8List? getDate = await ref.getData();
      if (getDate != null) {
        imgList.add(getDate);
      }
    }
    if (imgList.isNotEmpty && userDataList.isNotEmpty) {
      return UserData(
        imgList: imgList,
        id: id,
        name: userDataList[0],
        birthday: userDataList[1],
        family: userDataList[2],
        isGetData: true,
        isView: false,
        acquisitionAt: null,
      );
    } else {
      return null;
    }
  } on FirebaseException {
    return null;
  }
}

Future<UserData?> imgMainGet(UserData userData) async {
  try {
    final List<Uint8List> imgList = [];
    // final List<String> userDataList = [];
    final resultMain =
        await FirebaseStorage.instance.ref("${userData.id}/main").listAll();
    final mainImgGet = await resultMain.items.first.getData();
    if (mainImgGet != null) {
      imgList.add(mainImgGet);
      final List<String> parts = resultMain.items.first.name.split('@');
      return UserData(
        imgList: imgList,
        id: userData.id,
        name: userData.name,
        birthday: parts[1],
        family: parts[2],
        isGetData: false,
        isView: false,
        acquisitionAt: userData.acquisitionAt,
      );
    } else {
      return null;
    }
  } on FirebaseException {
    return null;
  }
}
