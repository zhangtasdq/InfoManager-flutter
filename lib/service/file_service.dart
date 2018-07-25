import "dart:io";
import "dart:async";
import "package:path_provider/path_provider.dart";

import "package:info_manager/configure/app_configure.dart";

class FileService {
    static Future<File> _getLocalFile() async {
        String dir = (await getApplicationDocumentsDirectory()).path,
               fileName = APP_CONFIGURE["INFO_FILE_NAME"];

        return new File("$dir/$fileName");
    }

    static Future<bool> isFileExist() async {
        File file = await _getLocalFile();

        return file.exists();
    }

    static Future<String> getFileContent() async {
        File file = await _getLocalFile();

        return file.readAsString();
    }

    static Future<Null> saveFileContent(String content) async {
        File file = await _getLocalFile();

        await file.writeAsString(content);
    }

    static Future<File> deleteFile() async {
        File file = await _getLocalFile();

        return file.delete();
    }
}
