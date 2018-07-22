import "dart:convert";
import "package:flutter_string_encryption/flutter_string_encryption.dart";
import "dart:async";
import "package:redux/redux.dart";

import "package:info_manager/model/category.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/user_info.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";
import "package:info_manager/service/file_service.dart";
import "package:info_manager/util/password_padding.dart" show passwordPadding;
import "package:info_manager/configure/app_configure.dart";
import "package:info_manager/service/encrypt_service.dart";

class AppService {
    static Future<void> loadAppStateData(Store<AppState> store) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            AppState state = store.state;
            String encryptStr = await FileService.getFileContent();
            String dataStr = await EncryptService.decryptStr(state.userInfo.getPassword(), encryptStr);
            Map<String, dynamic> data = json.decode(dataStr);

            print(dataStr);

            if (data.containsKey("infos")) {
                loadAppInfos(data["infos"], store);
            }

            if (data.containsKey("categories")) {
                loadAppCategories(data["categories"], store);
            }

            if (data.containsKey("userInfo")) {
                loadAppUserInfo(json.decode(data["userInfo"]), store);
            }
        }
    }

    static void loadAppInfos(List<dynamic> infos, Store<AppState> store) {
        List<Info> datas = [];
        if (infos.length > 0) {

            for (int i = 0, j = infos.length; i < j; ++i) {
                Map<String, dynamic> item = json.decode(infos[i]);

                datas.add(new Info.fromJson(item));
            }
        }

        SetInfosAction action = new SetInfosAction(datas);
        store.dispatch(action);
    }

    static void loadAppCategories(List<dynamic> categories, Store<AppState> store) {
        List<Category> datas = [];
        if (categories.length > 0) {
            for (int i = 0, j = categories.length; i < j; ++i) {
                Map<String, dynamic> item = json.decode(categories[i]);

                datas.add(new Category.fromJson(item));
            }
        }

        SetCategoriesAction action = new SetCategoriesAction(datas);
        store.dispatch(action);
    }

    static void loadAppUserInfo(Map<String, dynamic> userInfo, Store<AppState> store) {
        userInfo["password"] = store.state.userInfo.getPassword();

        SetUserInfoAction action = new SetUserInfoAction(new UserInfo.fromJson(userInfo));

        store.dispatch(action);

    }

    static Future<void> saveAppStateData(AppState state) async {
        String dataStr = getSaveAppStateData(state);
        print("save ==> $dataStr");
        String decryptStr = await EncryptService.encryptStr(state.userInfo.getPassword(), dataStr);

        FileService.saveFileContent(decryptStr);
    }

    static String getSaveAppStateData(AppState state) {
        List<String> infos = state.infos.map((Info item) => json.encode(item)).toList();
        String userInfo = json.encode(state.userInfo.getSaveData());
        List<String> categories = state.categories.map((Category item) => json.encode(item)).toList();

        Map<String, dynamic> data = {
            "infos": infos,
            "categories": categories,
            "userInfo": userInfo
        };


        return json.encode(data);

    }

    static Future<String> decryptContent(String password, String content) async {
        String paddingPassword = passwordPadding(password, APP_CONFIGURE["PASSWORD_LENGTH"]);
        PlatformStringCryptor cryptor = new PlatformStringCryptor();
        String key = await cryptor.generateKeyFromPassword(paddingPassword, "dd");

        print(paddingPassword);
        return cryptor.encrypt(content, key);
    }
}