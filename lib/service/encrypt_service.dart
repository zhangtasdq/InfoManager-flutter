import "package:flutter_string_encryption/flutter_string_encryption.dart";
import "dart:async";

import "package:info_manager/configure/app_configure.dart";
import "package:info_manager/util/password_padding.dart" show passwordPadding;

class EncryptService {
    static Future<String> encryptStr(String password, String content) async {
        PlatformStringCryptor cryptor = new PlatformStringCryptor();
        String key = await getKey(cryptor, password);

        return cryptor.encrypt(content, key);
    }

    static Future<String> decryptStr(String password, String content) async {
        PlatformStringCryptor cryptor = new PlatformStringCryptor();
        String key = await getKey(cryptor, password);

        return cryptor.decrypt(content, key);
    }

    static Future<String> getKey(PlatformStringCryptor cryptor, String password) {
        String paddingPassword = passwordPadding(password, APP_CONFIGURE["PASSWORD_LENGTH"]);

        return cryptor.generateKeyFromPassword(paddingPassword, APP_CONFIGURE["ENCRYPT_SALT"]);
    }
}
