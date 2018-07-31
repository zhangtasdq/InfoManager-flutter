import "dart:convert";
import "dart:async";

import "package:flutter_string_encryption/flutter_string_encryption.dart";
import "package:redux/redux.dart";

import "../model/category.dart";
import "../model/info.dart";
import "../model/user_info.dart";
import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../service/file_service.dart";
import "../util/password_padding.dart" show passwordPadding;
import "../configure/app_configure.dart";
import "../configure/status_code.dart";
import "../service/encrypt_service.dart";
import "../service/cloud_store_service.dart";
import "../types.dart";


class AppService {
    static Future<void> loadAppStateData(Store<AppState> store, AsyncCallback callback) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            AppState state = store.state;
            try {
                String encryptStr = await FileService.getFileContent();
                try {
                    String dataStr = await EncryptService.decryptStr(state.userInfo.password, encryptStr);
                    Map<String, dynamic> data = json.decode(dataStr);

                    if (data.containsKey("infos")) {
                        loadAppInfos(data["infos"], store);
                    }

                    if (data.containsKey("categories")) {
                        loadAppCategories(data["categories"], store);
                    }

                    if (data.containsKey("userInfo")) {
                        loadAppUserInfo(json.decode(data["userInfo"]), store);
                    }
                    callback(null, data: StatusCode.LOAD_DATA_SUCCESS);
                } catch (e) {
                    callback(e, data: StatusCode.DECRYPT_ERROR);
                }
            } catch (e) {
                callback(e, data: StatusCode.LOAD_FILE_CONTENT_ERROR);
            }
        } else {
            callback(null, data: StatusCode.LOAD_DATA_SUCCESS);
        }
    }


    static void loadAppInfos(List<dynamic> infos, Store<AppState> store) {
        List<Info> datas = [];

        infos.forEach((item) {
            Map<String, dynamic> infoJson = json.decode(item);

            datas.add(Info.fromJson(infoJson));
        });

        SetInfosAction action = SetInfosAction(datas);
        store.dispatch(action);
    }

    static void loadAppCategories(List<dynamic> categories, Store<AppState> store) {
        List<Category> datas = [];

        categories.forEach((item) {
            Map<String, dynamic> categoryJson = json.decode(item);
            datas.add(Category.fromJson(categoryJson));

        });

        SetCategoriesAction action = SetCategoriesAction(datas);
        store.dispatch(action);
    }

    static void loadAppUserInfo(Map<String, dynamic> userInfo, Store<AppState> store) {
        userInfo["password"] = store.state.userInfo.password;

        SetUserInfoAction action = SetUserInfoAction(UserInfo.fromJson(userInfo));

        store.dispatch(action);

    }

    static Future<void> deleteFile() async {
        return FileService.deleteFile();
    }

    static Future<void> saveAppStateData(AppState state) async {
        String dataStr = getSaveAppStateData(state);
        String decryptStr = await EncryptService.encryptStr(state.userInfo.password, dataStr);

        FileService.saveFileContent(decryptStr);
    }

    static String getSaveAppStateData(AppState state) {
        List<String> infos = state.infos.map((Info item) => json.encode(item)).toList();
        String userInfo = json.encode(state.userInfo.saveData);
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

        return cryptor.encrypt(content, key);
    }

    static backupInfo(AsyncCallback callback) async {
        bool isFileExist = await FileService.isFileExist();

        if (isFileExist) {
            String encryptStr = await FileService.getFileContent();
            String fileName = APP_CONFIGURE["INFO_FILE_NAME"];
            CloudStoreService.saveFile(fileName, encryptStr, callback);
        }
    }

    static restoreInfo(Store<AppState> store, AsyncCallback callback) async {
        String fileName = APP_CONFIGURE["INFO_FILE_NAME"];

        CloudStoreService.downloadFile(fileName, (downloadError, {dynamic data}) async {
            if (downloadError != null) {
                callback(downloadError, data: StatusCode.DOWNLOAD_FILE_ERROR);
            } else {
                if (data != null) {
                    await FileService.saveFileContent(data);
                    loadAppStateData(store, (error, {dynamic data}) {
                        if (error != null) {
                            callback(error, data: data);
                        } else {
                            callback(null, data: StatusCode.RESTORE_SUCCESS);
                        }
                    });
                } else {
                    callback(null, data: StatusCode.RESTORE_SUCCESS);
                }
            }

        });
    }
}