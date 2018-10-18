import "package:flutter/services.dart";

import "../configure/app_configure.dart";
import "../cloud_store/cloud_store.dart";
import "../types.dart";

class OneDriveStore extends CloudStore {
    MethodChannel platform;

    OneDriveStore() {
        this.platform = new MethodChannel(APP_CONFIGURE["ONE_DRIVE_CHANNEL_NAME"]);
    }

    isFileExists(String fileName, AsyncCallback callback) async {
        try {
            Map<String, dynamic> data = this.getDefaultParams();

            data["fileName"] = fileName;

            bool isExist = await platform.invokeMethod("isFileExists", data);

            callback(null, data: isExist);
        } catch (e) {
            callback(e);
        }
    }

    saveFile(String fileName, String content, AsyncCallback callback) async {
        try {
            Map<String, dynamic> data = this.getDefaultParams();

            data["fileName"] = fileName;
            data["content"] = content;

            bool success = await platform.invokeMethod("saveFile", data);

            callback(null, data: success);
        } catch (e) {
            callback(e);
        }
    }

    downloadFile(String fileName, AsyncCallback callback) async {
        try {
            Map<String, dynamic> data = this.getDefaultParams();

            data["fileName"] = fileName;

            String content = await platform.invokeMethod("downloadFile", data);
            callback(null, data: content);
        } catch (e) {
            callback(e);
        }
    }

    Map<String, dynamic> getDefaultParams() {
        Map<String, dynamic> params = new Map();

        params["clientId"] = APP_CONFIGURE["ONE_DRIVE_CLIENT_ID"];
        params["scope"] = APP_CONFIGURE["ONE_DRIVE_SCOPE"];

        return params;
    }
}