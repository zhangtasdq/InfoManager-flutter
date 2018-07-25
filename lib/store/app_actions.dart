import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/model/user_info.dart";


class ResetAppAction {
}

class SetListenStoreStatusAction {
    final bool status;

    SetListenStoreStatusAction(this.status);
}

class AddInfoAction {
    final Info info;
    AddInfoAction(this.info);
}

class UpdateInfoAction {
    final Info info;

    UpdateInfoAction(this.info);
}

class DeleteInfoAction {
    final Info info;
    DeleteInfoAction(this.info);
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

class DeleteCategoryAction {
    final Category category;

    DeleteCategoryAction(this.category);
}

class SetUserInfoAction {
    final UserInfo userInfo;

    SetUserInfoAction(this.userInfo);
}
