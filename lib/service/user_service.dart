import "dart:async";

import "package:flutter_string_encryption/flutter_string_encryption.dart";
import "package:info_manager/configure/app_configure.dart";
import "package:info_manager/service/file_service.dart";
import "package:info_manager/util/password_padding.dart";

class UserService {
    static Future<bool> login(String password) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            String content = await FileService.getFileContent(),
                   paddingPassword = passwordPadding(password, APP_CONFIGURE["PASSWORD_LENGTH"]);

            try {
                final cryptor = new PlatformStringCryptor();

                cryptor.decrypt(content, paddingPassword);
            } on MacMismatchException {
                return false;
            }

        }
        return true;
    }
}