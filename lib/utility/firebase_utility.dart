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
      await storagedb
          .ref(
            '${userData.id}/${"${userData.name}@${userData.birthday.split(' / ').join()}@${userData.family}@$i"} ',
          )
          .putData(imgList[i]);
      onStream(i + 1);
    }

    return true;
  } catch (e) {
    return false;
  }
}

Future<UserData?> getImg(String id) async {
  try {
    final List<Uint8List> list = [];
    final result = await FirebaseStorage.instance.ref(id).listAll();
    for (final ref in result.items) {
      final Uint8List? getDate = await ref.getData();
      if (getDate != null) {
        list.add(getDate);
      }
    }
    final List<String> parts = result.items.first.name.split('@');
    return UserData(
      imgList: list,
      id: id,
      name: parts[0],
      birthday: parts[1],
      family: parts[2],
    );
  } on FirebaseException {
    return null;
  }
}
