import "package:flutter/services.dart";

import "../configure/app_configure.dart";
import "../types.dart";

class HardwareService {
    static final MethodChannel platform = new MethodChannel(APP_CONFIGURE["HARDWARE_CHANNEL_NAME"]);

    static void isSupportFingerPrint(AsyncCallback callback) async {
        try {
            bool isExist = await platform.invokeMethod("isSupportFingerPrint");
            callback(null, data: isExist);
        } catch (e) {
            callback(e);
        }
    }
}