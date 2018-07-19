import "package:info_manager/model/category.dart";
import "package:info_manager/model/info.dart";

class AppState {
    final List<Info> infos;
    final List<Category> categories;

    AppState({
        this.infos = const [],
        this.categories = const []
    });
}