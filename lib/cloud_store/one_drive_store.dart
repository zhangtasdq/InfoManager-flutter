import "package:flutter/services.dart";

import "package:info_manager/configure/app_configure.dart";
import "package:info_manager/cloud_store/cloud_store.dart";

class OneDriveStore extends CloudStore {
    MethodChannel platform;

    OneDriveStore() {
        this.platform = new MethodChannel(APP_CONFIGURE["ONE_DRIVE_CHANNEL_NAME"]);
    }

    isFileExists(String fileName, StoreCallback callback) async {
        try {
            Map<String, dynamic> data = this.getDefaultParams();

            data["fileName"] = fileName;

            bool isExist = await platform.invokeMethod("isFileExists", data);

            callback(null, [isExist]);
        } on PlatformException catch (e) {
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