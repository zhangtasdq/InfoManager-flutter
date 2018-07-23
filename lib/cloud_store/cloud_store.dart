typedef void StoreCallback(dynamic error, [dynamic data]);

abstract class CloudStore {
    isFileExists(String fileName, StoreCallback callback);
}
