import "dart:async";

import "../service/file_service.dart";
import "../service/encrypt_service.dart";

class UserService {
    static Future<bool> login(String password) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            String content = await FileService.getFileContent();

            try {
                await EncryptService.decryptStr(password, content);
                return true;
            } catch (e) {
                return false;
            }
        }
        return true;
    }
}