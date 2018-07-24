import "package:info_manager/model/category.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/user_info.dart";

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
    }) : userInfo = info ?? new UserInfo();
}
