import "../cloud_store/cloud_store.dart";
import "../cloud_store/one_drive_store.dart";
import "../types.dart";

class CloudStoreService {
    static CloudStore oneDriveStore = new OneDriveStore();

    static isFileExists(String fileName, AsyncCallback callback,
        {String saveType = "oneDrive"}) {
        CloudStore store;
        if (saveType == "oneDrive") {
            store = oneDriveStore;
        }

        if (store != null) {
            store.isFileExists(fileName, callback);
        }
    }

    static saveFile(String fileName, String content, AsyncCallback callback,
        {String saveType = "oneDrive"}) {

        CloudStore store;
        if (saveType == "oneDrive") {
            store = oneDriveStore;
        }

        store.saveFile(fileName, content, callback);
    }

    static downloadFile(String fileName, AsyncCallback callback,
        {String saveType = "oneDrive"}) {

        CloudStore store;

        if (saveType == "oneDrive") {
            store = oneDriveStore;
        }

        store.downloadFile(fileName, callback);
    }
}