import "dart:async";

import "package:flutter_string_encryption/flutter_string_encryption.dart";
import "package:info_manager/service/file_service.dart";
import "package:info_manager/service/encrypt_service.dart";

class UserService {
    static Future<bool> login(String password) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            String content = await FileService.getFileContent();

            try {
                await EncryptService.decryptStr(password, content);
                return true;
            } on MacMismatchException {
                return false;
            }

        }
        return true;
    }
}