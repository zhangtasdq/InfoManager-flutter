import "../model/category.dart";
import "../model/info.dart";
import "../model/user_info.dart";

class AppState {
    List<Info> infos;
    List<Category> categories;
    UserInfo userInfo;
    bool isListen;

    AppState({
        this.infos = const [],
        this.categories = const [],
        this.isListen = false,
        UserInfo info
    }) : userInfo = info ?? UserInfo();
}
