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

    static Future<bool> setIsEnableDeleteFile(bool isEnable) async {
        SharedPreferences sharedPreferences = await getInstance();

        return sharedPreferences.setBool(APP_CONFIGURE["IS_ENABLE_DELETE_FILE_KEY"], isEnable);

    }

}