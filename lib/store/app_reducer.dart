import "../store/app_actions.dart";
import "../store/app_state.dart";
import "../store/info_reducer.dart";
import "../store/user_info_reducer.dart";
import "../store/category_reducer.dart";

bool isInitReducer(bool previous, action) {
    if (action is SetListenStoreStatusAction) {
        return action.status;
    }
    return previous;
}

AppState appReducer(AppState state, action) {
    if (action is ResetAppAction) {
        return AppState();
    }

    return AppState(
        infos: infosReducer(state.infos, action),
        isListen: isInitReducer(state.isListen, action),
        info: userInfoReducer(state.userInfo, action),
        categories: categoryReducer(state.categories, action)
    );
}
