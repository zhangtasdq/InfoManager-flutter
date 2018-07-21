import "package:info_manager/store/app_actions.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/info_reducer.dart";
import "package:info_manager/store/user_info_reducer.dart";
import "package:info_manager/store/category_reducer.dart";

bool isInitReducer(bool previous, action) {
    if (action is SetIsInitAction) {
        return action.isInit;
    }
    return previous;
}

AppState appReducer(AppState state, action) {
    return new AppState(
        infos: infosReducer(state.infos, action),
        isInit: isInitReducer(state.isInit, action),
        info: userInfoReducer(state.userInfo, action),
        categories: categoryReducer(state.categories, action)
    );
}
