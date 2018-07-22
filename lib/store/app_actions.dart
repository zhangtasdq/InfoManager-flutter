import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/model/user_info.dart";

class SetIsInitAction {
    final bool isInit;

    SetIsInitAction(this.isInit);
}

class AddInfoAction {
    final Info info;
    AddInfoAction(this.info);
}


class SetPasswordAction {
    final String password;

    SetPasswordAction(this.password);
}

class SetInfosAction {
    final List<Info> infos;

    SetInfosAction(this.infos);
}

class SetCategoriesAction {
    final List<Category> categories;

    SetCategoriesAction(this.categories);
}

class AddCategoryAction {
    final Category category;

    AddCategoryAction(this.category);
}

class SetUserInfoAction {
    final UserInfo userInfo;

    SetUserInfoAction(this.userInfo);
}
