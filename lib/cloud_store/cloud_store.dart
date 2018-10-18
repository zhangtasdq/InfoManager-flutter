import "../types.dart";

abstract class CloudStore {
    isFileExists(String fileName, AsyncCallback callback);
    saveFile(String fileName, String content, AsyncCallback callback);
    downloadFile(String fileName, AsyncCallback callback);
}
