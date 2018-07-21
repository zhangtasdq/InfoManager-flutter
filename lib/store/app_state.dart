import "package:info_manager/model/category.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/user_info.dart";

class AppState {
    final List<Info> infos;
    final List<Category> categories;
    final UserInfo userInfo;

    AppState({
        this.infos = const [],
        this.categories = const [],
        UserInfo info
    }) : userInfo = info ?? new UserInfo();
}