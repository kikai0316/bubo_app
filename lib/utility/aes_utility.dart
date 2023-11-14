import 'dart:convert';

import 'package:bubu_app/component/aes_key.dart';
import 'package:encrypt/encrypt.dart';

Future<String?> aesEncryption(String message, int index) async {
  try {
    final decode = base64Decode(aesKeyList[index]);
    final aesKey = Key(decode);
    final iv = IV.fromLength(16);
    final encrypted =
        Encrypter(AES(aesKey, mode: AESMode.ecb)).encrypt(message, iv: iv);
    return encrypted.base64;
  } catch (e) {
    return null;
  }
}

Future<String?> aesDecryption(String base64EncryptedMessage, int index) async {
  try {
    final decode = base64Decode(aesKeyList[index]);
    final aesKey = Key(decode);
    final iv = IV.fromLength(16);
    final decrypted = Encrypter(AES(aesKey, mode: AESMode.ecb))
        .decrypt(Encrypted.fromBase64(base64EncryptedMessage), iv: iv);
    return decrypted;
  } catch (e) {
    return null;
  }
}
