import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/category.dart";

final categoryReducer = combineReducers<List<Category>>([
    new TypedReducer<List<Category>, SetCategoriesAction>(_setCategories)
]);


List<Category> _setCategories(List<Category> categories, SetCategoriesAction action) {
    return action.categories;
}
