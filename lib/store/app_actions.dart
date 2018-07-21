import "package:info_manager/model/info.dart";

class AddInfoAction {
    final Info info;
    AddInfoAction(this.info);
}

class SetPasswordAction {
    final String password;

    SetPasswordAction(this.password);
}