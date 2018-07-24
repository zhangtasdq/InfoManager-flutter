import "package:fluttertoast/fluttertoast.dart";

class MsgMixin {
    showToast(String msg) {
        Fluttertoast.showToast( msg: msg );
    }
}