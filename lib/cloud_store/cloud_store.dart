typedef void StoreCallback(dynamic error, [dynamic data]);

abstract class CloudStore {
    isFileExists(String fileName, StoreCallback callback);
    saveFile(String fileName, String content, StoreCallback callback);
    downloadFile(String fileName, StoreCallback callback);
}
