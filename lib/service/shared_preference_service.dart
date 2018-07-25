import "dart:async";
import "package:shared_preferences/shared_preferences.dart";

import "package:info_manager/configure/app_configure.dart";

class SharedPreferenceService {
    static SharedPreferences _instance;
    static Future<SharedPreferences> getInstance() async {
        if (_instance == null) {
            _instance = await SharedPreferences.getInstance();
        }
        return _instance;
    }

    static Future<bool> getIsEnableDeleteFile() async {
        SharedPreferences sharedPreferences = await getInstance();
        
        dynamic result = sharedPreferences.getBool(APP_CONFIGURE["IS_ENABLE_DELETE_FILE_KEY"]);

        if (result == null) {
            return false;
        }
        return result;
    }

    static Future<bool> getIsEnableFingerPrintUnlock() async {
        SharedPreferences sharedPreferences = await getInstance();

        dynamic result = sharedPreferences.getBool(APP_CONFIGURE["IS_ENABLE_FINGER_PRINT_UNLOCK_KEY"]);

        if (result == null) {
            return false;
        }
        return result;
    }

    static Future<String> getUserPassword() async {
        SharedPreferences sharedPreferences = await getInstance();

        dynamic result = sharedPreferences.getString(APP_CONFIGURE["USER_PASSWORD_KEY"]);

        if (result == null) {
            return "";
        }
        return result;
    }


    static Future<bool> setIsEnableDeleteFile(bool isEnable) async {
        SharedPreferences sharedPreferences = await getInstance();

        return sharedPreferences.setBool(APP_CONFIGURE["IS_ENABLE_DELETE_FILE_KEY"], isEnable);

    }

    static Future<bool> setIsEnableFingerPrintUnlock(bool isEnable) async {
        SharedPreferences sharedPreferences = await getInstance();

        return sharedPreferences.setBool(APP_CONFIGURE["IS_ENABLE_FINGER_PRINT_UNLOCK_KEY"], isEnable);
    }

    static Future<bool> setUserPassword(String password) async {
        SharedPreferences sharedPreferences = await getInstance();

        return sharedPreferences.setString(APP_CONFIGURE["USER_PASSWORD_KEY"], password);
    }

    static Future<bool> removeUserPassword() async {
        SharedPreferences sharedPreferences = await getInstance();

        return sharedPreferences.remove(APP_CONFIGURE["USER_PASSWORD_KEY"]);

    }

}