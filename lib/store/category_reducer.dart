import "package:redux/redux.dart";

import "../store/app_actions.dart";
import "../model/category.dart";

final categoryReducer = combineReducers<List<Category>>([
    new TypedReducer<List<Category>, SetCategoriesAction>(_setCategories),
    new TypedReducer<List<Category>, AddCategoryAction>(_addCategory),
    new TypedReducer<List<Category>, DeleteCategoryAction>(_deleteCategory)
]);

List<Category> _setCategories(List<Category> categories, SetCategoriesAction action) {
    return action.categories;
}

List<Category> _addCategory(List<Category> categories, AddCategoryAction action) {
    return new List.from(categories)..add(action.category);
}

List<Category> _deleteCategory(List<Category> categories, DeleteCategoryAction action) {
    List<Category> copy = List.from(categories);

    Category removeCategory = copy.firstWhere((item) => item.id == action.category.id, orElse: () => null);

    if (removeCategory != null) {
        copy.remove(removeCategory);
    }

    return copy;
}
