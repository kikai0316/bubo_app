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
              '${userData.id}/main/${"${userData.name}@${userData.birthday}@${userData.family}@${userData.instagram}@$i"} ',
            )
            .putData(imgList[i]);
      } else {
        await storagedb
            .ref(
              '${userData.id}/others/$i',
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
        instagram: userDataList[3],
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

Future<UserData?> imgMainGet(String id) async {
  try {
    final resultMain = await FirebaseStorage.instance.ref("$id/main").listAll();
    if (resultMain.items.isNotEmpty) {
      final mainImgGet = await resultMain.items.first.getData();
      if (mainImgGet != null) {
        final List<String> parts = resultMain.items.first.name.split('@');
        return UserData(
          imgList: [mainImgGet],
          id: id,
          name: parts[0],
          birthday: parts[1],
          family: parts[2],
          instagram: parts[3],
          isGetData: false,
          isView: false,
          acquisitionAt: DateTime.now(),
        );
      }
    }
    return null;
  } on FirebaseException {
    return null;
  }
}

Future<UserData?> imgOtherGet(UserData userData) async {
  try {
    final List<Uint8List> imgList = [];
    final result =
        await FirebaseStorage.instance.ref("${userData.id}/others").listAll();
    for (final ref in result.items) {
      final Uint8List? getDate = await ref.getData();
      if (getDate != null) {
        imgList.add(getDate);
      }
    }

    return UserData(
      imgList: [...userData.imgList, ...imgList],
      id: userData.id,
      name: userData.name,
      birthday: userData.birthday,
      family: userData.family,
      instagram: userData.instagram,
      isGetData: true,
      isView: userData.isView,
      acquisitionAt: userData.acquisitionAt,
    );
  } on FirebaseException {
    return null;
  }
}

Future<bool> userDataUpData(UserData userData) async {
  try {
    final storagedb = FirebaseStorage.instance;
    final result = await storagedb.ref("${userData.id}/main").listAll();
    for (final ref in result.items) {
      await ref.delete();
    }
    await storagedb
        .ref(
          '${userData.id}/main/${"${userData.name}@${userData.birthday}@${userData.family}@${userData.instagram}@0"} ',
        )
        .putData(userData.imgList.first);
    return true;
  } on FirebaseException {
    return false;
  }
}

Future<bool> dbImgAllDelete(
  UserData userData,
) async {
  try {
    final storagedb = FirebaseStorage.instance;
    final resultMain = await storagedb.ref("${userData.id}/main").listAll();
    for (final ref in resultMain.items) {
      await ref.delete();
    }
    final resultOthers = await storagedb.ref("${userData.id}/others").listAll();
    for (final ref in resultOthers.items) {
      await ref.delete();
    }
    return true;
  } on FirebaseException {
    return false;
  }
}

Future<bool> comparisonUpLoad({
  required UserData userData,
  required List<Uint8List> newImgList,
  required void Function(int) onStream,
}) async {
  try {
    final storagedb = FirebaseStorage.instance;
    if (userData.imgList.first != newImgList.first) {
      await storagedb
          .ref(
            '${userData.id}/main/${"${userData.name}@${userData.birthday}@${userData.family}@0"} ',
          )
          .putData(newImgList.first);
    }
    onStream(1);
    final resultOthers = await storagedb.ref("${userData.id}/others").listAll();
    for (final ref in resultOthers.items) {
      await ref.delete();
    }
    for (int i = 1; i < newImgList.length; i++) {
      await storagedb
          .ref(
            '${userData.id}/others/${"${userData.name}@${userData.birthday}@${userData.family}@$i"} ',
          )
          .putData(newImgList[i]);
      onStream(i);
    }
    return true;
  } on FirebaseException {
    return false;
  }
}
