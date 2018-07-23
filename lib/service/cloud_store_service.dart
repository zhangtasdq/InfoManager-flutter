import "package:info_manager/cloud_store/cloud_store.dart";
import "package:info_manager/cloud_store/one_drive_store.dart";

class CloudStoreService {
    static CloudStore oneDriveStore = new OneDriveStore();


    static isFileExists(String fileName, StoreCallback callback, {String saveType = "oneDrive"}) {
        CloudStore store;
        if (saveType == "oneDrive") {
            store = oneDriveStore;
        }

        if (store != null) {
            store.isFileExists(fileName, callback);
        }
    }
}